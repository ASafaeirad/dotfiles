local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")

local get_brightness_cmd

local brightness_widget = {}

local function worker(user_args)

  local args = user_args or {}
  local timeout = args.timeout or 100
  local current_level = 0
  local tooltip = args.tooltip or false

  get_brightness_cmd = 'light -G'

  brightness_widget.widget = wibox.widget {
    widget = wibox.container.arcchart,
    max_value = 100,
    thickness = 2,
    start_angle = 4.71238898, -- 2pi * 3 / 4
    value = 100,
    forced_height = 12,
    forced_width = 12,
    paddings = 8,
    colors = { beautiful.accent },
    set_value = function(self, level)
      self:set_value(level)
    end
  }


  local update_widget = function(widget, stdout, _, _, _)
    local brightness_level = tonumber(string.format("%.0f", stdout)) or 100
    current_level = brightness_level
    widget:set_value(brightness_level)
  end

  function brightness_widget:update()
    spawn.easy_async(get_brightness_cmd, function(out)
      update_widget(brightness_widget.widget, out)
    end)
  end

  watch(get_brightness_cmd, timeout, update_widget, brightness_widget.widget)

  if tooltip then
    awful.tooltip {
      objects        = { brightness_widget.widget },
      timer_function = function()
        return current_level .. " %"
      end,
    }
  end

  local brightness_timer = timer({ timeout = 5 })
  brightness_timer:connect_signal("timeout", function() brightness_widget:update() end)
  brightness_timer:start()
  return brightness_widget.widget
end

return setmetatable(brightness_widget, { __call = function(_, ...)
  return worker(...)
end })
