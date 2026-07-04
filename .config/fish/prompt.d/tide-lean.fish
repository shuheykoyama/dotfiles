# Tide lean prompt — colors match Tide's standard `lean_16color` palette
# (verified against the official repo), so they follow the terminal's 16-color
# palette (kanagawa-dragon in ghostty). set -g so it survives `fisher update`.

# ---- prompt items (vi_mode omitted: fish uses default key bindings) ----
set -g tide_left_prompt_items pwd git node python bun go rustc java php ruby newline character
set -g tide_right_prompt_items cmd_duration time

# ---- lean: disable frames/powerline, single-space separators ----
set -g tide_left_prompt_frame_enabled false
set -g tide_right_prompt_frame_enabled false
set -g tide_prompt_pad_items false
set -g tide_left_prompt_prefix ''
set -g tide_left_prompt_suffix ' '
set -g tide_left_prompt_separator_same_color ' '
set -g tide_left_prompt_separator_diff_color ' '
set -g tide_right_prompt_prefix ' '
set -g tide_right_prompt_suffix ''
set -g tide_right_prompt_separator_same_color ' '
set -g tide_right_prompt_separator_diff_color ' '

# ---- layout: 2-line sparse ----
set -g tide_prompt_add_newline_before true
set -g tide_prompt_transient_enabled false

# ---- pwd: dynamic truncation, no leading folder icon (Tide std lean_16color colors) ----
set -g tide_pwd_bg_color normal
set -g tide_pwd_color_anchors brcyan
set -g tide_pwd_color_dirs cyan
set -g tide_pwd_color_truncated_dirs magenta
set -g tide_pwd_icon ''
set -g tide_pwd_icon_home ''
set -g tide_pwd_icon_unwritable ''

# ---- git colors (Tide std lean_16color) ----
set -g tide_git_bg_color normal
set -g tide_git_bg_color_unstable normal
set -g tide_git_bg_color_urgent normal
set -g tide_git_color_branch brgreen
set -g tide_git_color_dirty bryellow
set -g tide_git_color_staged bryellow
set -g tide_git_color_untracked brblue
set -g tide_git_color_conflicted brred
set -g tide_git_color_operation brred
set -g tide_git_color_stash brgreen
set -g tide_git_color_upstream brgreen
set -g tide_git_truncation_length 24

# ---- git icon: "on" in default text color, glyph in branch color ----
# Tide prepends the branch color to the icon, so reset to normal for "on",
# then re-set the branch color for the glyph.
set -g tide_git_icon (set_color normal)"on "(set_color $tide_git_color_branch)""

# ---- prompt character (Tide std lean_16color) ----
set -g tide_character_color brgreen
set -g tide_character_color_failure brred

# ---- right: cmd_duration (>3s, no icon; Tide std color) ----
set -g tide_cmd_duration_bg_color normal
set -g tide_cmd_duration_color brblack
set -g tide_cmd_duration_decimals 0
set -g tide_cmd_duration_threshold 3000
set -g tide_cmd_duration_icon ''

# ---- right: time (%T, no icon; Tide std color) ----
set -g tide_time_bg_color normal
set -g tide_time_color brblack
set -g tide_time_format %T

# ---- language colors (Tide std lean_16color; bg normal for lean) ----
set -g tide_node_bg_color normal
set -g tide_node_color green
set -g tide_python_bg_color normal
set -g tide_python_color cyan
set -g tide_bun_bg_color normal
set -g tide_bun_color white
set -g tide_go_bg_color normal
set -g tide_go_color brcyan
set -g tide_rustc_bg_color normal
set -g tide_rustc_color red
set -g tide_java_bg_color normal
set -g tide_java_color yellow
set -g tide_php_bg_color normal
set -g tide_php_color blue
set -g tide_ruby_bg_color normal
set -g tide_ruby_color red

# ---- language icons (Nerd Font, copied verbatim from vendored icons.fish) ----
set -g tide_node_icon ''
set -g tide_python_icon '󰌠'
set -g tide_bun_icon '󰳓'
set -g tide_go_icon ''
set -g tide_rustc_icon ''
set -g tide_java_icon ''
set -g tide_php_icon ''
set -g tide_ruby_icon ''

# apply shared _tide_pwd override (bold-leak fix)
source $__fish_config_dir/prompt.d/tide-common.fish
