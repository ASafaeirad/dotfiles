local awful = require("awful")
local gears = require("gears")
local sutils = loadrc("utils")

local keys = {}
local modkey = "Mod4"

keys.global_keys = gears.table.join(
    awful.key({modkey}, "Left",      awful.tag.viewprev),
    awful.key({modkey}, "Right",     awful.tag.viewnext),
    awful.key({modkey}, "BackSpace", awful.tag.history.restore),
    awful.key({modkey}, "u",         awful.client.urgent.jumpto),
    awful.key({modkey}, "Tab",       sutils.go_back),

    awful.key({modkey}, "l",         sutils.focus_next),
    awful.key({modkey}, "h",         sutils.focus_prev),
    awful.key({modkey, "Shift", "Shift"}, "j", sutils.screen_next),
    awful.key({modkey, "Shift", "Shift"}, "k", sutils.screen_prev),

    awful.key({modkey, "Shift"}, "l", sutils.inc_width),
    awful.key({modkey, "Shift"}, "h", sutils.dec_width),
    awful.key({modkey, "Control"}, "l", sutils.swap_next),
    awful.key({modkey, "Control"}, "h", sutils.swap_prev),

    awful.key({modkey, "Control"}, "r", awesome.restart),

    awful.key({modkey}, "t", sutils.toggle_fly),
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

    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("pactl set-sink-volume 0 +5%", false) end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("pactl set-sink-volume 0 -5%", false) end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("pactl set-sink-mute 0 toggle", false) end)
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


keys.client_keys = gears.table.join(
    awful.key({modkey},        "space",      awful.client.floating.toggle),
    awful.key({modkey},            "f",      sutils.toggle_fullscreen),
    awful.key({modkey, "Shift"},   "q",      sutils.kill),
    awful.key({modkey, "Control"}, "Return", sutils.move_master),
    awful.key({modkey},            "m",      sutils.move_screen),
    -- awful.key({modkey},            "t",      sutils.toggle_keep_top),
    awful.key({modkey},            "n",      sutils.minimize),
    awful.key({modkey, "Shift"},   "n",      sutils.restore),
    awful.key({modkey},            "o",      sutils.toggle_maximize),
    awful.key({modkey, "Ctrl", "Shift"},            "l",      sutils.inc_client_width),
    awful.key({modkey, "Ctrl", "Shift"},            "h",      sutils.dec_client_width),
    awful.key({modkey, "Ctrl", "Shift"},            "j",      sutils.inc_client_height),
    awful.key({modkey, "Ctrl", "Shift"},            "k",      sutils.dec_client_height),
    awful.key({modkey, "Shift"}, "c",      sutils.center)
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
