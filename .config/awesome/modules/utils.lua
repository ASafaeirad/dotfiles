local awful = require("awful")

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

function module.dmenu()
  awful.spawn('sdmenu -l 100 -h 25 -w 300')
end

function module.restore()
  local c = awful.client.restore(s)
  if c then
    client.focus = c
    c:raise()
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

function module.set_wallpaper()
  awful.spawn('nitrogen --restore', false)
end

function module.focus_next_screen()
  awful.screen.focus_relative(1)
end

function module.get_client_by_selector(selector)
  for _, c in ipairs(client.get()) do
    if awful.rules.match(c, selector) then
      return c
    end
  end
end

function module.toggle_float(selector)
  local c = module.get_client_by_selector(selector)
  if not c then
    return
  end

  local current_tag = awful.screen.focused().selected_tag.index
  local client_tag = c.first_tag.index
  local is_current_tag = client_tag == current_tag

  c.floating = true
  c.ontop = true

  if not is_current_tag then
    c:move_to_tag(awful.tag.selected())
  end

  if c.minimized then
    c.minimized = false
    client.focus = c
    c:raise()
  elseif is_current_tag then
    c.minimized = true
  end

  return c
end

return module;
