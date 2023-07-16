-- Pull in the WezTerm API:
local wezterm = require("wezterm")

-- This table will hold the config:
local config = {}

-- In newer versions of WezTerm, use the config_builder
-- which will help provide clearer error messages:
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices:

-- Disable window title bar, enable window shadow, and make the window resizable:
config.window_decorations = "RESIZE | MACOS_FORCE_ENABLE_SHADOW"

-- Configure the window size:
config.initial_cols = 140
config.initial_rows = 50

-- Configure the opacity of window background:
config.window_background_opacity = 0.8

-- Configure the blur of window background:
config.macos_window_background_blur = 35

-- Configure the appearance of title bar:
config.window_frame = {
	font = wezterm.font({ family = "Hack Nerd Font Mono", weight = "Regular" }),
	font_size = 13.5,
	active_titlebar_bg = "#001b21",
	inactive_titlebar_bg = "#001b21",
}

-- Configure the tab:

-- Equivalent to POSIX basename(3):
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Configure the appearance of tab:
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- Display icons according to process:
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
	-- local index = tab.tab_index + 1
	local cwd = basename(pane.current_working_dir)

	local title = tab.tab_index .. ": " .. cwd .. " | " .. process_name
	if icon ~= nil then
		title = icon .. " " .. zoomed .. title
	end
	return {
		{ Text = " " .. title .. " " },
	}
end)

-- Configure the font:
config.font = wezterm.font("Hack Nerd Font Mono", { weight = "Regular" })

-- Configure the font size:
config.font_size = 13.5

-- Configure the color scheme:
-- Below are some of my favorite cool color schemes:
-- config.color_scheme = 'Google Dark (Gogh)'
-- config.color_scheme = 'OceanicMaterial'
-- config.color_scheme = 'Rapture'
-- config.color_scheme = 'Snazzy'
-- config.color_scheme = 'Solar Flare (base15)'
-- config.color_scheme = 'Solarized Dark (Gogh)'
-- config.color_scheme = 'Solarized Dark - Patched'
-- config.color_scheme = 'Solarized Dark Higher Contrast'

-- Below are some color schemes that I thought were nice:
-- config.color_scheme = 'Ayu Mirage'
-- config.color_scheme = 'Ayu Mirage (Gogh)'
-- config.color_scheme = 'Colors (base16)'
-- config.color_scheme = 'Dark+'
-- config.color_scheme = 'Helios (base16)'
-- config.color_scheme = 'midnight-in-mojave'
-- config.color_scheme = 'Pinky (base16)'
-- config.color_scheme = 'Solarized (dark) (terminal.sexy)'
-- config.color_scheme = 'Wez'

-- Configure the colors:
config.colors = {
	-- The best color scheme I made myself because there isn't one I like.
	-- Check it out!
	foreground = "#aab6b7",
	background = "#001b21",
	cursor_fg = "#073642",
	cursor_bg = "#839496",
	cursor_border = "#839496",
	selection_fg = "#eee8d5",
	selection_bg = "#073642",
	ansi = {
		"#073642",
		"#dc322f",
		"#64be0a",
		"#c7a427",
		"#268bd2",
		"#d33682",
		"#2aa198",
		"#eee8d5",
	},
	brights = {
		"#073642",
		"#dc322f",
		"#64be0a",
		"#c7a427",
		"#268bd2",
		"#d33682",
		"#2aa198",
		"#eee8d5",
	},

	-- Configure the appearance of tab bar:
	tab_bar = {
		inactive_tab_edge = "#001b21",
		active_tab = {
			bg_color = "#073642",
			fg_color = "#aab6b7",
		},
		inactive_tab = {
			bg_color = "#001b21",
			fg_color = "#839496",
		},
		inactive_tab_hover = {
			bg_color = "#073642",
			fg_color = "#839496",
		},
		new_tab = {
			bg_color = "#001b21",
			fg_color = "#839496",
		},
		new_tab_hover = {
			bg_color = "#073642",
			fg_color = "#839496",
		},
	},
}

-- Finally, return the config to WezTerm:
return config
