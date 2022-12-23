local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local battery = require("widgets.battery")
local naughty = require("naughty")

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

local tray = wibox.widget.systray()
tray:set_base_size(12)
tray.forced_height = 16

function module.init(screen)
  -- Save and restore tags, when monitor setup is changed
  local tag_store = {}
  -- tag.connect_signal("request::screen", function(t)
  --   local fallback_tag = nil

  --   -- find tag with same name on any other screen
  --   for other_screen in screen do
  --     if other_screen ~= t.screen then
  --       fallback_tag = awful.tag.find_by_name(other_screen, t.name)
  --       if fallback_tag ~= nil then
  --         break
  --       end
  --     end
  --   end

    -- no tag with same name exists, chose random one
  --   if fallback_tag == nil then
  --     fallback_tag = awful.tag.find_fallback()
  --   end

  --   if not (fallback_tag == nil) then
  --     local output = next(t.screen.outputs)

  --     if tag_store[output] == nil then
  --       tag_store[output] = {}
  --     end

  --     clients = t:clients()
  --     tag_store[output][t.name] = clients

  --     for _, c in ipairs(clients) do
  --       c:move_to_tag(fallback_tag)
  --     end
  --   end
  -- end)

  screen:connect_signal("added", function(s)
    local output = next(s.outputs)
    naughty.notify({ text = output .. " Connected" })

    tags = tag_store[output]
    if not (tags == nil) then
      naughty.notify({ text = "Restoring Tags" })

      for _, tag in ipairs(s.tags) do
        clients = tags[tag.name]
        if not (clients == nil) then
          for _, client in ipairs(clients) do
            client:move_to_tag(tag)
          end
        end
      end
    end
  end)

  utils.set_wallpaper(screen)
  screen.padding = {
    top = dpi(4)
  }
  awful.tag(tags, screen, awful.layout.suit.tile)

  screen.mypromptbox = awful.widget.prompt()

  screen.mytaglist = awful.widget.taglist {
    screen = screen,
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

  screen.mywibox = awful.wibar({
    position = "top",
    width = screen.geometry.width - dpi(8),
    height = dpi(35),
    screen = screen,
    stretch = false,
    margins = dpi(10)
  })
  screen.mywibox.y = dpi(4)

  screen.mywibox:setup {
    right = dpi(36),
    left = dpi(16),
    layout = wibox.container.margin,
    {
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        { layout = wibox.layout.fixed.horizontal, screen.mytaglist, screen.mypromptbox },
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
