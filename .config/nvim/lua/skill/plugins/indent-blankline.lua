local M = {}

local function config()
	require("indent_blankline").setup({
		filetype_exclude = {
			"help",
			"terminal",
			"dashboard",
			"alpha",
			"packer",
			"TelescopePrompt",
			"TelescopeResults",
			"",
		},
		buftype_exclude = { "terminal", "nofile" },
		space_char_blankline = " ",
		show_current_context = true,
		show_current_context_start = false,
	})
end

M.config = config

return M
