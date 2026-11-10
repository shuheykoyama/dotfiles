# delta's feature follows the Ghostty theme. git/config selects kanagawa-dragon; DELTA_FEATURES replaces
# that selection for Solarized Dark - Vivid and is erased for every other theme. delta, lazygit's pager
# and `git diff` all read it, whichever of them runs under fish. The [delta] options in git/config
# (navigate, line-numbers, side-by-side) apply to both themes.
switch (_prompt_ghostty_theme)
    case 'Solarized Dark - Vivid'
        set -gx DELTA_FEATURES solarized-dark-vivid
    case '*'
        set -e DELTA_FEATURES
end
