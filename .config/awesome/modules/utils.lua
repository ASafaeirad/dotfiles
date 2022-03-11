local awful = require("awful")
local debug = require("gears.debug")
local naughty = require("naughty")

local module = {}
function module.focus_next()
    awful.client.focus.byidx(1)
end

function module.focus_prev()
    awful.client.focus.byidx(-1)
end

function module.swap_next()
    awful.client.swap.byidx(1)
end

function module.swap_prev()
    awful.client.swap.byidx(-1)
end

function module.screen_next()
    awful.screen.focus_relative(1)
end

function module.screen_prev()
    awful.screen.focus_relative(-1)
end

function module.open_terminal()
    awful.spawn(terminal)
end

function module.inc_width()
    awful.tag.incmwfact(0.05)
end

function module.dec_width()
    awful.tag.incmwfact(-0.05)
end

function module.inc_client_width(c)
    c:relative_move(0, 0, 20, 0)
end

function module.dec_client_width(c)
    c:relative_move(0, 0, -20, 0)
end

function module.inc_client_height(c)
    c:relative_move(0, 0, 0, 20)
end

function module.dec_client_height(c)
    c:relative_move(0, 0, 0, -20)
end

function module.center(c)
    awful.placement.centered(c)
end

function module.minimize(c)
    c.minimized = true
end

function module.inc_master_width()
    awful.tag.incnmaster(1, nil, true)
end

function module.dec_master_width()
    awful.tag.incnmaster(-1, nil, true)
end

function module.kill(c)
    c:kill()
end

function module.toggle_maximize(c)
    c.maximized = not c.maximized
    c:raise()
end

function module.move_master(c)
    c:swap(awful.client.getmaster())
end

function module.move_screen(c)
    c:move_to_screen()
end

function module.toggle_keep_top(c)
    c.ontop = not c.ontop
end

function module.dmenu()
    awful.spawn('sdmenu -l 100 -h 25 -w 300')
end

function module.go_back()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end

function module.restore()
    local tag = awful.tag.selected()
    for i=1, #tag:clients() do
        local c = tag:clients()[i]
        naughty.notify({ title = "Test Title", text = tostring(c.name), })
        c.minimized=false
        c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
end

function module.run_lua()
    awful.prompt.run {
        prompt = "Run Lua code: ",
        textbox = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
end

function module.toggle_fullscreen(c)
    c.fullscreen = not c.fullscreen
    c:raise()
end

function module.is_empty(t)
    for _, c in t:clients() do
        return false
    end
    return true
end

function module.toggle_fly()
    for _, c in ipairs(client.get()) do
        local is_fly = awful.rules.match(c, {
            instance = "flyterm"
        })

        if not is_fly then
            goto continue
        end


        local t = awful.screen.focused().selected_tag.index
        local fly_t = c.first_tag.index

        if fly_t ~= t or c.minimized then
            c.minimized = false
            client.focus = c
            c:raise()
        else
            c.minimized = true
        end

        c:move_to_tag(awful.tag.selected())
        c.ontop = true
        ::continue::
    end
end

function module.set_wallpaper(s)
    awful.spawn('nitrogen --restore', false)
end

function module.darker(color_value, darker_n)
    local result = "#"
    for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
        local bg_numeric_value = tonumber("0x"..s) - darker_n
        if bg_numeric_value < 0 then bg_numeric_value = 0 end
        if bg_numeric_value > 255 then bg_numeric_value = 255 end
        result = result .. string.format("%2.2x", bg_numeric_value)
    end
    return result
end

return module
