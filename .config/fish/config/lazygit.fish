# lazygit's colours follow the Ghostty theme: theme-*.yml is layered over config.yml through
# LG_CONFIG_FILE (comma-separated, later files win). Solarized Dark - Vivid adds nothing, because
# craftzdog's lazygit config sets no theme and lazygit's defaults (ANSI names) apply. Shells without
# detection, and lazygit started outside fish (herdr panes), read config.yml alone and get those same
# defaults.
switch (_prompt_ghostty_theme)
    case 'Solarized Dark - Vivid'
        set -e LG_CONFIG_FILE
    case '*'
        set -gx LG_CONFIG_FILE $XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/theme-kanagawa-dragon.yml
end
