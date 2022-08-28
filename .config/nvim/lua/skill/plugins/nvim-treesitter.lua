local M = {}

local function config()
	local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		return
	end

	-- avoid running in headless mode since it's harder to detect failures
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	treesitter_configs.setup({
		ensure_installed = { "typescript", "tsx", "lua", "rust" },
		sync_install = false,
		auto_install = true, -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
		ignore_install = { "javascript" },
		highlight = {
			enable = true,
			disable = function(lang, buf)
				local max_filesize = 100 * 1024
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
			additional_vim_regex_highlighting = false,
		},
		rainbow = {
			enable = true,
			extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
			max_file_lines = nil, -- Do not enable for files with more than n lines, int
			colors = {
				"#FFD86E",
				"#4EB4FF",
				"#F29086",
				"#5BF29A",
			},
			-- termcolors = {} -- table of colour name strings
		},
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
	})
end

M.config = config

return M
