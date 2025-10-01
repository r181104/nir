local wezterm = require("wezterm")
local act = wezterm.action

-- NOTE: STATUS BAR
wezterm.on("update-status", function(window, pane)
	local date = wezterm.strftime("%Y-%m-%d %H:%M")
	local cwd_uri = pane:get_current_working_dir()
	local cwd = ""
	if cwd_uri then
		cwd = cwd_uri.file_path or ""
	end

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "cyan" } },
		{ Text = " " .. cwd .. " " },
		{ Foreground = { Color = "orange" } },
		{ Text = date .. " " },
	}))
end)

-- NOTE: CUSTOM TAB BAR (tmux-style bottom bar)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local index = tab.tab_index + 1
	local title = tab.active_pane.title

	if tab.is_active then
		return {
			{
				Background = { Color = "#5E81AC" },
				Foreground = { Color = "#ECEFF4" },
				Text = " " .. index .. ":" .. title .. " ",
			},
		}
	else
		return {
			{
				Background = { Color = "#3B4252" },
				Foreground = { Color = "#D8DEE9" },
				Text = " " .. index .. ":" .. title .. " ",
			},
		}
	end
end)

-- NOTE: Load pywal colors
local function get_pywal_colors()
	local file = io.open(os.getenv("HOME") .. "/.cache/wal/colors.json")
	if not file then
		return {}
	end
	local data = file:read("*a")
	file:close()
	local ok, json = pcall(wezterm.json_parse, data)
	if not ok then
		return {}
	end
	return json
end

local pywal = get_pywal_colors()

local scheme = {
	foreground = pywal.special and pywal.special.foreground or "#c0c0c0",
	background = pywal.special and pywal.special.background or "#000000",
	cursor_bg = pywal.special and pywal.special.cursor or "#ffffff",
	cursor_fg = pywal.special and pywal.special.background or "#000000",
	cursor_border = pywal.special and pywal.special.cursor or "#ffffff",

	ansi = {
		pywal.colors and pywal.colors.color0 or "#000000",
		pywal.colors and pywal.colors.color1 or "#ff0000",
		pywal.colors and pywal.colors.color2 or "#00ff00",
		pywal.colors and pywal.colors.color3 or "#ffff00",
		pywal.colors and pywal.colors.color4 or "#0000ff",
		pywal.colors and pywal.colors.color5 or "#ff00ff",
		pywal.colors and pywal.colors.color6 or "#00ffff",
		pywal.colors and pywal.colors.color7 or "#c0c0c0",
	},

	brights = {
		pywal.colors and pywal.colors.color8 or "#808080",
		pywal.colors and pywal.colors.color9 or "#ff0000",
		pywal.colors and pywal.colors.color10 or "#00ff00",
		pywal.colors and pywal.colors.color11 or "#ffff00",
		pywal.colors and pywal.colors.color12 or "#0000ff",
		pywal.colors and pywal.colors.color13 or "#ff00ff",
		pywal.colors and pywal.colors.color14 or "#00ffff",
		pywal.colors and pywal.colors.color15 or "#ffffff",
	},
}

-- NOTE: Watch pywal JSON for changes
wezterm.add_to_config_reload_watch_list(os.getenv("HOME") .. "/.cache/wal/colors.json")

wezterm.on("window-config-reloaded", function(window, pane)
	window:toast_notification("WezTerm", "Pywal colors reloaded", nil, 3000)
end)

return {
	font = wezterm.font_with_fallback({ "MesloLGS Nerd Font", "FiraCode Nerd Font" }),
	font_size = 24,
	hide_tab_bar_if_only_one_tab = false,
	use_fancy_tab_bar = false,
	show_new_tab_button_in_tab_bar = false,
	status_update_interval = 1000,
	window_decorations = "NONE",
	enable_scroll_bar = false,
	disable_default_key_bindings = true,

	unix_domains = { { name = "unix" } },
	default_gui_startup_args = { "connect", "unix" },
	keys = {
		-- NOTE: Tabs
		{ key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "ALT", action = act.CloseCurrentTab({ confirm = true }) },
		{ key = "l", mods = "ALT", action = act.ActivateTabRelative(1) },
		{ key = "h", mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = "N", mods = "ALT", action = act.ActivateTabRelative(1) },
		{ key = "P", mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
		{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
		{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
		{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
		{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
		{ key = "6", mods = "ALT", action = act.ActivateTab(5) },
		{ key = "7", mods = "ALT", action = act.ActivateTab(6) },
		{ key = "8", mods = "ALT", action = act.ActivateTab(7) },
		{ key = "9", mods = "ALT", action = act.ActivateTab(8) },
		-- NOTE: Panes
		{ key = "V", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "S", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "q", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
		-- NOTE: Navigation
		{ key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
		{ key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
		{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
		{ key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
		-- NOTE: Resize (FIXED)
		{ key = "H", mods = "CTRL", action = act.AdjustPaneSize({ "Left", 3 }) },
		{ key = "L", mods = "CTRL", action = act.AdjustPaneSize({ "Right", 3 }) },
		{ key = "K", mods = "CTRL", action = act.AdjustPaneSize({ "Up", 2 }) },
		{ key = "J", mods = "CTRL", action = act.AdjustPaneSize({ "Down", 2 }) },
		-- NOTE: Misc
		{ key = "r", mods = "ALT", action = act.ReloadConfiguration },
		{ key = "F", mods = "ALT", action = act.Search({ CaseInSensitiveString = "" }) },
		{ key = "c", mods = "ALT", action = act.CopyTo("Clipboard") },
		{ key = "v", mods = "ALT", action = act.PasteFrom("Clipboard") },
		-- NOTE: Multiplexer
		{ key = "d", mods = "ALT", action = act.DetachDomain("CurrentPaneDomain") },
		{ key = "a", mods = "ALT", action = act.AttachDomain("unix") },
		{ key = "Y", mods = "ALT", action = act.ActivateCopyMode },
	},

	-- NOTE: Pywal colors injected
	colors = scheme,
	window_background_opacity = tonumber(pywal.alpha) / 100 or 1.0,
}
