function _tide_item_jj
    # One jj call per prompt (tide runs every item in a background process, so it never blocks input).
    # --no-integrate-operation: jj snapshots the working copy to compute the state, so edits show up at
    # once like `git status`, but throws the snapshot away. Nothing is written to the repo or the
    # operation log. Each commit the revset picks is tagged with one line per role:
    #   W <change id>|<E empty><C conflict><D divergent>|<changed files>|<conflicted files>   the working copy
    #   B <bookmarks>   closest ancestor bookmark   R   a remote bookmark exists   U   unpushed commit
    #   X   unpushed commit with changes and no description   H   commit trunk has and @ lacks
    set -l revs '@ | latest(bookmarks() & ::@, 1) | remote_bookmarks() | (remote_bookmarks()..@-) | (@..trunk())'
    set -l tpl 'concat(
        if(self.contained_in("@"), "W " ++ change_id.shortest(4) ++ "|" ++ if(empty,"E","-") ++ if(conflict,"C","-") ++ if(divergent,"D","-") ++ "|" ++ self.diff().files().len() ++ "|" ++ self.conflicted_files().len() ++ "\n"),
        if(self.contained_in("latest(bookmarks() & ::@, 1)"), "B " ++ local_bookmarks.join(",") ++ "\n"),
        if(self.contained_in("remote_bookmarks()"), "R\n"),
        if(self.contained_in("remote_bookmarks()..@-"), "U\n"),
        if(self.contained_in("(remote_bookmarks()..@-) & ~empty() & description(exact:\'\')"), "X\n"),
        if(self.contained_in("@..trunk()"), "H\n"),
    )'
    set -l out (jj --no-integrate-operation --no-pager --quiet --color never log --no-graph -r $revs -T $tpl 2>/dev/null) || return
    string match -qr '^W (?<change>\S+)\|(?<is_empty>.)(?<is_conflict>.)(?<is_divergent>.)\|(?<files>\d+)\|(?<conflicted_files>\d+)$' -- $out || return
    string match -qr '^B (?<bookmark>.+)$' -- $out

    # Without a remote bookmark `remote_bookmarks()..@-` is the whole history, so ahead and the
    # description marker are only meaningful when one exists.
    set -l behind_n (string match H -- $out | count)
    set -l ahead_n 0
    set -l undescribed_n 0
    if test (string match R -- $out | count) -gt 0
        set ahead_n (string match U -- $out | count)
        set undescribed_n (string match X -- $out | count)
    end

    # Unset (not "0") when there is nothing to show, so `' ⇣'$behind` prints nothing at all.
    test $behind_n -gt 0 && set -f behind $behind_n
    test $ahead_n -gt 0 && set -f ahead $ahead_n
    test $is_divergent = D && set -f divergent ⇔
    test $undescribed_n -gt 0 && set -f undescribed ∅
    test $conflicted_files -gt 0 && set -f conflicted $conflicted_files
    test $files -gt 0 && set -f dirty $files

    # Same rule as the git item: conflict (or divergence) is urgent, changes are unstable.
    if test $is_conflict = C; or test -n "$divergent"
        set -g tide_jj_bg_color $tide_jj_bg_color_urgent
    else if test -n "$dirty"
        set -g tide_jj_bg_color $tide_jj_bg_color_unstable
    end

    set -l location $change
    test -n "$bookmark" && set location $bookmark' '$change

    _tide_print_item jj (set_color $tide_jj_color_branch; echo -ns $tide_jj_icon' '
        set_color $tide_jj_color_branch; echo -ns $location
        set_color $tide_jj_color_upstream; echo -ns ' ⇣'$behind ' ⇡'$ahead
        set_color $tide_jj_color_marker; echo -ns ' '$divergent ' '$undescribed
        set_color $tide_jj_color_conflicted; echo -ns ' ~'$conflicted
        set_color $tide_jj_color_dirty; echo -ns ' !'$dirty)
end
