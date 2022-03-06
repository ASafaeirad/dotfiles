local awful = require("awful")

local sutils = {}
function sutils.focus_next()
    awful.client.focus.byidx(1)
end

function sutils.focus_prev()
    awful.client.focus.byidx(-1)
end

function sutils.swap_next()
    awful.client.swap.byidx(1)
end

function sutils.swap_prev()
    awful.client.swap.byidx(-1)
end

function sutils.screen_next()
    awful.screen.focus_relative(1)
end

function sutils.screen_prev()
    awful.screen.focus_relative(-1)
end

function sutils.open_terminal()
    awful.spawn(terminal)
end

function sutils.inc_width()
    awful.tag.incmwfact(0.05)
end

function sutils.dec_width()
    awful.tag.incmwfact(-0.05)
end

function sutils.minimize(c)
    c.minimized = true
end

function sutils.inc_master_width()
    awful.tag.incnmaster(1, nil, true)
end

function sutils.dec_master_width()
    awful.tag.incnmaster(1, nil, true)
end

function sutils.kill(c)
    c:kill()
end

function sutils.toggle_maximize(c)
    c.maximized = not c.maximized
    c:raise()
end

function sutils.move_master(c)
    c:swap(awful.client.getmaster())
end

function sutils.move_screen(c)
    c:move_to_screen()
end

function sutils.toggle_keep_top(c)
    c.ontop = not c.ontop
end

function sutils.dmenu()
    awful.spawn('sdmenu -l 100 -h 25 -w 300')
end

function sutils.go_back()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end

function sutils.restore()
    local c = awful.client.restore()
    if c then
        c:emit_signal("request::activate", "key.unminimize", {
            raise = true
        })
    end
end

function sutils.run_lua()
    awful.prompt.run {
        prompt = "Run Lua code: ",
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
end

function sutils.toggle_fullscreen(c)
    c.fullscreen = not c.fullscreen
    c:raise()
end

return sutils
