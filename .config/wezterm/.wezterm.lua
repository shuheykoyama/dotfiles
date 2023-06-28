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
-- Below are some of my favorite cool color schemes.
-- config.color_scheme = 'Google Dark (Gogh)'
-- config.color_scheme = 'OceanicMaterial'
-- config.color_scheme = 'Rapture'
-- config.color_scheme = 'Snazzy'
-- config.color_scheme = 'Solar Flare (base15)'
-- config.color_scheme = 'Solarized Dark (Gogh)'
-- config.color_scheme = 'Solarized Dark - Patched'
-- config.color_scheme = 'Solarized Dark Higher Contrast'

-- Below are some color schemes that I thought were nice.
-- config.color_scheme = 'Ayu Mirage'
-- config.color_scheme = 'Ayu Mirage (Gogh)'
-- config.color_scheme = 'Colors (base16)'
-- config.color_scheme = 'Dark+'
-- config.color_scheme = 'Helios (base16)'
-- config.color_scheme = 'midnight-in-mojave'
-- config.color_scheme = 'Pinky (base16)'
-- config.color_scheme = 'Solarized (dark) (terminal.sexy)'
-- config.color_scheme = 'Wez'

-- The best color scheme I made myself because there isn't one I like.
-- Check it out!
config.colors = {
  foreground = '#839496',
  background = '#001b21',
  cursor_bg = '#839496',
  cursor_fg = '#073642',
  --   cursor_border = '',
  selection_fg = '#93a1a1',
  selection_bg = '#073642',
  --   scrollbar_thumb = '',
  --   split = '',
  ansi = {
    '#073642',
    '#dc322f',
    '#6adf3c',
    '#e8ae2c',
    '#268bd2',
    '#d33682',
    '#2aa198',
    '#eee8d5',
  },
  brights = {
    '#073642',
    '#dc322f',
    '#6adf3c',
    '#e8ae2c',
    '#268bd2',
    '#d33682',
    '#2aa198',
    '#eee8d5',
  },
}

-- changing the opacity of window background:
config.window_background_opacity = 0.8

-- changing the blur of window background:
config.macos_window_background_blur = 35

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
