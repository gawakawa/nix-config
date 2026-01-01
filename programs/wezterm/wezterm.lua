local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Platform detection
local is_darwin = wezterm.target_triple:find("darwin") ~= nil

-- Equivalent to POSIX basename(3)
local function basename(s)
	return string.match(s, "([^/\\]+)[/\\]*$") or s
end

-- Tab bar styling with Nerd Font triangles
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, _tabs, _panes, _cfg, _hover, max_width)
	local background = "#3e4451"
	local foreground = "#abb2bf"
	local edge_background = "none"

	if tab.is_active then
		background = "#61afef"
		foreground = "#282c34"
	end

	local edge_foreground = background
	local title = "   "
		.. wezterm.truncate_right(basename(tab.active_pane.current_working_dir.file_path), max_width - 1)
		.. "   "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

-- Leader key and keybindings
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Pane splitting
	{ key = "d", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "r", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Pane navigation (Vim-style)
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	-- Pane management
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	-- Tab navigation (Vim-style)
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
	-- Pane resize mode
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
	},
}
config.key_tables = {
	resize_pane = {
		{ key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
		{ key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
		{ key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
		{ key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

-- Terminal settings
config.term = "wezterm"
config.font = wezterm.font({
	family = "FiraCode Nerd Font",
	harfbuzz_features = {
		"cv02",
		"cv24",
		"cv25",
		"cv26",
		"cv28",
		"cv29",
		"cv30",
		"cv32",
		"ss03",
		"ss05",
		"ss07",
		"ss09",
	},
})
config.font_size = 15.0

-- Input and window settings
config.use_ime = true
config.window_background_opacity = 0.7
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}
config.macos_window_background_blur = 20

-- Tab bar settings
if is_darwin then
	config.window_decorations = "RESIZE"
else
	config.window_decorations = "NONE"
end
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.window_background_gradient = {
	colors = { "#000000" },
}
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

return config
