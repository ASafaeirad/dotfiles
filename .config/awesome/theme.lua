local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local naughty = require("naughty")
local dpi = xresources.apply_dpi
local gfs = require("gears.filesystem")
local utils = require("modules.utils")
local colors = require("modules.colors")
local themes_path = gfs.get_themes_dir()
local nconf = naughty.config

local theme = dofile(themes_path.."default/theme.lua")

theme.font          = "Monaspace Argon 10"
theme.fg            = colors.fg
theme.bg            = colors.bg

theme.bg_normal     = theme.bg
theme.bg_focus      = theme.bg
theme.bg_urgent     = theme.bg
theme.bg_minimize   = theme.bg
theme.bg_systray    = theme.bg

theme.fg_normal     = theme.fg
theme.fg_focus      = colors.accent
theme.fg_urgent     = colors.error
theme.fg_minimize   = colors.mute
theme.taglist_fg_empty = colors.mute

theme.border_width  = dpi(2)
theme.border_normal = colors.accent
theme.border_focus  = colors.accent
theme.border_marked = "#FF0000"

theme.useless_gap   = dpi(2)
theme.systray_icon_spacing = dpi(6)

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(16)
theme.menu_width  = dpi(100)

-- nconf.defaults.border_width = 0
-- nconf.defaults.margin = 16
-- nconf.defaults.shape = helpers.rrect(6)
-- nconf.defaults.text = "Boo!"
-- nconf.defaults.timeout = 3
-- nconf.presets.critical.bg = "#FE634E"
-- nconf.presets.critical.fg = "#fefefa"
-- nconf.presets.low.bg = "#1771F1"
nconf.padding = 20
nconf.spacing = 8
nconf.presets.normal.bg = colors.bg1
-- nconf.defaults.icon_size = 64
-- theme.notification_font = "Inter 12.5"


-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Recolor titlebar icons:
--
theme = theme_assets.recolor_titlebar(
    theme, theme.fg_normal, "normal"
)
theme = theme_assets.recolor_titlebar(
    theme, utils.darker(theme.fg_normal, -60), "normal", "hover"
)
theme = theme_assets.recolor_titlebar(
    theme, colors.x, "normal", "press"
)
theme = theme_assets.recolor_titlebar(
    theme, theme.fg_focus, "focus"
)
theme = theme_assets.recolor_titlebar(
    theme, utils.darker(theme.fg_focus, -60), "focus", "hover"
)
theme = theme_assets.recolor_titlebar(
    theme, colors.x, "focus", "press"
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Try to determine if we are running light or dark colorscheme:
local bg_numberic_value = 0;
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
    bg_numberic_value = bg_numberic_value + tonumber("0x"..s);
end
local is_dark_bg = (bg_numberic_value < 383)

theme.wallpaper = "~/Pictures/wallpaper.jpg"

return theme
