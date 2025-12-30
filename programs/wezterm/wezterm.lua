local wezterm = require("wezterm")

return {
	leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
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
		-- Pane resize mode
		{
			key = "s",
			mods = "LEADER",
			action = wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
		},
	},
	key_tables = {
		resize_pane = {
			{ key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
			{ key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
			{ key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
			{ key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
			{ key = "Enter", action = "PopKeyTable" },
		},
	},

	term = "wezterm",
	font = wezterm.font({
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
	}),
	font_size = 15.0,

	use_ime = true,
	window_background_opacity = 0.7,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	macos_window_background_blur = 20,

	show_tabs_in_tab_bar = true,

	window_frame = {
		inactive_titlebar_bg = "none",
		active_titlebar_bg = "none",
	},
	window_background_gradient = {
		colors = { "#000000" },
	},
	colors = {
		tab_bar = {
			inactive_tab_edge = "none",
		},
	},
}
