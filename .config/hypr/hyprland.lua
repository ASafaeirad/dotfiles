hl.monitor({ output = "", mode = "highres", position = "auto", scale = 1 })

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Kept as a literal `~`: the quickshell scripts consuming it do `eval echo`.
hl.env("ILLOGICAL_IMPULSE_VIRTUAL_ENV", "~/.local/state/quickshell/.venv")

-----------------
---- PLUGINS ----
-----------------

hl.plugin.load("/var/cache/hyprpm/skill/split-monitor-workspaces/split-monitor-workspaces.so")

hl.config({
    plugin = {
        split_monitor_workspaces = {
            count                        = 10,
            keep_focused                 = 0,
            enable_notifications         = 0,
            enable_persistent_workspaces = 1,
        },
    },
})

---------------
---- DEBUG ----
---------------

hl.config({
    debug = {
        disable_logs = false,
    },
})

-----------------
---- MODULES ----
-----------------

-- matugen-generated colors (`~/.config/matugen/config.toml` writes this file).
pcall(require, "hyprland/colors")
require("general")

require("animation")
require("windowrules")
require("keybinds")
require("autostart")

-- Written by the quickshell shell (services/HyprlandConfig.qml -> hyprconfigurator.py).
-- Required last so its hl.config() overrides win.
pcall(require, "hyprland/shellOverrides/main")
