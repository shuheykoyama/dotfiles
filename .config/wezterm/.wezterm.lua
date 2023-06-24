-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- changing the window size:
config.initial_cols = 140
config.initial_rows = 50

-- changing the color scheme:
-- The followings are curated color schemes.
-- Google Dark (Gogh): great 5/5
-- config.color_scheme = 'Google Dark (Gogh)'
-- OceanicMaterial: great 5/5
-- config.color_scheme = 'OceanicMaterial'
-- Rapture: great 5/5
config.color_scheme = 'Rapture'
-- Snazzy: great 5/5
-- config.color_scheme = 'Snazzy'
-- Solar Flare (base16): great 4/5
-- config.color_scheme = 'Solar Flare (base15)'

-- The followings are some of my favorite color schemes.
-- Ayu Mirage: good
-- Ayu Mirage (Gogh): good
-- Colors (base16): great 4/5
-- Dark+: good
-- Helios (base16): good
-- midnight-in-mojave: great
-- Pinky (base16): good
-- Solarized (dark) (terminal.sexy): nice?
-- Wez: great 4/5

-- changing the opacity of window background:
config.window_background_opacity = 0.9

-- changing the blur of window background:
config.macos_window_background_blur = 10

-- Disable window title bar, enable window shadow, and make the window resizable
config.window_decorations = "RESIZE | MACOS_FORCE_ENABLE_SHADOW"

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Customize tab
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  -- Display icons according to process
  local nerd_icons = {
    nvim = wezterm.nerdfonts.custom_vim,
    vim = wezterm.nerdfonts.custom_vim,
    bash = wezterm.nerdfonts.dev_terminal,
    zsh = wezterm.nerdfonts.dev_terminal,
    ssh = wezterm.nerdfonts.mdi_server,
    top = wezterm.nerdfonts.mdi_monitor,
    docker = wezterm.nerdfonts.dev_docker,
  }
  local zoomed = ""
  if tab.active_pane.is_zoomed then
    zoomed = "[Z]"
  end
  local pane = tab.active_pane
  local process_name = basename(pane.foreground_process_name)
  local icon = nerd_icons[process_name]
  local index = tab.tab_index + 1
  local cwd = basename(pane.current_working_dir)

  local title = index .. ": " .. cwd .. " | " .. process_name
  if icon ~= nil then
    title = icon .. " " .. zoomed .. title
  end
  return {
    { Text = "" .. title .. "" },
  }
end)

-- changing the font:
config.font = wezterm.font('Hack Nerd Font Mono', { weight = 'Regular' })

-- changing the font size:
config.font_size = 13.0

-- and finally, return the configuration to wezterm
return config
