local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local naughty = require("naughty")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local xrdb = xresources.get_current_theme()

local theme = dofile(themes_path .. "default/theme.lua")

theme.font = "Monaspace Argon 10"
theme.fg = xrdb.foreground
theme.bg = xrdb.background
theme.bg_alt = "#323643"

theme.bg_normal = theme.bg
theme.bg_focus = theme.bg
theme.bg_urgent = theme.bg
theme.bg_minimize = theme.bg
theme.bg_systray = theme.bg

theme.fg_normal = theme.fg
theme.fg_focus = xrdb.color11
theme.fg_urgent = xrdb.color9
theme.fg_minimize = xrdb.color8

theme.error = xrdb.color9
theme.accent = xrdb.color11
theme.success = xrdb.color10
theme.mute = xrdb.color8

theme.taglist = {
  padding = dpi(12),
}
theme.taglist_fg_empty = theme.mute

theme.border_width = dpi(10)
theme.border_normal = theme.accent
theme.border_focus = theme.accent
theme.border_marked = "#FF0000"

theme.useless_gap = dpi(2)
theme.systray_icon_spacing = dpi(6)

theme.menu = {
  height = dpi(50),
  padding = {
    left = dpi(16),
    right = dpi(24),
  },
  spacing = dpi(8),
  width = dpi(100),
  tray = {
    height = dpi(14),
    size = dpi(16),
  },
}

theme.icon_theme = nil

local nconf = naughty.config
nconf.defaults.timeout = 6
nconf.defaults.position = "bottom_right"
nconf.padding = dpi(10)
nconf.spacing = 8
nconf.presets.normal.bg = theme.bg_alt
nconf.defaults.margin = dpi(16)
nconf.presets.critical.bg = theme.error
nconf.presets.critical.fg = theme.bg

-- Remove taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

return theme
