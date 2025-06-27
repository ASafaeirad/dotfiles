local awful = require("awful")
require("awful.autofocus")

client.connect_signal("manage", function(c)
  if c.floating then
    awful.placement.centered(c)
  end
  if not awesome.startup then
    awful.client.setslave(c)
  end
  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    awful.placement.no_offscreen(c)
  end
end)
