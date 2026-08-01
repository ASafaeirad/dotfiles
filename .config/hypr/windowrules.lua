-- Window rules. (was windowrules.conf)
-- Rules are evaluated top to bottom, so order matters.

hl.window_rule({ match = { class = "^([Bb]rave-browser|[Ff]irefox|[Cc]hromium|[Ff]irefox Beta)$" }, workspace = "2" })
hl.window_rule({ match = { class = "^([Cc]ode|[Cc]ursor|dev\\.zed\\.Zed)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^([Ss]lack)$" }, workspace = "7" })
hl.window_rule({ match = { class = "^([Ss]potify)$" }, workspace = "8" })
hl.window_rule({ match = { class = "^(org\\.telegram\\.desktop|TelegramDesktop)$" }, workspace = "9" })
hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(org\\.quickshell)$", title = "^(illogical-impulse Settings)$" }, float = true, size = { 1100, 1000 }, center = true })
hl.window_rule({ match = { class = "^(zenity)$" }, float = true, size = { 640, 720 }, center = true })
hl.window_rule({ match = { class = "^(Gpick|Gcolor3|xcolor)$" }, float = true })
hl.window_rule({ match = { title = "^(Open File|Save File)$" }, float = true, max_size = { 1000, 700 }, center = true, })
hl.window_rule({ match = { title = "^(branchdialog|Picture-in-Picture|Picture in picture)$" }, float = true })
hl.window_rule({ match = { class = "^([Zz]athura)$" }, float = true, fullscreen = true })

hl.window_rule({
    match    = { class = "^(xdg-desktop-portal-gtk|org\\.freedesktop\\.impl\\.portal\\.desktop\\.gtk)$" },
    float    = true,
    max_size = { 1000, 700 },
    center   = true,
})

hl.window_rule({
    match = { class = "^([Cc]hromium)$", title = "^(Meet)( -)?(.*)$" },
    float = true,
    size  = { 480, 270 },
    move  = { "monitor_w-window_w-20", "monitor_h-window_h-20" },
})

hl.window_rule({
    match        = { class = "^(flyterm)$" },
    float        = true,
    size         = { 700, 500 },
    center       = true,
    border_color = "rgb(000000)",
    workspace    = "special:term",
})
