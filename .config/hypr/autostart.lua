hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")

    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,ssh")
    hl.exec_cmd("import-gsettings")

    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("hypridle")

    hl.exec_cmd("qs -c skill")
    hl.exec_cmd("flyterm")
    hl.exec_cmd("notion-app")

    -- Apply the real AC/battery policy once the compositor is up.
    hl.exec_cmd("power auto")
end)
