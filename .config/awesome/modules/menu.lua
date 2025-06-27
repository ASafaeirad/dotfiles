local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local xresources = require("beautiful.xresources")
local battery = require("widgets.battery")
local dpi = xresources.apply_dpi

local utils = require('modules.utils')
local colors = require('modules.colors')
local volume = require("widgets.volume")
local brightness = require("widgets.brightness")
local keyboard_layout = require("widgets.keyboard")
local beautiful = require("beautiful")

local module = {}

local date = wibox.widget.textclock("<span font='" .. beautiful.font .. "'> %a %b %d</span>")
local time = wibox.widget.textclock("<span font='" .. beautiful.font .. "'> %H:%M </span>", 10)

local tray = wibox.widget.systray()
tray:set_base_size(12)
tray.forced_height = 16

function module.init(screen)
  utils.set_wallpaper()
  screen.padding = {
    top = beautiful.useless_gap * 2,
  }

  awful.tag(tags, screen, global_layouts[1])

  screen.taglist = awful.widget.taglist {
    screen = screen,
    filter = awful.widget.taglist.filter.all,
    buttons = gears.table.join(
      awful.button({}, 1, function(t) t:view_only() end),
      awful.button({}, 3, awful.tag.viewtoggle)
    ),
    widget_template = {
      widget = wibox.container.background,
      id = 'background_role',
      {
        widget = wibox.container.margin,
        left = beautiful.tag_padding,
        right = beautiful.tag_padding,
        { id = 'text_role', widget = wibox.widget.textbox },
      },
    }
  }

  screen.wibar = awful.wibar({
    position = "top",
    width = screen.geometry.width - beautiful.useless_gap * 4,
    height = beautiful.menu_height,
    screen = screen,
    stretch = false,
    margins = beautiful.useless_gap * 2,
  })

  screen.wibar.y = beautiful.useless_gap * 2

  screen.wibar:setup {
    right = dpi(36),
    left = beautiful.menu_padding,
    layout = wibox.container.margin,
    {
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        { layout = wibox.layout.fixed.horizontal, screen.taglist },
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
          keyboard_layout(),
          { tray, valign = "center", halign = "center", layout = wibox.container.place }
        }
      },
    }
  }
end

return module
