# craftzdog's fish syntax highlighting, for Solarized Dark - Vivid.
#
# His dotfiles set no fish colours, but his .chezmoiignore lists conf.d/fish_frozen_theme.fish, which
# fish >= 4.3 writes when it migrates colours left in universal variables. His typed commands in the
# screenshot (npm dark blue, arguments light blue) match fish's old truecolor defaults, not the ANSI
# ones fish uses since 3.4, so this is the default theme of fish 3.3.1 verbatim
# (share/functions/__fish_config_interactive.fish, __init_uvar lines).
# Variables it does not define keep the values fish sets itself.

set -g fish_color_normal normal
set -g fish_color_command 005fd7
set -g fish_color_param 00afff
set -g fish_color_redirection 00afff
set -g fish_color_comment 990000
set -g fish_color_error ff0000
set -g fish_color_escape 00a6b2
set -g fish_color_operator 00a6b2
set -g fish_color_end 009900
set -g fish_color_quote 999900
set -g fish_color_autosuggestion 555 brblack
set -g fish_color_user brgreen
set -g fish_color_host normal
set -g fish_color_host_remote yellow
set -g fish_color_valid_path --underline
set -g fish_color_status red
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_search_match bryellow --background=brblack
set -g fish_color_selection white --bold --background=brblack
set -g fish_color_cancel -r
set -g fish_color_history_current --bold

set -g fish_pager_color_prefix normal --bold --underline
set -g fish_pager_color_completion
set -g fish_pager_color_description B3A06D yellow
set -g fish_pager_color_progress brwhite --background=cyan
