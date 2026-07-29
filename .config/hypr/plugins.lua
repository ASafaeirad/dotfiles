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
