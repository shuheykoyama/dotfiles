function __npkill_humanize --description 'Format a KB integer as a human-readable size'
    # Walk up the unit ladder (K -> M -> G -> T) until the value drops below 1024.
    printf '%s\n' $argv[1] | awk '{
        kb = $1
        split("K M G T", u, " ")
        i = 1
        while (kb >= 1024 && i < 4) { kb /= 1024; i++ }
        printf "%.1f%s", kb, u[i]
    }'
end

function npkill
    if not command -q fzf
        echo "npkill requires fzf. Install it first." >&2
        return 1
    end

    set -l dirs (fd --hidden --no-ignore --prune --type d '^node_modules$' . 2>/dev/null)
    if test (count $dirs) -eq 0
        echo "No node_modules directories found."
        return 0
    end

    # Directories modified within 14 days are flagged as possibly still in use.
    set -l recent (fd --hidden --no-ignore --prune --type d --changed-within 14d '^node_modules$' . 2>/dev/null)

    # Measure every node_modules in parallel (KB, numeric) sorted by size descending.
    set -l entries (printf '%s\n' $dirs | xargs -P (getconf _NPROCESSORS_ONLN) -I{} du -sk {} | sort -rn)

    # Build fzf rows as "<mark> <size><TAB><path>"; the path column (field 2) is
    # what we extract after selection and what the preview references via {2}.
    set -l rows
    for entry in $entries
        set -l kb (string split -f1 \t -- $entry)
        set -l path (string split -f2 \t -- $entry)
        set -l mark "  "
        contains -- $path $recent; and set mark "⚠️"
        set -a rows (printf '%s %8s\t%s' $mark (__npkill_humanize $kb) $path)
    end

    # Preview runs under sh; {2} is the path column (delimiter = TAB).
    set -l preview 'p={2}; du -sh "$p"; echo; stat -c "Modified: %y" "$p"; echo; eza -la --color=always "$p" 2>/dev/null | head -20'

    set -l selected (printf '%s\n' $rows | fzf \
        --multi --ansi --layout=reverse \
        --delimiter='\t' --with-nth=1,2 \
        --bind 'space:toggle+down' \
        --preview "$preview" --preview-window=right:50% \
        --header 'Space: select   Enter: confirm   Esc: cancel   (⚠️ = modified <14d)' \
        --prompt 'node_modules> ')

    if test (count $selected) -eq 0
        echo "Cancelled."
        return 0
    end

    # Extract selected paths, then sum sizes / warnings from the cached entries
    # so we never re-run du.
    set -l targets
    for line in $selected
        set -a targets (string split -f2 \t -- $line)
    end
    set -l total_kb 0
    set -l warn 0
    for entry in $entries
        set -l kb (string split -f1 \t -- $entry)
        set -l path (string split -f2 \t -- $entry)
        if contains -- $path $targets
            set total_kb (math $total_kb + $kb)
            contains -- $path $recent; and set warn (math $warn + 1)
        end
    end

    set -l n (count $targets)
    set -l total_human (__npkill_humanize $total_kb)
    set -l msg "Permanently delete $n directories ($total_human)"
    test $warn -gt 0; and set msg "$msg, including $warn marked ⚠️"
    set_color red
    echo "$msg. This cannot be undone."
    set_color normal
    read -l --prompt-str "Continue? [y/N]: " confirm
    if not string match -qir '^y(es)?$' -- $confirm
        echo "Cancelled."
        return 0
    end

    # Use `command rm` to bypass the rm->trash alias (see functions/rm.fish)
    # so the directories are deleted outright instead of moved to the Trash.
    set -l i 0
    for t in $targets
        set i (math $i + 1)
        command rm -rf "$t"
        printf '  [%d/%d] Deleted: %s\n' $i $n "$t"
    end
    set_color --bold green
    echo "==> Freed $total_human across $n directories"
    set_color normal
end
