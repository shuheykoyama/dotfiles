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

# theme (syntax highlighting): follows the Ghostty theme
# fish installs its default theme before config.fish runs, tagged --theme=default. When that tag is
# gone, an earlier source of this file replaced it (`sc` after a theme switch): reset first so
# variables only the other theme defines do not linger.
if not contains -- --theme=default $fish_color_command
    for var in (set --names | string match -r '^fish_(pager_)?color_\w*')
        set -eg $var
    end
    fish_config theme choose default
end
switch (_prompt_ghostty_theme)
    case 'Solarized Dark - Vivid'
        source $FISH_CONFIG_DIR/themes/fish-3.3-default.fish
    case '*'
        source $FISH_CONFIG_DIR/themes/kanagawa.fish
end

# general bin paths
fish_add_path $HOME/.local/bin
fish_add_path --path $HOME/go/bin
fish_add_path "$HOME/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.antigravity/antigravity/bin"

# arch-specific paths (Intel: /usr/local, arm64: /opt/homebrew)
if test (uname -m) = arm64
    fish_add_path /opt/homebrew/opt/curl/bin
else
    fish_add_path /usr/local/opt/curl/bin
end

# Java - Not in use right now, so commenting out below.
# set -gx _JAVA_OPTIONS "-Dfile.encoding=UTF-8"
# if type -q /usr/libexec/java_home
#     set -gx JAVA_HOME (/usr/libexec/java_home -v "20")
# end

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

# Secretive
set -l SSH_SECRETIVE_SSH_SOCK $HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
test -e $SSH_SECRETIVE_SSH_SOCK && set -x SSH_AUTH_SOCK $SSH_SECRETIVE_SSH_SOCK

# Homebrew: shellenv depends on the current environment, so do not cache it.
set -l brew_bin /usr/local/bin/brew
if test (uname -m) = arm64
    set brew_bin /opt/homebrew/bin/brew
end

if test -x "$brew_bin"
    $brew_bin shellenv fish | source
end

# Track Xcode and SDK changes without running xcrun at every startup.
set -l xcode_dev

if set -q DEVELOPER_DIR
    set xcode_dev (path resolve "$DEVELOPER_DIR")
    if test -d "$xcode_dev/Contents/Developer"
        set xcode_dev "$xcode_dev/Contents/Developer"
    end
else
    set xcode_dev (path resolve /var/db/xcode_select_link)
end

set -l sdk_dir "$xcode_dev/Platforms/MacOSX.platform/Developer/SDKs"
if not test -d "$sdk_dir"
    set sdk_dir "$xcode_dev/SDKs"
end

set -l sdk_paths $sdk_dir/MacOSX*.sdk
set -l xcode_state (string join '|' "$xcode_dev" $sdk_paths)

# Track CLI locations and resolved symlinks as well as modification times.
set -l init_tools direnv mise zoxide vivid jj
set -l tool_paths
set -l tool_executables

for tool in $init_tools
    set -l executable (command -s $tool)

    if test -n "$executable"
        set -l resolved (path resolve "$executable")
        set -a tool_paths "$tool:$resolved"
        set -a tool_executables "$resolved"
    else
        set -a tool_paths "$tool:"
    end
end

set -l tool_state (string join '|' $tool_paths)

set -l CONFIG_CACHE "$FISH_CACHE_DIR/config.fish"
set -l rebuild_cache false

# Rebuild only when cached inputs have changed.
if not test -f "$CONFIG_CACHE"; or test "$FISH_CONFIG" -nt "$CONFIG_CACHE"
    set rebuild_cache true
else
    # Xcode selection or SDK inventory changed.
    set -l cached_xcode_state (
        string match -rg -m1 '^# xcode-state: (.*)$' < "$CONFIG_CACHE"
    )
    if test "$xcode_state" != "$cached_xcode_state"
        set rebuild_cache true
    end

    # CLI installed, removed, or switched to another executable.
    set -l cached_tool_state (
        string match -rg -m1 '^# tool-state: (.*)$' < "$CONFIG_CACHE"
    )
    if test "$tool_state" != "$cached_tool_state"
        set rebuild_cache true
    end

    # CLI executable updated in place.
    for executable in $tool_executables
        if test "$executable" -nt "$CONFIG_CACHE"
            set rebuild_cache true
            break
        end
    end

    # Changes to sourced configuration or the helper function.
    for file in $FISH_CONFIG_DIR/config/*.fish $FISH_CONFIG_DIR/functions/ensure_installed.fish
        if test -f "$file"; and test "$file" -nt "$CONFIG_CACHE"
            set rebuild_cache true
            break
        end
    end
end

if test "$rebuild_cache" = true
    mkdir -p "$FISH_CACHE_DIR"
    set -l tmp_cache (mktemp -p "$FISH_CACHE_DIR")
    set -l cache_ok true

    if test -z "$tmp_cache"
        echo "config cache: temporary file creation failed" >&2
    else
        # Store cache keys for comparison on subsequent startups.
        printf '# xcode-state: %s\n' "$xcode_state" >"$tmp_cache"
        or set cache_ok false
        printf '# tool-state: %s\n' "$tool_state" >>"$tmp_cache"
        or set cache_ok false

        # Resolve the macOS SDK only when rebuilding the cache.
        if set -l sdk_path (xcrun --sdk macosx --show-sdk-path)
            if test -d "$sdk_path"
                printf 'set -gx SDKROOT %s\n' (string escape --style=script -- "$sdk_path") >>"$tmp_cache"
                or set cache_ok false
            else
                set cache_ok false
            end
        else
            set cache_ok false
        end

        # Cache generated shell initialization code.
        ensure_installed direnv hook fish >>"$tmp_cache"
        or set cache_ok false

        ensure_installed mise activate fish >>"$tmp_cache"
        or set cache_ok false

        ensure_installed zoxide init fish >>"$tmp_cache"
        or set cache_ok false

        # LS_COLORS is a value, so escape it before writing fish code.
        if command -sq vivid
            if set -l colors (ensure_installed vivid generate ansi-colorful)
                if test -n "$colors"
                    printf 'set -gx LS_COLORS %s\n' (string escape --style=script -- "$colors") >>"$tmp_cache"
                    or set cache_ok false
                else
                    set cache_ok false
                end
            else
                set cache_ok false
            end
        else
            echo '# command vivid not found' >>"$tmp_cache"
            or set cache_ok false
        end

        ensure_installed jj util completion fish >>"$tmp_cache"
        or set cache_ok false

        # Commit only valid, fully generated cache content.
        if test "$cache_ok" = true; and fish -n "$tmp_cache"; and mv "$tmp_cache" "$CONFIG_CACHE"
            set_color brmagenta --bold --underline
            echo "config cache updated"
            set_color normal
        else
            echo "config cache generation failed; previous cache retained" >&2
        end
    end
end

# Reuse the previous cache if regeneration failed.
if test -f "$CONFIG_CACHE"
    source "$CONFIG_CACHE"
else
    echo "config cache unavailable" >&2
end

# neovim
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "nvim +Man!"

if status is-interactive
    stty stop undef
    stty start undef
end

set -g NA_PACKAGE_MANAGER_LIST bun deno pnpm npm yarn
set -g NA_FUZZYFINDER_OPTIONS --bind 'one:accept' --query '^'

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# BEGIN tirith-hook v1
tirith init --shell fish | source
# END tirith-hook
