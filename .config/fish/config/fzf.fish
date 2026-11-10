set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-messages --glob "!/^[^\/]+\/.git/\/?(?:[^\/]+\/?)*" '
set -x FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_DEFAULT_OPTS '--extended --cycle --select-1 --height 40% --reverse --border'
set -x FZF_FIND_FILE_OPTS '--preview "bat --color=always --style=header,grid --line-range :100 {}"'
set -x FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_COMPLETION_TRIGGER '**'
set -x FZF_DEFAULT_OPTS_FILE $HOME/.config/fzf/config

# Colours follow the Ghostty theme. fzf/config holds the Kanagawa Dragon colours (it is also what zsh and
# any shell without detection get). Solarized Dark - Vivid uses solarized-osaka.nvim's colours, from its
# extras/fzf/solarized_osaka_dark.sh without bg and gutter, which would paint an opaque block over the
# translucent terminal. --color=dark resets the base scheme and drops the colours from fzf/config.
switch (_prompt_ghostty_theme)
    case 'Solarized Dark - Vivid'
        set -x FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --color=dark \
            --color=bg+:#002c38 --color=border:#063540 --color=fg:#9eabac --color=header:#c94c16 \
            --color=hl+:#c94c16 --color=hl:#c94c16 --color=info:#637981 --color=marker:#c94c16 \
            --color=pointer:#c94c16 --color=prompt:#c94c16 --color=query:#9eabac:regular \
            --color=scrollbar:#063540 --color=separator:#063540 --color=spinner:#c94c16"
end
