# bat's theme follows the Ghostty theme. BAT_THEME beats the --theme in bat/config, which holds the
# Kanagawa Dragon theme. Solarized Dark - Vivid uses craftzdog's `bat --theme "Solarized (dark)"`
# (his config-mac.fish alias), exported instead so fzf previews and scripts get it too.
switch (_prompt_ghostty_theme)
    case 'Solarized Dark - Vivid'
        set -gx BAT_THEME 'Solarized (dark)'
    case '*'
        set -e BAT_THEME
end
