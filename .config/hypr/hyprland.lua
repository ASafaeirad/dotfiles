hl.monitor({ output = "", mode = "highres", position = "auto", scale = 1 })

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

require("plugins")
require("general")
require("animation")
require("windowrules")
require("keybinds")
require("autostart")
pcall(require, "quickshell/overrides")
