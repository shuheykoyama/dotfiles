function marp-preview --description "Serve a Marp deck directory on localhost only"
    if test (count $argv) -ne 1
        echo "usage: marp-preview <deck-directory>" >&2
        return 1
    end
    set -l dir $argv[1]
    if not test -d "$dir"
        echo "marp-preview: directory not found: $dir" >&2
        return 1
    end
    set -l preload $HOME/.config/marp/loopback.cjs
    if not test -f $preload
        echo "marp-preview: preload not found: $preload" >&2
        return 1
    end
    # Refuse to clobber an existing NODE_OPTIONS (it may carry other required flags)
    if test -n "$NODE_OPTIONS"
        echo "marp-preview: NODE_OPTIONS is already set; unset it first" >&2
        return 1
    end
    # Bind Marp's HTTP and watch-notifier servers to 127.0.0.1 for this command only
    NODE_OPTIONS="--require=$preload" marp -s "$dir"
end
