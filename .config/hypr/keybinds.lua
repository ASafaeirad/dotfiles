local mainMod = "SUPER"
local hyper   = mainMod .. " + SHIFT + CTRL + ALT"

-- ---- Session / WM control ----
hl.bind(mainMod .. " + SHIFT + q", hl.dsp.window.close())
hl.bind(hyper .. " + q", hl.dsp.window.close())

hl.bind(mainMod .. " + h", hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-or-unfullscreen l"))
hl.bind(mainMod .. " + j", hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-or-unfullscreen d"))
hl.bind(mainMod .. " + k", hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-or-unfullscreen u"))
hl.bind(mainMod .. " + l", hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-or-unfullscreen r"))

hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"))

hl.bind(mainMod .. " + CTRL + SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + SHIFT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind(mainMod .. " + CTRL + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
hl.bind(mainMod .. " + CTRL + SHIFT + c", hl.dsp.window.center())

hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + SHIFT + f", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + CTRL + SHIFT + f", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))
hl.bind(mainMod .. " + Space", hl.dsp.layout("orientationnext")) -- rotate master orientation

hl.bind(mainMod .. " + m", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + m", hl.dsp.window.move({ monitor = "+1" }))

-- =========================================================================
-- Workspaces
-- Use r~N / r±N so Super+N always targets the Nth workspace on the *focused*
-- monitor. Absolute IDs (1..10) live on HDMI with split-monitor-workspaces, so
-- falling back to them after Super+M incorrectly jumps focus back there.
-- =========================================================================
for i = 1, 10 do
    local key = tostring(i % 10) -- workspace 10 sits on key 0
    local ws  = "r~" .. i

    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = ws, follow = false }))
end

hl.bind(mainMod .. " + Backspace", hl.dsp.focus({ workspace = "previous_per_monitor" }))
hl.bind(mainMod .. " + SHIFT + Backspace", hl.dsp.window.move({ workspace = "previous_per_monitor" }))
hl.bind(mainMod .. " + v", hl.dsp.exec_cmd("qs -c skill ipc call search clipboardToggle"))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + t", hl.dsp.exec_cmd("toggle-flyterm"))

-- ---- Launchers ----
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("chromium"))
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("pcmanfm"))
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("alacritty -e mus"))
hl.bind(mainMod .. " + F9", hl.dsp.exec_cmd("telegram-desktop"))
hl.bind(mainMod .. " + n", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-notion"))

-- ---- Shell (quickshell) ----
hl.bind(mainMod .. " + ALT + g", hl.dsp.exec_cmd("qs -c skill ipc call overlay toggle"))
hl.bind(mainMod .. " + ALT + k", hl.dsp.exec_cmd("qs -c skill ipc call keyDisplay toggle"))
hl.bind(mainMod .. " + ALT + z", hl.dsp.exec_cmd("qs -c skill ipc call screenZoom toggle"))
hl.bind(mainMod .. " + SHIFT + t", hl.dsp.exec_cmd("flyterm"))

hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.exec_cmd("qs -c skill ipc call search toggle"))
hl.bind(hyper .. " + Space", hl.dsp.exec_cmd("qs -c skill ipc call search toggle"))

-- ---- Menus ----
local menus = {
    d = "s-menu",
    a = "auto-menu",
    b = "changelog-menu",
    p = "qs -c skill ipc call pass toggle",
    g = "github-menu",
    c = "c-menu",
    o = "open-menu",
    s = "power-menu",
    y = "youtube-menu",
    i = "screen-menu",
    x = "dev-menu",
}

for key, cmd in pairs(menus) do
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.exec_cmd(cmd))
    hl.bind(hyper .. " + " .. key, hl.dsp.exec_cmd(cmd))
end

local tools = {
    x = "hyprctl kill",
    m = "pavucontrol",
    c = "hyprpicker -a",
    b = "book",
    n = "notion-app",
    q = "qbar",
    s = "ocr",
    t = "ocr en",
    p = "qs -c skill ipc call region capture",
    comma = "qs -p ~/.config/quickshell/skill/settings.qml",
    period = "qs -c skill ipc call sidebarRight toggle",
}

for key, cmd in pairs(tools) do
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.exec_cmd(cmd))
end

-- ---- Media / hardware keys ----
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("qs -c skill ipc call brightness increment"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("qs -c skill ipc call brightness decrement"), { repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))

-- ---- Mouse ----
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse:274", hl.dsp.exec_cmd("qs -c skill ipc call screenZoom toggle"))
