local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local batteryarc_widget = {}

local function worker(user_args)
  local args = user_args or {}

  local timeout = args.timeout or 10
  local show_notification_mode = args.show_notification_mode or 'on_hover' -- on_hover / on_click
  local notification_position = args.notification_position or 'top_right' -- see naughty.notify position argument

  local full_color = args.full_color or beautiful.fg_normal
  local low_level_color = args.low_level_color or beautiful.error
  local medium_level_color = args.medium_level_color or beautiful.accent
  local charging_color = args.charging_color or beautiful.success

  local warning_msg_title = args.warning_msg_title or 'Dying in ...'
  local warning_msg_text = args.warning_msg_text or 'Battery is dying'
  local warning_msg_position = args.warning_msg_position or 'bottom_right'
  local enable_battery_warning = args.enable_battery_warning
  if enable_battery_warning == nil then
    enable_battery_warning = true
  end

  batteryarc_widget = wibox.widget {
    max_value = 100,
    thickness = 2,
    rounded_edge = true,
    start_angle = 4.71238898, -- 2pi * 3/4
    forced_height = 12,
    forced_width = 12,
    widget = wibox.container.arcchart
  }

  local last_battery_check = os.time()

  -- Show warning notification
  local function show_battery_warning()
    naughty.notify {
      preset = naughty.config.presets.critical,
      text = warning_msg_text,
      title = warning_msg_title,
      timeout = 25,
      hover_timeout = 0.5,
      position = warning_msg_position,
      width = 300,
    }
  end

  local function update_widget(widget, stdout)
    local charge = 0
    local status
    for s in stdout:gmatch("[^\r\n]+") do
      local cur_status, charge_str, _ = string.match(s, '.+: ([%a%s]+), (%d?%d?%d)%%,?(.*)')
      if cur_status ~= nil and charge_str ~= nil then
        local cur_charge = tonumber(charge_str)
        if cur_charge > charge then
          status = cur_status
          charge = cur_charge
        end
      end
    end

    widget.value = charge

    if status == 'Charging' then
      widget.colors = { charging_color }
    elseif charge < 15 then
      widget.colors = { low_level_color }
      if enable_battery_warning and status ~= 'Charging' and os.difftime(os.time(), last_battery_check) > 300 then
        -- if 5 minutes have elapsed since the last warning
        last_battery_check = os.time()

        show_battery_warning()
      end
    elseif charge > 15 and charge < 40 then
      widget.colors = { medium_level_color }
    else
      widget.colors = { full_color }
    end
  end

  watch("acpi", timeout, update_widget, batteryarc_widget)

  -- Popup with battery info
  local notification
  local function show_battery_status()
    awful.spawn.easy_async([[bash -c 'battery']],
      function(stdout, _, _, _)
      naughty.destroy(notification)
      notification = naughty.notify {
        text = stdout,
        title = "Battery status",
        timeout = 5,
        width = 200,
        position = notification_position,
      }
    end)
  end

  if show_notification_mode == 'on_hover' then
    batteryarc_widget:connect_signal("mouse::enter", function() show_battery_status() end)
    batteryarc_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)
  elseif show_notification_mode == 'on_click' then
    batteryarc_widget:connect_signal('button::press', function(_, _, _, button)
      if (button == 1) then show_battery_status() end
    end)
  end

  return batteryarc_widget
end

return setmetatable(batteryarc_widget, { __call = function(_, ...)
  return worker(...)
end })
