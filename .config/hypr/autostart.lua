-- Autostart. (was autostart.conf)

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")

    -- polkit agent is provided by the Quickshell (skill) shell - don't start polkit-gnome
    -- (it would win the registration race and block the shell's agent).
    -- If you stop using the shell, re-add polkit-gnome here.
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,ssh")
    hl.exec_cmd("import-gsettings")

    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("hypridle")

    hl.exec_cmd("qs -c skill")
    hl.exec_cmd("flyterm")
    hl.exec_cmd("notion-app")
end)
