# Enable YJIT for every Ruby invocation (Ruby 3.3+; ~15-25% faster, no code changes).
# Set here in the tracked dotfiles via `set -gx` rather than a `set -Ux` universal
# variable, which would live in the gitignored fish_variables and not be reproducible.
set -gx RUBYOPT --yjit
