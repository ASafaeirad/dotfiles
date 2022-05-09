local awful   = require("awful")
local gears   = require("gears")
local naughty = require("naughty")
local utils   = require("modules.utils")
local volume  = require("volume-widget")

-- local volume = Volume:new({})
local keys = {}
local modkey = "Mod4"

keys.global_keys = gears.table.join(
    awful.key({modkey}, "BackSpace", awful.tag.history.restore),
    awful.key({modkey}, "u",         awful.client.urgent.jumpto),
    awful.key({modkey}, "Tab",       utils.go_back),
    awful.key({ modkey, "Shift" }, ";", function () naughty.notify({ title = "Test Title", text = "Test Notification", }) end),
    awful.key({}, "XF86AudioMute", function() volume:update() end),
    awful.key({}, "XF86AudioRaiseVolume", function() volume:update() end),
    awful.key({}, "XF86AudioLowerVolume", function() volume:update() end),

    awful.key({modkey}, "l",         utils.focus_next),
    awful.key({modkey}, "h",         utils.focus_prev),
    awful.key({modkey, "Shift", "Shift"}, "j", utils.screen_next),
    awful.key({modkey, "Shift", "Shift"}, "k", utils.screen_prev),

    awful.key({modkey, "Shift"}, "l", utils.inc_width),
    awful.key({modkey, "Shift"}, "h", utils.dec_width),
    awful.key({modkey, "Control"}, "l", utils.swap_next),
    awful.key({modkey, "Control"}, "h", utils.swap_prev),

    awful.key({modkey, "Control"}, "r", awesome.restart),

    awful.key({modkey}, "t", utils.toggle_fly),
    awful.key({modkey, "Shift"}, "t",     function() awful.spawn("alacritty --class \"flyterm\" -e tmux attach") end),

    awful.key({},       "Print",          function() awful.spawn("flameshot full -c") end),
    awful.key({modkey}, "Print",          function() awful.spawn("flameshot full -p \"$XDG_PICTURES_DIR/screenshots/\"") end),
    awful.key({modkey, "Shift"}, "Print", function() awful.spawn("flameshot gui") end),
    awful.key({modkey}, "Return",         function() awful.spawn(terminal) end),
    -- awful.key({modkey}, "d",              function() awful.spawn('sdmenu -l 100 -h 25 -w 300') end),
    awful.key({modkey}, "d",              function() awful.spawn('rofi -show drun') end),
    awful.key({modkey, "Control"}, "x",   function() awful.spawn("xkill") end),
    awful.key({modkey, "Control"}, "m",   function() awful.spawn("pavucontrol") end),
    awful.key({modkey, "Shift"},   "s",   function() awful.spawn("rofi -show power-menu -modi power-menu:rofi-power-menu") end),
    awful.key({modkey},            "v",   function() awful.spawn("copyq show") end),

    awful.key({modkey}, "F2",             function() awful.spawn("brave") end),
    awful.key({modkey}, "F3",             function() awful.spawn("code") end),
    awful.key({modkey}, "F4",             function() awful.spawn(terminal .. " -e ranger") end),
    awful.key({modkey}, "F5",             function() awful.spawn(terminal .. " -e mus") end),

    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("pactl set-sink-volume 0 +5%", false) end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("pactl set-sink-volume 0 -5%", false) end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("pactl set-sink-mute 0 toggle", false) end),

    awful.key({modkey, "Ctrl"}, "p", function () awful.util.spawn("/home/skill/.local/bin/automation/register") end),
    awful.key({modkey, "Ctrl", "Shift"}, "p", function () awful.util.spawn("pkill register") end),
    awful.key({modkey, "Shift"}, "e",         function () awful.util.spawn("egmenu") end)
)

for i = 1, 9 do
    keys.global_keys = gears.table.join(keys.global_keys,
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
            if tag then
                client.focus:move_to_tag(tag)
                tag:view_only()
            end

        end
    end),

    awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then client.focus:toggle_tag(tag) end
        end
    end))
end


keys.client_keys = gears.table.join(
    awful.key({modkey},        "space",       awful.client.floating.toggle),
    awful.key({modkey},            "f",       utils.toggle_fullscreen),
    awful.key({modkey, "Shift"},   "f",       utils.toggle_maximize),
    awful.key({modkey, "Shift"},   "q",       utils.kill),
    awful.key({modkey, "Control"}, "Return",  utils.move_master),
    awful.key({modkey},            "m",       utils.move_screen),
    awful.key({modkey, "Shift"},   "m",       function () awful.screen.focus_relative(1) end),
    awful.key({modkey},            "n",       utils.minimize),
    awful.key({modkey, "Shift"},   "n",       utils.restore),
    awful.key({modkey, "Ctrl", "Shift"}, "l", utils.inc_client_width),
    awful.key({modkey, "Ctrl", "Shift"}, "h", utils.dec_client_width),
    awful.key({modkey, "Ctrl", "Shift"}, "j", utils.inc_client_height),
    awful.key({modkey, "Ctrl", "Shift"}, "k", utils.dec_client_height),
    awful.key({modkey, "Shift"}, "c",         utils.center)
)

keys.client_buttons = gears.table.join(
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

return keys;
