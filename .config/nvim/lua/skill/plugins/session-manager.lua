local M = {}

M.setup = function()
	local Path = require("plenary.path")
	require("session_manager").setup({
		sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"),
		path_replacer = "__",
		colon_replacer = "++",
		autoload_mode = false, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
		autosave_last_session = true, -- Automatically save last session on exit and on session switch.
		autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
		autosave_ignore_filetypes = {
			"gitcommit",
		},
		autosave_only_in_session = false,
		max_path_length = 80,
	})
end

return M
