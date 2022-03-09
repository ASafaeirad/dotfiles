local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local sutils = loadrc('utils')

require("awful.hotkeys_popup.keys")

local my_awesome_menu = {
  {"hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
  {"manual", terminal .. " -e man awesome"}, {"edit config", editor_cmd .. " " .. awesome.conffile},
  {"restart", awesome.restart}, {"quit", function() awesome.quit() end}
}

menubar.utils.terminal = terminal

-- {{{ Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(awful.button({}, 1, function(t)
    t:view_only()
end), awful.button({}, 3, awful.tag.viewtoggle), awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
end), awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
end))

local tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
    if c == client.focus then
        c.minimized = true
    else
        c:emit_signal("request::activate", "tasklist", {
            raise = true
        })
    end
end), awful.button({}, 3, function()
    awful.menu.client_list({
        theme = {
            width = 250
        }
    })
end), awful.button({}, 4, focus_next), awful.button({}, 5, focus_prev))

local date = wibox.widget.textclock(" %a %b %d ")
local time = wibox.widget.textclock("%H:%M", 10)

local tray = wibox.widget.systray()
tray:set_base_size(12)

function initMenu(s)
    sutils.set_wallpaper(s)
    s.padding = {
        top = dpi(4)
    }
    awful.tag({"S", "W", "C", "F", "M", "V", "S", "D", "T"}, s, awful.layout.suit.tile)

    s.mypromptbox = awful.widget.prompt()

    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            id = 'text_role',
                            widget = wibox.widget.textbox
                        },
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

    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
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

    s.mywibox:setup{
        right = dpi(36),
        left = dpi(16),
        layout = wibox.container.margin,
        {
            layout = wibox.layout.stack,
            {
                layout = wibox.layout.align.horizontal,
                {
                    layout = wibox.layout.fixed.horizontal,
                    s.mytaglist,
                    s.mypromptbox
                },
                nil,
                {
                    layout = wibox.layout.fixed.horizontal,
                    spacing = dpi(8),
                    awful.widget.keyboardlayout(),
                    date,
                    {
                        tray,
                        valign = "center",
                        halign = "center",
                        layout = wibox.container.place
                    }
                }
            },
            {
                time,
                valign = "center",
                halign = "center",
                layout = wibox.container.place
            }
        }
    }
end

