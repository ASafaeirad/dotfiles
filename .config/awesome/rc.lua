require("modules.error")
require("modules.manage")
tags = { "N", "W", "C", "F", "M", "V", "S", "D", "T" }

local fs = require("gears.filesystem")
local theme = fs.get_configuration_dir() .. "theme.lua";

local beautiful = require("beautiful")
beautiful.init(theme)

local awful = require("awful")
local keys = require("modules.keys")
local global_rules = require("modules.rules")
local menu = require("modules.menu")

awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.fair,
}
awful.screen.connect_for_each_screen(menu.init)
awful.rules.rules = global_rules
root.keys(keys.global_keys)
