local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- config.color_scheme_dirs = { '/some/path/my/color/schemes' }
-- config.window_background_image = '/some/path/to/wallpaper'
config.window_background_opacity = 8.0
config.font = wezterm.font("MesloLGS Nerd Font")
config.font_size = 22
config.color_scheme = "Dracula"
config.leader = { key = "Space", mods = "ALT", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
}
return config
