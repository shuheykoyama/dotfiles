function _prompt_ghostty_theme --description 'Print the active Ghostty theme name (cached on the config mtime)'
    # Ghostty exports GHOSTTY_RESOURCES_DIR; herdr/tmux inside it keep inheriting it.
    set -q GHOSTTY_RESOURCES_DIR; or return 0

    set -l cache_dir (set -q XDG_CACHE_HOME; and echo $XDG_CACHE_HOME; or echo $HOME/.cache)/fish-prompt
    set -l cache $cache_dir/ghostty-theme
    set -l cfg_home (set -q XDG_CONFIG_HOME; and echo $XDG_CONFIG_HOME; or echo $HOME/.config)

    # Re-resolve when no cache exists or either Ghostty config location is newer than it.
    set -l stale 0
    test -f $cache; or set stale 1
    for f in $cfg_home/ghostty/config "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
        test "$f" -nt $cache; and set stale 1
    end

    if test $stale -eq 1
        set -l bin (set -q GHOSTTY_BIN_DIR; and echo $GHOSTTY_BIN_DIR/ghostty; or command -s ghostty)
        test -x "$bin"; or return 0
        mkdir -p $cache_dir
        # +show-config prints the resolved config (config-file includes applied).
        $bin +show-config 2>/dev/null | string replace -rf '^theme = (.*)$' '$1' | head -n 1 >$cache
    end

    set -l theme (cat $cache)
    # "light:X,dark:Y" follows the macOS appearance; the OS mode can change at any time, so resolve it live.
    if string match -rq '^light:(?<light>.*),dark:(?<dark>.*)$' -- $theme
        if test (defaults read -g AppleInterfaceStyle 2>/dev/null) = Dark
            echo $dark
        else
            echo $light
        end
    else
        echo $theme
    end
end
