# Tide powerline: choose the colour variant from the Ghostty theme.
#   Solarized Dark - Vivid -> tide-powerline-vivid.fish  (craftzdog's prompt, fixed colours)
#   anything else          -> tide-powerline-dragon.fish (same prompt, Kanagawa Dragon colours; also the
#                             fallback when the theme cannot be detected)
switch (_prompt_ghostty_theme)
    case 'Solarized Dark - Vivid'
        source $__fish_config_dir/prompt.d/tide-powerline-vivid.fish
    case '*'
        source $__fish_config_dir/prompt.d/tide-powerline-dragon.fish
end

# --- shared _tide_pwd override (bold-leak fix) ---
source $__fish_config_dir/prompt.d/tide-common.fish
