local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local widget_tooltip = require("modules.widget_tooltip")
local gdebug = require("gears.debug")

local keyboard = {}
keyboard.__index = keyboard

local COUNTRY_CODES = {
  ["ir"] = true,
  ["us"] = true,
}

local DISPLAY_NAMES = {
  us = "EN",
  ir = "IR",
}

-- Pattern table compiled once. Each entry parses one xkb group_names token shape.
local WORD_PAT = "([%w_]+)"
local SEC_PAT = "(%b())"
local IDX_PAT = ":(%d)"

local TOKEN_PATTERNS = {
  -- vendor/file(section):group_idx
  {
    "^" .. WORD_PAT .. "/" .. WORD_PAT .. SEC_PAT .. IDX_PAT .. "$",
    function(token, pattern)
      local vendor, file, section, group_idx = string.match(token, pattern)
      return vendor, file, section, group_idx
    end,
  },
  -- vendor/file(section)
  {
    "^" .. WORD_PAT .. "/" .. WORD_PAT .. SEC_PAT .. "$",
    function(token, pattern)
      local vendor, file, section = string.match(token, pattern)
      return vendor, file, section, 1
    end,
  },
  -- vendor/file:group_idx
  {
    "^" .. WORD_PAT .. "/" .. WORD_PAT .. IDX_PAT .. "$",
    function(token, pattern)
      local vendor, file, group_idx = string.match(token, pattern)
      return vendor, file, nil, group_idx
    end,
  },
  -- vendor/file
  {
    "^" .. WORD_PAT .. "/" .. WORD_PAT .. "$",
    function(token, pattern)
      local vendor, file = string.match(token, pattern)
      return vendor, file, nil, 1
    end,
  },
  -- file(section):group_idx
  {
    "^" .. WORD_PAT .. SEC_PAT .. IDX_PAT .. "$",
    function(token, pattern)
      local file, section, group_idx = string.match(token, pattern)
      return nil, file, section, group_idx
    end,
  },
  -- file(section)
  {
    "^" .. WORD_PAT .. SEC_PAT .. "$",
    function(token, pattern)
      local file, section = string.match(token, pattern)
      return nil, file, section, 1
    end,
  },
  -- file:group_idx
  {
    "^" .. WORD_PAT .. IDX_PAT .. "$",
    function(token, pattern)
      local file, group_idx = string.match(token, pattern)
      return nil, file, nil, group_idx
    end,
  },
  -- file
  {
    "^" .. WORD_PAT .. "$",
    function(token, pattern)
      local file = string.match(token, pattern)
      return nil, file, nil, 1
    end,
  },
}

local function parse_xkb_groups(group_names, country_codes)
  if group_names == nil then
    return nil
  end

  local tokens = {}
  string.gsub(group_names, "[^+]+", function(match)
    table.insert(tokens, match)
  end)

  local groups = {}
  for i = 1, #tokens do
    for _, entry in ipairs(TOKEN_PATTERNS) do
      local pattern, callback = entry[1], entry[2]
      local vendor, file, section, group_idx = callback(tokens[i], pattern)
      if file then
        if not country_codes[file] then
          break
        end
        if section then
          section = string.gsub(section, "%(([%w-_]+)%)", "%1")
        end
        table.insert(groups, {
          vendor = vendor,
          file = file,
          section = section,
          group_idx = tonumber(group_idx),
        })
        break
      end
    end
  end

  return groups
end

local function apply_state(self, layouts, groups, current_idx)
  self._cached_layouts = layouts
  self._cached_groups = groups
  self._cached_current = current_idx
  local name = layouts[current_idx + 1]
  self.widget:set_text(name and (" " .. name .. " ") or "")
end

function keyboard:new(args)
  local obj = setmetatable({}, keyboard)
  obj.country_codes = args.country_codes or COUNTRY_CODES
  obj.display_names = args.display_names or DISPLAY_NAMES

  obj.widget = wibox.widget({
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  obj.tooltip = widget_tooltip.new({
    timer_function = function()
      return obj:update_tooltip()
    end,
  })
  obj.tooltip:add_to_object(obj.widget)

  obj.widget:buttons(gears.table.join(awful.button({}, 1, function()
    obj:next_layout()
  end)))

  -- xkb signals are the native subscribe mechanism: map_changed when layouts
  -- are added/removed, group_changed when the active layout switches.
  awesome.connect_signal("xkb::map_changed", function()
    obj:update()
  end)
  awesome.connect_signal("xkb::group_changed", function()
    obj:update()
  end)

  obj:update()

  return obj
end

function keyboard:update_tooltip()
  local groups = self._cached_groups
  if not groups or not groups[1] then
    return "…"
  end
  local current = self._cached_current or 0
  local parts = {}
  for _, g in ipairs(groups) do
    local label = self:layout_name(g) or g.file
    if g.section then
      label = label .. " (" .. g.file .. "/" .. g.section .. ")"
    else
      label = label .. " (" .. g.file .. ")"
    end
    if g.group_idx == current + 1 then
      label = "› " .. label
    else
      label = "  " .. label
    end
    table.insert(parts, label)
  end
  return table.concat(parts, "\n")
end

function keyboard:layout_name(group)
  local name = group.file
  if group.section ~= nil then
    name = name .. "(" .. group.section .. ")"
  end
  return self.display_names[name]
end

function keyboard:set_layout(group_number)
  local layouts = self._cached_layouts or {}
  if group_number < 0 or group_number >= #layouts then
    return
  end
  awesome.xkb_set_layout_group(group_number)
end

function keyboard:next_layout()
  local layouts = self._cached_layouts or {}
  if #layouts <= 1 then
    return
  end
  local current = self._cached_current or 0
  self:set_layout((current + 1) % #layouts)
end

function keyboard:update()
  local groups = parse_xkb_groups(awesome.xkb_get_group_names(), self.country_codes)
  if groups == nil or groups[1] == nil then
    gdebug.print_error("Failed to get list of keyboard groups")
    return
  end
  if #groups == 1 then
    groups[1].group_idx = 1
  end
  local layouts = {}
  for _, v in ipairs(groups) do
    layouts[v.group_idx] = self:layout_name(v)
  end
  apply_state(self, layouts, groups, awesome.xkb_get_layout_group())
end

return keyboard:new({})
