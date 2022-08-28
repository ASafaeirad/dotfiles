local M = {}

local function setup()
	require("toggleterm").setup({
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
		open_mapping = [[<C-`>]],
		hide_numbers = true,
		shade_filetypes = {},
		autochdir = false,
		highlights = {
			-- Normal = {
			-- 	guibg = "<VALUE-HERE>",
			-- },
			NormalFloat = {
				link = "Normal",
			},
			FloatBorder = {
				link = "Type",
				-- guibg = "<VALUE-HERE>",
			},
		},
		-- shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
		shade_terminals = true,
		start_in_insert = true,
		insert_mappings = true,
		terminal_mappings = true,
		persist_size = true,
		persist_mode = true,
		direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
		auto_scroll = true,
		float_opts = {
			border = "curved",
			winblend = 3,
		},
		winbar = {
			enabled = false,
			name_formatter = function(term)
				return term.name
			end,
		},
	})
end

M.setup = setup

return M
