local awful = require("awful")
local keys = require("modules.keys")

local rules = {{
    rule = {},
    properties = {
        focus = awful.client.focus.filter,
        raise = true,
        keys = keys.client_keys,
        buttons = keys.client_buttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
}, {
    rule_any = {
        instance = {"copyq", "pinentry"},
        class = {"Arandr", "Blueman-manager", "Gpick", "Kruler", "MessageWin", "Sxiv", "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer", "persepolis" },
        name = {"Event Tester"},
        role = {"pop-up"}
    },
    properties = {
        floating = true,
        placement = awful.placement.centered,
        size_hints = { max_height = 300, min_width = 200 }
    }
}, {
    rule = { instance = "flyterm" },
    properties = { floating = true },
    callback = function(c) c:geometry({ width = 600, height = 400 }) end
},
   { rule = { class = "Brave-browser" }, properties = { tag = tags[2] } },
   { rule = { class = "Code" }, properties = { tag = tags[3] } },
   { rule = { class = "TelegramDesktop" }, properties = { tag = tags[9] } }
}

return rules
