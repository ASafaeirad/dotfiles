local xresources = require("beautiful.xresources")
local xrdb = xresources.get_current_theme()

local module = {}

module.x       = "#FF0000"
module.accent  = xrdb.color11
module.error   = xrdb.color9
module.fg      = xrdb.foreground
module.bg      = xrdb.background
module.bg1     = "#323643"
module.mute    = xrdb.color8
module.success = xrdb.color10
module.muter   = "#000000"

return module
