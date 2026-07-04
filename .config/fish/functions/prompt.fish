function prompt --description 'Switch the shell prompt style (tide-powerline / tide-lean / hydro)'
    set -l styles tide-powerline tide-lean hydro

    if test (count $argv) -eq 0
        if set -q prompt_style
            echo "current: $prompt_style"
        else
            echo "current: (unset -> tide-lean)"
        end
        echo "available: $styles"
        return 0
    end

    if not contains -- $argv[1] $styles
        echo "prompt: unknown style '$argv[1]'" >&2
        echo "available: $styles" >&2
        return 1
    end

    # Universal so every shell picks it up; re-exec applies it cleanly
    # (needed because switching prompt engines re-runs conf.d setup).
    set -U prompt_style $argv[1]
    exec fish
end
