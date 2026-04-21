# plan-review

A Claude Code skill for iterative plan review via OpenAI Codex. Claude writes an implementation plan, sends it to Codex for critical review, then revises and re-submits until Codex approves (up to 5 rounds).

## Attribution

Derivative of [**codex-review** by Aseem Shrey (@AseemShrey)](https://aseemshrey.in/blog/claude-codex-iterative-plan-review/), originally published February 2026 ([Gist](https://gist.github.com/LuD1161/84102959a9375961ad9252e4d16ed592), [official plugin](https://codex-review.aseemshrey.in/)).

Changes from the original:

- Japanese-language output
- Robust session ID extraction via stderr capture
- Persistent plan files under `.claude/plan/<YYYYMMDD>-<HHMM>-<topic>.md`
- `--skip-git-repo-check` for non-git directories
- Model/reasoning effort inherited from Codex config.toml
- Additional "Design quality" review focus
- Frontmatter fixes (`user-invocable` with hyphen)

## Prerequisites

- [Claude Code](https://claude.ai/code)
- [OpenAI Codex CLI](https://developers.openai.com/codex/cli): `npm install -g @openai/codex`
- `codex login`
- (Optional) `~/.codex/config.toml` with preferred model / reasoning effort

## Installation

Copy `SKILL.md` into your Claude skills directory:

```bash
# Default location
mkdir -p ~/.claude/skills/plan-review
cp SKILL.md ~/.claude/skills/plan-review/

# If using XDG Base Directory with CLAUDE_CONFIG_DIR=$HOME/.config/claude
mkdir -p ~/.config/claude/skills/plan-review
cp SKILL.md ~/.config/claude/skills/plan-review/
```

## Usage

1. Make a plan (plan mode or conversation).
2. Run `/plan-review`.
3. Claude writes the plan to `.claude/plan/<YYYYMMDD>-<HHMM>-<topic>.md` and sends it to Codex.
4. Codex responds with `VERDICT: APPROVED` or `VERDICT: REVISE`.
5. On `REVISE`, Claude revises and re-submits (up to 5 rounds).

## Notes

- Review output is in Japanese by default. Edit `SKILL.md` (search for "Japanese") to change.
- Plan files persist at `.claude/plan/`. Gitignore or commit per project preference.
- Codex is always invoked with `-s read-only`. Plan revisions are done by Claude.

## License

MIT. Original codex-review design copyright (c) Aseem Shrey.
