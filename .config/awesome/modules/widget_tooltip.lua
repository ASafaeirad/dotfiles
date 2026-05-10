local awful = require("awful")
local beautiful = require("beautiful")
local gtable = require("gears.table")
local dpi = beautiful.xresources.apply_dpi

local M = {}

M.defaults = {
  delay_show = 0,
  margin_leftright = dpi(12),
  margin_topbottom = dpi(8),
  bg = beautiful.bg_alt,
  fg = beautiful.fg_normal,
  font = beautiful.font,
}

function M.new(args)
  local opts = gtable.clone(M.defaults)
  gtable.crush(opts, args or {})
  return awful.tooltip(opts)
end

return M
