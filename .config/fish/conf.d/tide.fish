# Kanagawa Dragon palette reference:
#   blue=#8BA4B0  brblue=#7FB4CA  yellow=#C4B28A  bryellow=#E6C384
#   red=#C4746E   brred=#E46876   black=#0D0C0C   brblack=#A6A69C
#   white=#C8C093 brwhite=#C5C9C5 foreground=#C5C9C5

# left prompt: remove os icon
set -g tide_left_prompt_items pwd git newline character

# pwd: Kanagawa Dragon colors
set -g tide_pwd_color_anchors C5C9C5   # brwhite (foreground) - current dir
set -g tide_pwd_color_dirs 8BA4B0      # blue - parent dirs
set -g tide_pwd_color_truncated_dirs A6A69C  # brblack - truncated

# pwd: remove icons
set -g tide_pwd_icon ''
set -g tide_pwd_icon_home ''
set -g tide_pwd_icon_unwritable ''

# git: background colors
set -g tide_git_bg_color 7FB4CA        # brblue - clean
set -g tide_git_bg_color_unstable E6C384  # bryellow - dirty/staged/untracked
set -g tide_git_bg_color_urgent E46876   # brred - conflict/merge

# git: text colors (dark for contrast on light bg)
set -g tide_git_color_branch 0D0C0C
set -g tide_git_color_dirty 0D0C0C
set -g tide_git_color_staged 0D0C0C
set -g tide_git_color_untracked 0D0C0C
set -g tide_git_color_conflicted 0D0C0C
set -g tide_git_color_operation 0D0C0C
set -g tide_git_color_stash 0D0C0C
set -g tide_git_color_upstream 0D0C0C

# git: icon
set -g tide_git_icon ''

# character
set -g tide_character_color 87A987     # brgreen
set -g tide_character_color_failure E46876  # brred

# python: yellow
set -g tide_python_color E6C384        # bryellow

# node: green
set -g tide_node_color 87A987          # brgreen
