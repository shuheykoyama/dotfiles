#!/bin/zsh

eval "$(sheldon source)"

eval "$(starship init zsh)"

### 1Password CLI Shell Completion
# 1Password CLI automatically completes your commands.
# eval "$(op completion zsh)"; compdef _op op
# source /Users/shuhey/.config/op/plugins.sh

### GitHub CLI
# Configuration of GitHub CLI command completion.
eval "$(gh completion -s zsh)"
