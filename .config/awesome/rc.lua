tags       = {"S", "W", "C", "F", "M", "V", "S", "D", "T"}
terminal   = os.getenv("TERMINAL") or "alacritty"
editor     = os.getenv("EDITOR") or "nano"

pcall(require, "luarocks.loader")
require("modules.error")
require("awful.autofocus")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local utils     = require('modules.utils')
local keys      = require("modules.keys")
local rules     = require("modules.rules")
local menu      = require("modules.menu")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
screen.connect_signal("property::geometry", utils.set_wallpaper)

root.keys(keys.global_keys)
awful.screen.connect_for_each_screen(function(s) menu.init(s) end)
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.spiral.dwindle
}
awful.rules.rules = rules

client.connect_signal("manage", function(c)
    if c.floating then awful.placement.centered(c) end
    if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

awful.spawn("alacritty --class \"flyterm\" -e tmux new-session -s flyterm")
