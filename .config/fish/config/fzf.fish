set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-messages --glob "!/^[^\/]+\/.git/\/?(?:[^\/]+\/?)*" '
set -x FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_DEFAULT_OPTS '--extended --cycle --select-1 --height 40% --reverse --border'
set -x FZF_FIND_FILE_OPTS '--preview "bat --color=always --style=header,grid --line-range :100 {}"'
set -x FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_COMPLETION_TRIGGER '**'
set -x FZF_DEFAULT_OPTS_FILE $HOME/.config/fzf/config

# Colours follow the Ghostty theme. fzf/config holds the Kanagawa Dragon colours (it is also what zsh and
# any shell without detection get). Solarized Dark - Vivid uses fzf's built-in colours, like craftzdog's
# fzf, which sets none; --color=dark resets the base scheme and drops the colours from fzf/config.
switch (_prompt_ghostty_theme)
    case 'Solarized Dark - Vivid'
        set -x FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --color=dark"
end
