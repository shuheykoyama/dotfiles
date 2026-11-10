# lazygit's colours follow the Ghostty theme: a theme-*.yml is layered over config.yml through
# LG_CONFIG_FILE (comma-separated, later files win). Solarized Dark - Vivid uses solarized-osaka.nvim's
# lazygit theme. Shells without detection, and lazygit started outside fish (herdr panes), do not get
# LG_CONFIG_FILE and read config.yml alone: lazygit's default colours, which are ANSI names.
set -l dir $XDG_CONFIG_HOME/lazygit
switch (_prompt_ghostty_theme)
    case 'Solarized Dark - Vivid'
        set -gx LG_CONFIG_FILE $dir/config.yml,$dir/theme-solarized-osaka.yml
    case '*'
        set -gx LG_CONFIG_FILE $dir/config.yml,$dir/theme-kanagawa-dragon.yml
end
