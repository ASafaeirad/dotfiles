local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local hotkeys_popup = require("awful.hotkeys_popup")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local battery_widget = require("widgets.battery-legacy")
local battery = require("widgets.battery")

local utils = require('modules.utils')
local colors = require('modules.colors')
local volume = require("widgets.volume")
local brightness = require("widgets.brightness")
local keyboardlayout = require("widgets.keyboard")

require("awful.hotkeys_popup.keys")

local module = {}

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({}, 3, awful.tag.viewtoggle)
)

local date = wibox.widget.textclock(" %a %b %d ")
local time = wibox.widget.textclock("%H:%M", 10)
local batt = battery_widget {
  ac_prefix = "",
  battery_prefix = {
    { 10, "" },
    { 25, "" },
    { 50, "" },
    { 75, "" },
    { 99, "" }
  },
  percent_colors = {
    { 20, colors.error },
    { 99, colors.fg },
    { 999, colors.accent },
  },
  alert_threshold = 10,
  alert_title = "Dead",
  alert_text = "${AC_BAT}${time_est}"
}

local tray = wibox.widget.systray()
tray:set_base_size(12)
tray.forced_height = 16

function module.init(s)
  utils.set_wallpaper(s)
  s.padding = {
    top = dpi(4)
  }
  awful.tag(tags, s, awful.layout.suit.tile)

  s.mypromptbox = awful.widget.prompt()

  s.mytaglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
    widget_template = {
      {
        {
          {
            { id = 'text_role', widget = wibox.widget.textbox },
            widget = wibox.container.margin
          },
          layout = wibox.layout.fixed.horizontal
        },
        left = dpi(12),
        right = dpi(12),
        widget = wibox.container.margin
      },
      id = 'background_role',
      widget = wibox.container.background
    }
  }

  s.mywibox = awful.wibar({
    position = "top",
    width = s.geometry.width - dpi(8),
    height = dpi(35),
    screen = s,
    stretch = false,
    margins = dpi(10)
  })
  s.mywibox.y = dpi(4)

  s.mywibox:setup {
    right = dpi(36),
    left = dpi(16),
    layout = wibox.container.margin,
    {
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        { layout = wibox.layout.fixed.horizontal, s.mytaglist, s.mypromptbox },
        nil,
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(8),
          brightness({}),
          volume,
          battery({
            low_level_color = colors.error,
            medium_level_color = colors.accent,
            main_color = colors.success,
            charging_color = colors.success
          }),
          date,
          time,
          keyboardlayout(),
          { tray, valign = "center", halign = "center", layout = wibox.container.place }
        }
      },
    }
  }
end

return module
