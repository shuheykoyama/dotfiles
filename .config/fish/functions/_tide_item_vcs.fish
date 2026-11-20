function _tide_item_vcs
    # A jj repo shows the jj item, including a colocated one that also has .git; any other git repo
    # shows tide's git item. When jj is missing or fails, a colocated repo falls back to git.
    set -l dir $PWD
    while true
        if test -d $dir/.jj && type -q jj
            _tide_item_jj && return
            break
        end
        test $dir = / && break
        set dir (path dirname $dir)
    end

    type -q git || return
    # _tide_cache_variables sets this only when `git` itself is in the item list, which it no longer is.
    set_color $tide_git_color_branch | read -g _tide_location_color
    _tide_item_git
end
