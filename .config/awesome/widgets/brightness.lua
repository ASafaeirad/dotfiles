local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local spawn = require("awful.spawn")

local brightness = {}
brightness.__index = brightness

local LIGHT_GET = "light -G"

local function parse_light_state(stdout)
  if not stdout or stdout == "" then
    return 0
  end
  local n = tonumber((stdout:gsub("%s+", "")))
  if not n then
    return 0
  end
  return math.floor(n + 0.5)
end

local function apply_state(self, value)
  self._cached_percent = value
  self.widget.value = value
end

-- Drop in-flight light reads so they cannot paint stale state after a local change.
local function invalidate_pending_fetch(self)
  self._fetch_gen = self._fetch_gen + 1
end

local function schedule_refresh_after_light(self, argv)
  spawn.easy_async(argv, function()
    self:update()
  end)
end

function brightness:new(args)
  local obj = setmetatable({}, brightness)
  obj.step = args.step or 5
  obj.color = args.color or "white"
  obj._fetch_gen = 0

  obj.widget = wibox.widget({
    max_value = 100,
    thickness = 2,
    rounded_edge = true,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = 12,
    forced_width = 12,
    paddings = 8,
    colors = { obj.color },
    widget = wibox.container.arcchart,
  })

  obj.tooltip = awful.tooltip({
    delay_show = 0,
    timer_function = function()
      return obj:update_tooltip()
    end,
  })
  obj.tooltip:add_to_object(obj.widget)

  obj._subscribe_debounce = gears.timer({ timeout = 0.05, single_shot = true })
  obj._subscribe_debounce:connect_signal("timeout", function()
    obj:update()
  end)
  spawn.with_line_callback({
    "udevadm",
    "monitor",
    "--property",
    "--subsystem-match=backlight",
  }, {
    stdout = function(line)
      if string.find(line, "backlight", 1, true) then
        obj._subscribe_debounce:again()
      end
    end,
  })

  do
    local prog = io.popen(LIGHT_GET)
    if prog then
      local stdout = prog:read("*all") or ""
      prog:close()
      apply_state(obj, parse_light_state(stdout))
    end
  end

  obj:update()

  return obj
end

function brightness:update_tooltip()
  local p = self._cached_percent
  if p == nil then
    return "…"
  end
  return string.format("%d%% brightness", p)
end

function brightness:update()
  self._fetch_gen = self._fetch_gen + 1
  local gen = self._fetch_gen
  spawn.easy_async(LIGHT_GET, function(stdout)
    if gen ~= self._fetch_gen then
      return
    end
    apply_state(self, parse_light_state(stdout))
  end)
end

function brightness:up()
  invalidate_pending_fetch(self)
  local cur = self._cached_percent or 0
  local cap = self.widget:get_max_value()
  apply_state(self, math.min(cap, cur + self.step))
  schedule_refresh_after_light(self, { "light", "-A", tostring(self.step) })
end

function brightness:down()
  invalidate_pending_fetch(self)
  local cur = self._cached_percent or 0
  apply_state(self, math.max(0, cur - self.step))
  schedule_refresh_after_light(self, { "light", "-U", tostring(self.step) })
end

return brightness:new({
  step = 5,
  color = beautiful.accent,
})
