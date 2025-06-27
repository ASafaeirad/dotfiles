require("modules.manage")
local awful = require("awful")
tags = { "N", "W", "C", "F", "M", "V", "S", "D", "T" }
global_layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.fair,
}

require("modules.error")

local gears = require("gears")
local beautiful = require("beautiful")

local theme = gears.filesystem.get_configuration_dir() .. "theme.lua";
beautiful.init(theme)

local utils = require("modules.utils")
local keys = require("modules.keys")
local global_rules = require("modules.rules")
local menu = require("modules.menu")

screen.connect_signal("property::geometry", utils.set_wallpaper)

awful.screen.connect_for_each_screen(menu.init)
awful.layout.layouts = global_layouts
awful.rules.rules = global_rules

root.keys(keys.global_keys)
