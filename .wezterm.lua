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

	-- NOTE: active tab highlight
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

return {
	font = wezterm.font_with_fallback({ "MesloLGS Nerd Font", "FiraCode Nerd Font" }),
	font_size = 24,
	color_scheme = "Rosé Pine (Gogh)",
	hide_tab_bar_if_only_one_tab = false,
	use_fancy_tab_bar = false,
	show_new_tab_button_in_tab_bar = false,
	tab_max_width = 24,
	status_update_interval = 1000,
	window_decorations = "RESIZE",
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
		{ key = "n", mods = "ALT", action = act.ActivateTabRelative(1) },
		{ key = "p", mods = "ALT", action = act.ActivateTabRelative(-1) },
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
}
