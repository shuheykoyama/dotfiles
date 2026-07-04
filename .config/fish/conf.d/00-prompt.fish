# Prompt switcher — pick tide-powerline / tide-lean / hydro at runtime.
# Change it with the `prompt` command (sets $prompt_style, then re-execs fish).
#
# IMPORTANT: the tide branches must NOT be gated on `status is-interactive`.
# Tide renders its prompt in a non-interactive `fish --private -c` subshell
# that re-sources conf.d; if setup were skipped there, Tide's `set -g` colors
# would be missing and it would fall back to stale universal values (e.g. the
# git background staying dark instead of turning yellow when dirty).
set -q prompt_style; or set -g prompt_style tide-lean

switch $prompt_style
    case tide-powerline
        source $__fish_config_dir/prompt.d/tide-powerline.fish
    case tide-lean
        source $__fish_config_dir/prompt.d/tide-lean.fish
    case hydro
        # Hydro is interactive-only: its setup.fish exits on non-interactive
        # shells, and its prompt renders in the parent shell (not a subshell).
        if status is-interactive
            set -g fish_function_path $__fish_config_dir/prompt.d/hydro/functions $fish_function_path
            source $__fish_config_dir/prompt.d/hydro/setup.fish
        end
    case '*'
        source $__fish_config_dir/prompt.d/tide-lean.fish
end
