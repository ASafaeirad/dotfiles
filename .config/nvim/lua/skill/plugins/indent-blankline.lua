local M = {}

local function config()
	require("ibl").setup({
		exclude = {
			buftypes = { "terminal", "nofile" },
			filetypes = {
				"help",
				"terminal",
				"dashboard",
				"alpha",
				"packer",
				"TelescopePrompt",
				"TelescopeResults",
				"",
			},
		},
		scope = { enabled = true, show_start = false },
	})
end

M.config = config

return M
