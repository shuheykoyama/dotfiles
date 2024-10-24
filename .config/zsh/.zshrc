source $DOTPATH/.config/zsh/appearance.zsh
source $DOTPATH/.config/zsh/aliases.zsh

# History
HISTSIZE=10000  # Number of history entries to keep in memory
SAVEHIST=1000000  # Number of history entries to keep in history file
setopt SHARE_HISTORY  # Share history between all sessions.

# Directory stack
setopt auto_cd

# Completion
setopt auto_menu
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}' 'r:|[-_.]=**'

autoload -Uz compinit && compinit

# Load plugins

# FZF
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# Use fd instead of fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source "$DOTPATH"/.config/fzf/fzf-git.sh

# TheFuck
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# bun completions
[ -s "/Users/shuhey/.bun/_bun" ] && source "/Users/shuhey/.bun/_bun"

# Sheldon
eval "$(sheldon source)"

# Starship
eval "$(starship init zsh)"

# GitHub CLI
eval "$(gh completion -s zsh)"

# mise
eval "$(~/.local/bin/mise activate zsh)"

# Zoxide
eval "$(zoxide init zsh)"
