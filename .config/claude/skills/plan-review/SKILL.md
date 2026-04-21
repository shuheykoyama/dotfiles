---
name: plan-review
description: Send the current design or implementation plan to OpenAI Codex for iterative critical review, with Claude revising based on feedback until approval (up to 5 rounds). Use this skill whenever the user asks to review a plan, design, or spec — including phrases like "計画をレビュー", "設計をチェック", "Codexに見てもらう", or when the user wants a second opinion before implementation on changes involving auth, data models, concurrency, architecture, or multi-day implementations.
user-invocable: true
allowed-tools: Bash, Read, Write, Edit
---

# Plan Review (Iterative, via Codex)

Send the current design or implementation plan to OpenAI Codex for critical review. Claude revises the plan based on Codex feedback and re-submits until Codex approves. Max 5 rounds.

---

## When to Invoke

- User runs `/plan-review`
- User asks for a review of a plan, design, or spec
- Plan touches auth, data models, concurrency, architecture, or takes days to implement

## Agent Instructions

Perform the iterative review loop below.

### Step 1: Determine plan path

1. Generate a short English kebab-case `topic` describing the plan (2-4 words, e.g., `auth-refactor`, `payment-gateway`).
2. Build slug and path:

```bash
   TS="$(date +%Y%m%d-%H%M)"
   SLUG="${TS}-${topic}"
   PLAN_PATH=".claude/plan/${SLUG}.md"
   mkdir -p .claude/plan
```

3. If `${PLAN_PATH}` already exists (extremely rare — same minute, same topic), append `-2`, `-3`, etc., or ask the user.

### Step 2: Write plan to file

Use the Write tool to save the current plan (from plan mode or conversation context) to `${PLAN_PATH}`.

If no plan exists in context, ask the user what to review before proceeding.

### Step 3: Generate review ID for tempfiles

```bash
REVIEW_ID=$(uuidgen | tr '[:upper:]' '[:lower:]' | head -c 8)
```

### Step 4: Initial Review (Round 1)

Do NOT pass `-m` or reasoning flags — model and effort come from `.codex/config.toml` (project) or `~/.codex/config.toml` (user).

```bash
codex exec \
  --skip-git-repo-check \
  -s read-only \
  -o /tmp/codex-review-${REVIEW_ID}.md \
  "Review the plan in ${PLAN_PATH}.

Focus on:
1. Correctness — Will this plan achieve the stated goals?
2. Risks — Edge cases, failure modes, data loss, rollback.
3. Missing steps — Anything forgotten?
4. Alternatives — Simpler or safer approach?
5. Security — Authentication, authorization, input validation, secrets handling.
6. Design quality — Module boundaries, coupling, extensibility (if design-level plan).

Be specific and actionable. Cite file or section names when possible.

End your review with exactly one of:
- VERDICT: APPROVED — plan is solid and ready to implement.
- VERDICT: REVISE — changes are needed." \
  2> /tmp/codex-stderr-${REVIEW_ID}.log
```

**Capture session ID from stderr log** (Codex writes startup header including `session id: <uuid>` to stderr):

```bash
CODEX_SESSION_ID=$(grep -m1 "session id:" /tmp/codex-stderr-${REVIEW_ID}.log | awk '{print $NF}')
```

If `CODEX_SESSION_ID` is empty, fall back to reading the full log and ask the user to investigate. Do NOT use `--last` — not concurrency-safe.

### Step 5: Read review and check verdict

1. Read `/tmp/codex-review-${REVIEW_ID}.md` with the Read tool.
2. Present to user in Japanese:

```
   ## Codex レビュー — Round N

   [Codexの指摘内容]
```

3. Check verdict:
   - **VERDICT: APPROVED** → Step 8
   - **VERDICT: REVISE** → Step 6
   - No clear verdict but feedback is entirely positive → treat as approved
   - Max rounds (5) reached → Step 8 with unapproved note

### Step 6: Revise the plan

For each Codex point:

- Valid: address in plan
- Invalid or conflicts with user's explicit requirements: skip, and note the reason for the user

Rewrite `${PLAN_PATH}` with revised version (Edit tool).

Summarize changes in Japanese:

```
### 改訂（Round N）
- [Codexの指摘 → 対応内容 または スキップ理由]
```

Inform: 「改訂版をCodexに再レビュー依頼します...」

### Step 7: Re-submit (Rounds 2-5)

`codex exec resume` does NOT support `-o`. Send stderr to `/dev/null` so stdout contains only the final message:

```bash
codex exec resume ${CODEX_SESSION_ID} \
  --skip-git-repo-check \
  "Plan revised. Updated plan is in ${PLAN_PATH}.

Changes in this round:
[Bullet list]

Re-review whether prior issues are resolved. Raise any new concerns. End with:
- VERDICT: APPROVED
- VERDICT: REVISE" \
  2>/dev/null > /tmp/codex-review-${REVIEW_ID}.md
```

**Fallback:** If `resume` fails (expired session, error), run a fresh `codex exec` with prior context included in the prompt, and re-capture session ID.

Return to **Step 5**.

### Step 8: Final result

**Approved:**

```
## Codex レビュー — Final

**ステータス:** ✅ N ラウンド目で承認

[最終フィードバック]

---
計画は `${PLAN_PATH}` に保存されました。実装に進んでよいか確認してください。
```

**Max rounds without approval:**

```
## Codex レビュー — Final

**ステータス:** ⚠️ 最大ラウンド (5) 到達、未承認

**残課題:**
[未解決の項目]

---
Codexはまだ懸念を残しています。計画は `${PLAN_PATH}` に保存済みです。継続改訂するか、残課題を理解した上で進めるか判断してください。
```

### Step 9: Cleanup

```bash
rm -f /tmp/codex-review-${REVIEW_ID}.md /tmp/codex-stderr-${REVIEW_ID}.log
```

Plan file at `${PLAN_PATH}` is a project artifact — keep it.

## Rules

- Claude **actively revises** the plan between rounds — make real improvements, not message passing.
- Always use `-s read-only` to make the sandbox explicit (also matches `codex exec` default).
- Do NOT hardcode model flags — inherit from `.codex/config.toml`.
- Max 5 rounds.
- Show each round's feedback and revisions in Japanese.
- If Codex CLI is missing or fails (check with `command -v codex`), inform the user and suggest `npm install -g @openai/codex`.
- If `codex login` is not done, surface the authentication error to the user.
- If a Codex suggestion contradicts user's explicit requirements, skip and explain.
- Never overwrite an existing plan file without confirmation.
