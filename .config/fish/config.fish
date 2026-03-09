set -gx LC_ALL "en_US.UTF-8"
set -gx BASH_SILENCE_DEPRECATION_WARNING 1

# define XDG paths
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache

# define fish config paths
set -g FISH_CONFIG_DIR $XDG_CONFIG_HOME/fish
set -g FISH_CONFIG $FISH_CONFIG_DIR/config.fish
set -g FISH_CACHE_DIR /tmp/fish-cache

# load user config (functions/ is auto-loaded by Fish)
for file in $FISH_CONFIG_DIR/config/*.fish
    source $file
end

# theme
source $FISH_CONFIG_DIR/themes/kanagawa.fish

# general bin paths
fish_add_path $HOME/.local/bin
fish_add_path "$HOME/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.antigravity/antigravity/bin"

# arch-specific paths (Intel: /usr/local, arm64: /opt/homebrew)
if test (uname -m) = arm64
    fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
    fish_add_path /opt/homebrew/opt/curl/bin
else
    fish_add_path /usr/local/opt/coreutils/libexec/gnubin
    fish_add_path /usr/local/opt/curl/bin
end

# Java
set -gx _JAVA_OPTIONS "-Dfile.encoding=UTF-8"
if type -q /usr/libexec/java_home
    set -gx JAVA_HOME (/usr/libexec/java_home -v "20")
end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path $PNPM_HOME

# bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"
fish_add_path "$HOME/.cache/.bun/bin"

# Haskell (GHCup)
set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
fish_add_path $HOME/.ghcup/bin
fish_add_path $HOME/.cabal/bin

# Google Cloud SDK
fish_add_path $HOME/google-cloud-sdk/bin

# c / c++
set -gx USE_CCACHE 1
set -gx CCACHE_DIR $HOME/.ccache

# brew
if test (uname -m) = arm64
    fish_add_path /opt/homebrew/bin
else
    fish_add_path /usr/local/bin
end

# Secretive
set -l SSH_SECRETIVE_SSH_SOCK $HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
test -e $SSH_SECRETIVE_SSH_SOCK && set -x SSH_AUTH_SOCK $SSH_SECRETIVE_SSH_SOCK

set -l CONFIG_CACHE $FISH_CACHE_DIR/config.fish

if not test -f "$CONFIG_CACHE"; or test "$FISH_CONFIG" -nt "$CONFIG_CACHE"
    mkdir -p $FISH_CACHE_DIR
    set -l tmp_cache (mktemp -p $FISH_CACHE_DIR)

    echo '' >$tmp_cache

    # homebrew
    if test (uname -m) = arm64
        echo $(/opt/homebrew/bin/brew shellenv) >>$tmp_cache
        echo "set -gx PATH /opt/homebrew/opt/llvm/bin $PATH" >>$tmp_cache
    else
        echo $(/usr/local/bin/brew shellenv) >>$tmp_cache
    end

    # xcode
    echo "fish_add_path $(ensure_installed xcode-select -p)/usr/bin" >>$tmp_cache
    echo "set -gx SDKROOT $(ensure_installed xcrun --sdk macosx --show-sdk-path)" >>$tmp_cache

    # direnv
    ensure_installed direnv hook fish >>$tmp_cache

    # mise
    ensure_installed mise activate fish >>$tmp_cache

    # zoxide
    ensure_installed zoxide init fish >>$tmp_cache

    # set vivid colors
    echo "set -gx LS_COLORS '$(ensure_installed vivid generate gruvbox-dark)'" >>$tmp_cache

    mv $tmp_cache $CONFIG_CACHE

    set_color brmagenta --bold --underline
    echo "config cache updated"
    set_color normal
end

source $CONFIG_CACHE

# neovim
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "nvim -c ASMANPAGER -"

if status is-interactive
    stty stop undef
    stty start undef
end

set -g NA_PACKAGE_MANAGER_LIST bun deno pnpm npm yarn
set -g NA_FUZZYFINDER_OPTIONS --bind 'one:accept' --query '^'
