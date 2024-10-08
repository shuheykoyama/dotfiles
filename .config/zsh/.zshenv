export LANG=en_US.utf-8
export LC_ALL=en_US.utf-8
export DOTPATH=~/dotfiles

# Java
# handle Japanese well with UTF-8 code system
export _JAVA_OPTIONS="-Dfile.encoding=UTF-8"
# export JAVA_HOME=`/usr/libexec/java_home -v "1.8"`
# export JAVA_HOME=`/usr/libexec/java_home -v "11"`
# export JAVA_HOME=`/usr/libexec/java_home -v "17"`
# export JAVA_HOME=`/usr/libexec/java_home -v "18"`
# export JAVA_HOME=`/usr/libexec/java_home -v "19"`
export JAVA_HOME=`/usr/libexec/java_home -v "20"`

# Rust
. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/Users/shuhey/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
