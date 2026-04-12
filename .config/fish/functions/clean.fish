function clean
    # brew
    type -q brew && brew cleanup -s
    # mise
    type -q mise && mise prune

    set -l CONFIG_CACHE $FISH_CACHE_DIR/config.fish
    test -e $CONFIG_CACHE && command rm -f $CONFIG_CACHE

    init
    exit
end
