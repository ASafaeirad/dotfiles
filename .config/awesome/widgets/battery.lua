local wibox = require("wibox")
local gears = require("gears")
local widget_tooltip = require("modules.widget_tooltip")
local beautiful = require("beautiful")
local naughty = require("naughty")
local spawn = require("awful.spawn")

local battery = {}
battery.__index = battery

local ACPI_GET = "acpi"

local function parse_acpi_state(stdout)
  if not stdout or stdout == "" then
    return 0, nil
  end
  local charge, status = 0, nil
  for line in stdout:gmatch("[^\r\n]+") do
    local cur_status, charge_str = string.match(line, ".+: ([%a%s]+), (%d?%d?%d)%%")
    if cur_status and charge_str then
      local cur_charge = tonumber(charge_str) or 0
      if cur_charge > charge then
        status = cur_status
        charge = cur_charge
      end
    end
  end
  return charge, status
end

local function pick_color(self, charge, status)
  if status == "Charging" then
    return self.charging_color
  elseif charge < 15 then
    return self.low_color
  elseif charge < 40 then
    return self.medium_color
  end
  return self.full_color
end

local function maybe_warn(self, charge, status)
  if not self.enable_warning then
    return
  end
  if status == "Charging" or charge >= 15 then
    return
  end
  if os.difftime(os.time(), self._last_warning) <= self.warning_throttle then
    return
  end
  self._last_warning = os.time()
  naughty.notify({
    preset = naughty.config.presets.critical,
    text = self.warning_text,
    title = self.warning_title,
    timeout = 25,
    hover_timeout = 0.5,
    position = self.warning_position,
    width = 300,
  })
end

local function apply_state(self, charge, status)
  self._cached_percent = charge
  self._cached_status = status
  self.widget.value = charge
  self.widget.colors = { pick_color(self, charge, status) }
  maybe_warn(self, charge, status)
end

-- Drop in-flight acpi reads so they cannot paint stale state after a power_supply event.
local function invalidate_pending_fetch(self)
  self._fetch_gen = self._fetch_gen + 1
end

function battery:new(args)
  local obj = setmetatable({}, battery)
  obj.full_color = args.full_color or beautiful.fg_normal
  obj.low_color = args.low_color or beautiful.error
  obj.medium_color = args.medium_color or beautiful.accent
  obj.charging_color = args.charging_color or beautiful.success
  obj.enable_warning = args.enable_warning ~= false
  obj.warning_title = args.warning_title or "Dying in ..."
  obj.warning_text = args.warning_text or "Battery is dying"
  obj.warning_position = args.warning_position or "bottom_right"
  obj.warning_throttle = args.warning_throttle or 300
  obj._fetch_gen = 0
  obj._last_warning = 0

  obj.widget = wibox.widget({
    max_value = 100,
    thickness = 2,
    rounded_edge = true,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = 12,
    forced_width = 12,
    colors = { obj.full_color },
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
  spawn.with_line_callback({
    "udevadm",
    "monitor",
    "--property",
    "--subsystem-match=power_supply",
  }, {
    stdout = function(line)
      if string.find(line, "power_supply", 1, true) then
        obj._subscribe_debounce:again()
      end
    end,
  })

  -- Sync once at startup before subscribe events stream in.
  do
    local prog = io.popen(ACPI_GET)
    if prog then
      local stdout = prog:read("*all") or ""
      prog:close()
      apply_state(obj, parse_acpi_state(stdout))
    end
  end

  obj:update()

  return obj
end

function battery:update_tooltip()
  local p = self._cached_percent
  if p == nil then
    return "…"
  end
  local s = self._cached_status
  if s and s ~= "" then
    return string.format("%d%% (%s)", p, s)
  end
  return string.format("%d%% battery", p)
end

function battery:update()
  invalidate_pending_fetch(self)
  local gen = self._fetch_gen
  spawn.easy_async(ACPI_GET, function(stdout)
    if gen ~= self._fetch_gen then
      return
    end
    apply_state(self, parse_acpi_state(stdout))
  end)
end

return battery:new({})
