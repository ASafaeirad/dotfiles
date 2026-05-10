local wibox = require("wibox")
local gears = require("gears")
local widget_tooltip = require("modules.widget_tooltip")
local beautiful = require("beautiful")
local spawn = require("awful.spawn")

local volume = {}
volume.__index = volume

-- One shell round-trip: volume line + mute line (was two blocking pactl runs per update).
local PACTL_FETCH = "pactl get-sink-volume @DEFAULT_SINK@; pactl get-sink-mute @DEFAULT_SINK@"

local function parse_pactl_state(stdout)
  if not stdout or stdout == "" then
    return 0, false
  end
  local pct = string.match(stdout, "(%d+)%%")
  local muted = string.match(stdout, "Mute:%s*(%a+)") == "yes"
  return tonumber(pct) or 0, muted
end

local function apply_state(self, value, is_muted)
  self._cached_percent = value
  self._cached_muted = is_muted
  if is_muted then
    self.widget.colors = { self.mute_color }
  else
    self.widget.colors = { self.color }
  end
  self.widget.value = value
end

-- Drop in-flight pactl reads so they cannot paint stale state after a local change.
local function invalidate_pending_fetch(self)
  self._fetch_gen = self._fetch_gen + 1
end

local function schedule_refresh_after_pactl(self, argv)
  spawn.easy_async(argv, function()
    self:update()
  end)
end

function volume:new(args)
  local obj = setmetatable({}, volume)
  obj.step = args.step or 5
  obj.device = args.device or "Master"
  obj.color = args.color or "white"
  obj.mute_color = args.mute_color or "red"
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

  obj.tooltip = widget_tooltip.new({
    timer_function = function()
      return obj:update_tooltip()
    end,
  })
  obj.tooltip:add_to_object(obj.widget)

  obj._subscribe_debounce = gears.timer({ timeout = 0.05, single_shot = true })
  obj._subscribe_debounce:connect_signal("timeout", function()
    obj:update()
  end)
  spawn.with_line_callback({ "pactl", "subscribe" }, {
    stdout = function(line)
      if string.find(line, "sink", 1, true) then
        obj._subscribe_debounce:again()
      end
    end,
  })

  -- Sync once at startup before subscribe events stream in.
  do
    local prog = io.popen(PACTL_FETCH)
    if prog then
      local stdout = prog:read("*all") or ""
      prog:close()
      apply_state(obj, parse_pactl_state(stdout))
    end
  end

  obj:update()

  return obj
end

function volume:update_tooltip()
  local p = self._cached_percent
  if p == nil then
    return "…"
  end
  return string.format("%d%% volume", p)
end

function volume:update()
  self._fetch_gen = self._fetch_gen + 1
  local gen = self._fetch_gen
  spawn.easy_async_with_shell(PACTL_FETCH, function(stdout)
    if gen ~= self._fetch_gen then
      return
    end
    apply_state(self, parse_pactl_state(stdout))
  end)
end

function volume:up()
  invalidate_pending_fetch(self)
  local cur = self._cached_percent or 0
  local cap = self.widget:get_max_value()
  apply_state(self, math.min(cap, cur + self.step), self._cached_muted)
  schedule_refresh_after_pactl(self, {
    "pactl",
    "set-sink-volume",
    "@DEFAULT_SINK@",
    "+" .. self.step .. "%",
  })
end

function volume:down()
  invalidate_pending_fetch(self)
  local cur = self._cached_percent or 0
  apply_state(self, math.max(0, cur - self.step), self._cached_muted)
  schedule_refresh_after_pactl(self, {
    "pactl",
    "set-sink-volume",
    "@DEFAULT_SINK@",
    "-" .. self.step .. "%",
  })
end

function volume:mute()
  invalidate_pending_fetch(self)
  local muted = not (self._cached_muted or false)
  apply_state(self, self._cached_percent or 0, muted)
  schedule_refresh_after_pactl(self, { "pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle" })
end

return volume:new({
  step = 10,
  mute_color = beautiful.error,
  color = beautiful.fg_normal,
})
