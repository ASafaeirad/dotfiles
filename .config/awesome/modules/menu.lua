local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require("beautiful")

local utils = require('modules.utils')

local battery = require("widgets.battery")
local volume = require("widgets.volume")
local brightness = require("widgets.brightness")
local keyboard_layout = require("widgets.keyboard")
local date = require("widgets.date")
local time = require("widgets.time")

local module = {}

function module.init(screen)
  utils.set_wallpaper()
  screen.padding = {
    top = beautiful.useless_gap * 2,
  }


  awful.tag(tags, screen, awful.layout.layouts[1])

  screen.tray = wibox.widget.systray()
  screen.tray:set_base_size(beautiful.menu.tray.size)
  screen.tray.forced_height = beautiful.menu.tray.height

  screen.taglist = awful.widget.taglist {
    screen = screen,
    filter = awful.widget.taglist.filter.all,
    buttons = gears.table.join(
      awful.button({}, 1, function(t) t:view_only() end)
    ),
    widget_template = {
      widget = wibox.container.background,
      id = 'background_role',
      {
        widget = wibox.container.margin,
        left = beautiful.taglist.padding,
        right = beautiful.taglist.padding,
        { id = 'text_role', widget = wibox.widget.textbox },
      },
    }
  }

  screen.wibar = awful.wibar({
    position = "top",
    width = screen.geometry.width - beautiful.useless_gap * 4,
    height = beautiful.menu.height,
    screen = screen,
    stretch = false,
    margins = beautiful.useless_gap * 2,
  })

  screen.wibar.y = beautiful.useless_gap * 2

  screen.wibar:setup {
    right = beautiful.menu.padding.right,
    left = beautiful.menu.padding.left,
    layout = wibox.container.margin,
    {
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        screen.taglist,
        nil,
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = beautiful.menu.spacing,
          brightness(),
          volume,
          battery(),
          date,
          time,
          keyboard_layout(),
          { layout = wibox.container.place, screen.tray, valign = "center", halign = "center"}
        }
      },
    }
  }
end


return module
