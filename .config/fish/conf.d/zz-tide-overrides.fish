# Tide overrides — survive `fisher update`.
#
# fisher rewrites files under functions/ on every update, so patches there
# get reverted. Defining the same functions in conf.d/ (loaded after every
# autoloaded path) means tide picks up these versions on first call instead
# of autoloading the upstream files. Filename is `zz-` to ensure this loads
# after `_tide_init.fish` and `tide.fish`.

# -----------------------------------------------------------------------------
# _tide_pwd: append $reset_to_color_dirs in the home branch so the bold
# attribute applied by $color_anchors doesn't leak into the right prompt.
# Everything else is a verbatim copy of upstream functions/_tide_pwd.fish.
# -----------------------------------------------------------------------------
set_color -o $tide_pwd_color_anchors | read -l color_anchors
set_color $tide_pwd_color_truncated_dirs | read -l color_truncated
set -l reset_to_color_dirs (set_color normal -b $tide_pwd_bg_color; set_color $tide_pwd_color_dirs)

set -l unwritable_icon $tide_pwd_icon_unwritable' '
set -l home_icon $tide_pwd_icon_home' '
set -l pwd_icon $tide_pwd_icon' '

eval "function _tide_pwd
    if set -l split_pwd (string replace -r '^$HOME' '~' -- \$PWD | string split /)
        test -w . && set -f split_output \"$pwd_icon\$split_pwd[1]\" \$split_pwd[2..] ||
            set -f split_output \"$unwritable_icon\$split_pwd[1]\" \$split_pwd[2..]
        set split_output[-1] \"$color_anchors\$split_output[-1]$reset_to_color_dirs\"
    else
        # NOTE(upstream-patch): append \$reset_to_color_dirs to clear bold.
        set -f split_output \"$home_icon$color_anchors~$reset_to_color_dirs\"
    end

    string join / -- \$split_output | string length -V | read -g _tide_pwd_len

    i=1 for dir_section in \$split_pwd[2..-2]
        string join -- / \$split_pwd[..\$i] | string replace '~' $HOME | read -l parent_dir # Uses i before increment

        math \$i+1 | read i

        if path is \$parent_dir/\$dir_section/\$tide_pwd_markers
            set split_output[\$i] \"$color_anchors\$dir_section$reset_to_color_dirs\"
        else if test \$_tide_pwd_len -gt \$dist_btwn_sides
            string match -qr \"(?<trunc>\..|.)\" \$dir_section

            set -l glob \$parent_dir/\$trunc*/
            set -e glob[(contains -i \$parent_dir/\$dir_section/ \$glob)] # This is faster than inverse string match

            while string match -qr \"^\$parent_dir/\$(string escape --style=regex \$trunc)\" \$glob &&
                    string match -qr \"(?<trunc>\$(string escape --style=regex \$trunc).)\" \$dir_section
            end
            test -n \"\$trunc\" && set split_output[\$i] \"$color_truncated\$trunc$reset_to_color_dirs\" &&
                string join / \$split_output | string length -V | read _tide_pwd_len
        end
    end

    string join -- / \"$reset_to_color_dirs\$split_output[1]\" \$split_output[2..]
end"
