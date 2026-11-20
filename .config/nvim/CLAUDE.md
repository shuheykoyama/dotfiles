# Neovim Configuration

Personal Neovim configuration. Built ground-up with a focus on Neovim 0.11+ native APIs, minimal plugin surface, explicit control over LSP / formatter / linter setup per language, and runtime performance and stability (fast startup, responsive editing, reliable behavior).

## Structure

- `init.lua` — entry point (`require("config")` only)
- `lua/config/` — base settings loaded via `lua/config/init.lua`
- `lua/core/` — shared utilities (`plugin.lua`, `utils.lua`)
- `lua/plugin/` — lazy.nvim plugin specs (one file per plugin)
- `after/lsp/` — per-server LSP config
- `after/ftplugin/` — filetype-specific overrides

## Plugin Manager

lazy.nvim configured in `lua/config/pack.lua`. Bootstrap via `require("core.plugin").init()`.

## Architecture

- **LSP**: Neovim 0.11+ native `vim.lsp.enable()`, per-server config in `after/lsp/*.lua`
- **Formatter**: conform.nvim (`lua/plugin/formatting.lua`), `lsp_format = "fallback"`
- **Linter**: nvim-lint (`lua/plugin/linting.lua`) fills gaps for tools without an LSP server

## Verification

To validate changes without launching the interactive UI:

- `nvim --headless "+checkhealth" +qa` — run full health check
- `nvim --headless -l <file>.lua` — Lua syntax / runtime error check for a single file
- `nvim --headless "+Lazy! sync" +qa` — verify plugin specs load cleanly

## Rules & Skills

Documentation, rules, and skills files are written in English. Consult these before making non-trivial changes.

Rules (`.claude/rules/`) — conventions and constraints:

- `configuration-policy.md` — intentional differences from ryoppippi/dotfiles
- `lsp-conventions.md` — LSP / formatter / linter setup rules per language
- `plugin-conventions.md` — how to write lazy.nvim plugin specs
- `keymap-conventions.md` — where to define keymaps

Skills (`.claude/skills/`) — step-by-step workflows:

- `add-plugin/` — adding a new plugin
- `add-lsp/` — adding a new LSP server
- `add-lang/` — setting up a new language (LSP + formatter + linter)

## `/plan-review` Triggers

Invoke `/plan-review` before implementation when the change involves:

- Adding a new plugin
- Setting up a new language (LSP + formatter + linter)
- Updates aimed at improving Neovim runtime performance
- Replacing an existing plugin, LSP server, formatter, or linter (regression risk)
- Large-scale keymap changes (impacts muscle memory)
- Restructuring lazy-loading (startup time and load-order effects)
- Anything potentially in conflict with a rule in `.claude/rules/`
- Crossing the Neovim 0.11+ native API boundary (e.g., falling back to pre-0.11 patterns)
- Changes spanning multiple directories in the `Structure` map above

Skip `/plan-review` for:

- Single-file changes under 20 lines
- Typos, comments, or formatting
- Plugin version bumps with no config change

## Review Focus

Points for Codex (and Claude) to weigh heavily during review:

- Respect the intentional choices documented in `.claude/rules/configuration-policy.md` — including deliberate additions, specific configurations, and deliberate exclusions. Do not revert or override them without explicit discussion.
- lazy-loading integrity — changes must not inadvertently eager-load plugins
- Prefer Neovim 0.11+ native APIs over legacy plugin-based alternatives
- Minimize new dependencies; justify each added plugin
- Keymap changes should follow `.claude/rules/keymap-conventions.md`
- Runtime performance and stability — avoid changes that add measurable startup latency, input lag, or flakiness unless justified
