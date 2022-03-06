-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Module loader
function loadrc(name, mod)
   local success
   local result

  -- Which file? In rc/ or in lib/?
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

local sutils = loadrc("utils")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

local modkey     = "Mod4"
local terminal   = os.getenv("TERMINAL") or "alacritty"
local editor     = os.getenv("EDITOR") or "nano"
local editor_cmd = terminal .. " -e " .. editor

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.spiral.dwindle
}

-- {{{ Menu
-- Create a launcher widget and a main menu
local my_awesome_menu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}

local my_main_menu = awful.menu({
    items = {
        { "awesome", my_awesome_menu },
        { "open terminal", terminal }
    }
})

local my_launcher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = my_main_menu
})

menubar.utils.terminal = terminal

-- {{{ Wibar

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({modkey}, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({modkey}, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({
            theme = { width = 250 }
        })
    end),
    awful.button({}, 4, focus_next),
    awful.button({}, 5, focus_prev)
)

local date = wibox.widget.textclock(" %a %b %d ")
local time = wibox.widget.textclock("%H:%M",10)

local function set_wallpaper(s)
    awful.spawn('nitrogen --restore', false)
end

local tray = wibox.widget.systray()
tray:set_base_size(12)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    s.padding = { top = dpi(4) }
    awful.tag({"sh", "web", "dev", "file", "music", "video", "slack", "discord", "tel"}, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
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
        },
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", width = s.geometry.width - dpi(8), height = dpi(35), screen = s, stretch = false, margins= dpi(10) })
    s.mywibox.y = dpi(4)
    -- Add widgets to the wibox

    -- s.mywibox:setup{
    --     layout = wibox.layout.align.horizontal,
    --     {
    --         layout = wibox.layout.fixed.horizontal,
    --         s.mytaglist,
    --         s.mypromptbox
    --     },
    --     s.mytasklist,
    --     {
    --         layout = wibox.layout.fixed.horizontal,
    --         awful.widget.keyboardlayout(),
    --         time,
    --         date,
    --         wibox.widget.systray()
    --     }
    -- }

    s.mywibox:setup {
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
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() my_main_menu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext), awful.button({}, 5, awful.tag.viewprev))
)
-- }}}

-- {{{ Key bindings

global_keys = gears.table.join(
    awful.key({modkey}, "Left",      awful.tag.viewprev),
    awful.key({modkey}, "Right",     awful.tag.viewnext),
    awful.key({modkey}, "BackSpace", awful.tag.history.restore),
    awful.key({modkey}, "u",         awful.client.urgent.jumpto),
    awful.key({modkey}, "Tab",       sutils.go_back),
    awful.key({modkey}, "l",         sutils.focus_next),
    awful.key({modkey}, "h",         sutils.focus_prev),

    awful.key({modkey, "Shift"}, "l", sutils.swap_next),
    awful.key({modkey, "Shift"}, "h", sutils.swap_prev),

    awful.key({modkey, "Control"}, "r", awesome.restart),
    awful.key({modkey, "Control"}, "l", sutils.inc_width),
    awful.key({modkey, "Control"}, "h", sutils.dec_width),

    awful.key({modkey, "Control", "Shift"}, "j", sutils.screen_next),
    awful.key({modkey, "Control", "Shift"}, "k", sutils.screen_prev),

    awful.key({},       "Print",          function() awful.spawn("flameshot full -c") end),
    awful.key({modkey}, "Print",          function() awful.spawn("flameshot full -p \"$XDG_PICTURES_DIR/screenshots/\"") end),
    awful.key({modkey, "Shift"}, "Print", function() awful.spawn("flameshot gui") end),
    awful.key({modkey}, "Return",         function() awful.spawn(terminal) end),
    awful.key({modkey}, "d",              function() awful.spawn('sdmenu -l 100 -h 25 -w 300') end),
    awful.key({modkey, "Control"}, "x",   function() awful.spawn("xkill") end),
    awful.key({modkey, "Control"}, "m",   function() awful.spawn("pavucontrol") end),
    awful.key({modkey, "Shift"},   "s",   function() awful.spawn("rofi -show power-menu -modi power-menu:rofi-power-menu") end),
    awful.key({modkey}, "F2",             function() awful.spawn("brave") end),
    awful.key({modkey}, "F3",             function() awful.spawn("code") end),
    awful.key({modkey}, "F4",             function() awful.spawn(terminal .. " -e ranger") end),

    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("pactl set-sink-volume 0 +5%", false) end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("pactl set-sink-volume 0 -5%", false) end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("pactl set-sink-mute 0 toggle", false) end)
)

client_keys = gears.table.join(
    awful.key({modkey},            "space",  awful.client.floating.toggle),
    awful.key({modkey},            "f",      sutils.toggle_fullscreen),
    awful.key({modkey, "Shift"},   "q",      sutils.kill),
    awful.key({modkey, "Control"}, "Return", sutils.move_master),
    awful.key({modkey},            "m",      sutils.move_screen),
    awful.key({modkey},            "t",      sutils.toggle_keep_top),
    awful.key({modkey},            "n",      sutils.minimize),
    awful.key({modkey, "Shift"},   "n",      sutils.restore),
    awful.key({modkey},            "m",      sutils.toggle_maximize)
)

for i = 1, 9 do
    global_keys = gears.table.join(global_keys,
    awful.key({modkey}, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then tag:view_only() end
    end),

    awful.key({modkey, "Control"}, "#" .. i + 9, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then awful.tag.viewtoggle(tag) end
    end),

    awful.key({modkey, "Shift"}, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then client.focus:move_to_tag(tag) end
        end
    end),

    awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then client.focus:toggle_tag(tag) end
        end
    end))
end

client_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({modkey}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({modkey}, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

root.keys(global_keys)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    {
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            keys = client_keys,
            buttons = client_buttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    {
        rule_any = {
            instance = {"copyq", "pinentry"},
            class = {"Arandr", "Blueman-manager", "Gpick", "Kruler", "MessageWin", "Sxiv", "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"},
            name = {"Event Tester"},
            role = {"pop-up"}
        },
        properties = { floating = true }
    },
    { rule = { class = "Brave-browser" }, properties = { tag = "web" } },
    { rule = { class = "Code" }, properties = { tag = "dev" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
