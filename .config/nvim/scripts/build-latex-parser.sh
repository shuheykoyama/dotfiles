#!/usr/bin/env bash
# Build the tree-sitter-latex parser and install it into Neovim's site parser
# directory so snacks.image can render LaTeX math ($...$) inline in markdown.
#
# Why this script exists:
#   nvim-treesitter (master) was archived 2026-04 and its `:TSInstall latex`
#   runs `tree-sitter generate --no-bindings`; the `--no-bindings` flag was
#   removed in tree-sitter CLI 0.25+, so the install fails on a modern CLI.
#   The latex grammar also ships no prebuilt parser (it must be generated from
#   grammar.js). This script generates the parser with the modern CLI (which
#   simply ignores the flag) at the exact revision nvim-treesitter's bundled
#   highlights query expects -- where `label_definition`'s `name` field is
#   `curly_group_text` -- keeping parser and query in sync, then compiles it.
#
# Requires: git, tree-sitter (brew install tree-sitter-cli), a C compiler (cc).
# Re-run after a fresh Neovim install or if the parser goes missing.
set -euo pipefail

# Matches the `latex` revision in nvim-treesitter's lockfile.json.
readonly REV="7b06f6ed394308e7407a1703d2724128c45fc9d7"
readonly DEST="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/parser"

command -v tree-sitter >/dev/null \
  || { echo "tree-sitter CLI not found: brew install tree-sitter-cli" >&2; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

git clone --quiet https://github.com/latex-lsp/tree-sitter-latex "$tmp/tsl"
git -C "$tmp/tsl" checkout --quiet "$REV"
(cd "$tmp/tsl" && tree-sitter generate)

mkdir -p "$DEST"
cc -O2 -shared -fPIC -I "$tmp/tsl/src" \
  "$tmp/tsl/src/parser.c" "$tmp/tsl/src/scanner.c" \
  -o "$DEST/latex.so"

echo "Installed latex parser -> $DEST/latex.so"
