local wibox = require('wibox')
local beautiful = require("beautiful")

return wibox.widget.textclock("<span font='" .. beautiful.font .. "'> %a %b %d</span>")
