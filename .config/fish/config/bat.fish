# bat's theme follows the Ghostty theme. BAT_THEME beats the --theme in bat/config, which holds the
# Kanagawa Dragon theme. Solarized Dark - Vivid uses solarized-osaka.nvim's theme (bat/themes/
# solarized_osaka_dark.tmTheme, vendored from its extras/sublime, with the Tokyo Night colours that
# its template hardcodes replaced by Solarized Osaka ones), exported instead of set in the config so
# fzf previews and scripts that call bat get it too.
switch (_prompt_ghostty_theme)
    case 'Solarized Dark - Vivid'
        set -gx BAT_THEME solarized_osaka_dark
    case '*'
        set -e BAT_THEME
end
