local wezterm = require("wezterm")

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local get_opacity = function()
	local config_dir = wezterm.config_dir
	local opacity_file = config_dir .. "/opacity.txt"

	local file = io.open(opacity_file, "r")
	if file then
		local content = file:read("*all")
		file:close()
		local opacity = tonumber(content:match("%S+"))
		if opacity and opacity >= 0 and opacity <= 1 then
			return opacity
		end
	end

	return 1
end

local config = {
	window_padding = {
		left = 6,
		right = 3,
		top = 3,
		bottom = 3,
	},

	font = wezterm.font({
		family = "JetBrains Mono",
		-- harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
	}),
	color_scheme_dirs = { "/usr/share/wezterm/colors/*/" },
	color_scheme = "Dracula",
	-- window_background_opacity = 0.90,
	window_background_opacity = get_opacity(),
	warn_about_missing_glyphs = false,
	enable_wayland = false,
	enable_scroll_bar = true,
}

if is_linux() then
	config.font_size = 10
	config.dpi = 96.0
	config.enable_tab_bar = false
end

if is_darwin() then
	config.initial_cols = 160
	config.initial_rows = 40

	config.font_size = 12
	config.enable_tab_bar = true
	config.window_frame = {
		font = wezterm.font("Hack Nerd Font Mono"),
		font_size = 9.0,
	}
	config.macos_window_background_blur = 8
end

return config
