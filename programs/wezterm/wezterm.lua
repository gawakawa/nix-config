local wezterm = require("wezterm")

return {
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
	window_background_opacity = 1,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	macos_window_background_blur = 20,

	initial_cols = 150,
	initial_rows = 45,

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

	background = {
		{
			source = {
				File = wezterm.home_dir .. "/.config/nix-config/programs/wezterm/images/shami_momo.JPG",
			},
			opacity = wezterm.target_triple:find("darwin") and 0.25 or 0.15,
		},
	},
}
