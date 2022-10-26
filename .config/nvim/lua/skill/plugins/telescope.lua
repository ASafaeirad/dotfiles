local M = {}

local function config()
	local telescope_ok, telescope = pcall(require, "telescope")
	if not telescope_ok then
		return
	end

	local actions = require("telescope.actions")
	local telescopeConfig = require("telescope.config")
	local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
	table.insert(vimgrep_arguments, "--hidden")
	table.insert(vimgrep_arguments, "--glob")
	table.insert(vimgrep_arguments, "!.git/*")

	telescope.setup({
		defaults = {
			prompt_prefix = " ",
			selection_caret = "> ",
			entry_prefix = "  ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = "descending",
			layout_strategy = "horizontal",
			mappings = {
				i = {
					["<C-u>"] = false,
					["<C-n>"] = actions.move_selection_next,
					["<C-p>"] = actions.move_selection_previous,
					["<C-c>"] = actions.close,
					["<C-j>"] = actions.cycle_history_next,
					["<C-k>"] = actions.cycle_history_prev,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					["<CR>"] = actions.select_default,
				},
				n = {
					["<C-n>"] = actions.move_selection_next,
					["<C-p>"] = actions.move_selection_previous,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				},
			},
			layout_config = {
				width = 0.75,
				preview_cutoff = 120,
				horizontal = {
					preview_width = function(_, cols, _)
						if cols < 120 then
							return math.floor(cols * 0.5)
						end
						return math.floor(cols * 0.6)
					end,
					mirror = false,
				},
				vertical = { mirror = false },
			},
			vimgrep_arguments = vimgrep_arguments,
		},
		pickers = {
			find_files = {
				theme = "dropdown",
				hidden = true,
				previewer = false,
			},
		},
		extensions = {
			frecency = {
				default_workspace = "CWD",
				show_filter_column = false,
				ignore_patterns = { "*.git/*", "*node_modules/*" },
			},
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			fzy_native = {
				override_generic_sorter = false,
				override_file_sorter = true,
			},
			media_files = {
				filetypes = { "png", "webp", "jpg", "jpeg" },
				find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
			},
			["ui-select"] = {
				require("telescope.themes").get_dropdown({
					-- even more opts
				}),

				-- pseudo code / specification for writing custom displays, like the one
				-- for "codeactions"
				-- specific_opts = {
				--   [kind] = {
				--     make_indexed = function(items) -> indexed_items, width,
				--     make_displayer = function(widths) -> displayer
				--     make_display = function(displayer) -> function(e)
				--     make_ordinal = function(e) -> string
				--   },
				--   -- for example to disable the custom builtin "codeactions" display
				--      do the following
				--   codeactions = false,
				-- }
			},
		},
	})

	telescope.load_extension("frecency")
	telescope.load_extension("fzf")
	telescope.load_extension("fzy_native")
	telescope.load_extension("media_files")
	telescope.load_extension("ui-select")
end

M.config = config

return M
