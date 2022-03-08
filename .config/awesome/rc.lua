-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- {{{ Module loader
function loadrc(name, mod)
   local success
   local result

   local path = awful.util.getdir("config") .. "/modules/" .. name .. ".lua"

 -- If the module is already loaded, don't load it again
 if mod and package.loaded[mod] then return package.loaded[mod] end

 -- Execute the RC/module file
 success, result = pcall(function() return dofile(path) end)
   if not success then
      naughty.notify({ title = "Error while loading an RC file",
       text = "When loading `" .. name ..
    "`, got the following error:\n" .. result,
           preset = naughty.config.presets.critical
         })
      return print("E: error loading RC file '" .. name .. "': " .. result)
   end

   -- Is it a module?
   if mod then
      return package.loaded[mod]
   end

   return result
end
-- }}}

terminal   = os.getenv("TERMINAL") or "alacritty"
editor     = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

loadrc("error")
local sutils = loadrc('utils')

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
screen.connect_signal("property::geometry", sutils.set_wallpaper)

loadrc("menu")
local keys = loadrc("keys")
local rules = loadrc("rules")

awful.screen.connect_for_each_screen(function(s) initMenu(s) end)

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.spiral.dwindle
}

root.keys(keys.global_keys)
awful.rules.rules = rules

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if c.floating then awful.placement.centered(c) end
    if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

awful.spawn("alacritty --class \"flyterm\" -e tmux new-session -s flyterm")
