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
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git/*'"
export FZF_DEFAULT_OPTS='--height 40% --reverse --border --preview "head -100 {}"'

export FZF_CTRL_T_COMMAND="rg --files --hidden --follow --glob '!.git/*'"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid --line-range :100 {}'"

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

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

# Haskell for Tidal Cycles
source ${HOME}/.ghcup/env

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/shuhey/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/shuhey/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/shuhey/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/shuhey/google-cloud-sdk/completion.zsh.inc'; fi
