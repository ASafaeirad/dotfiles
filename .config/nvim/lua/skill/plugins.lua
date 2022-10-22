local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
	return
end

packer.startup(function(use)
	use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
	use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
	-- use({ "sainnhe/everforest" })
	use({
		"RRethy/vim-hexokinase",
		run = "make hexokinase",
		setup = function()
			vim.g.Hexokinase_highlighters = { "virtual" }
		end,
	})
	-- use({
	-- 	"windwp/nvim-autopairs",
	-- 	config = function()
	-- 		require("nvim-autopairs").setup({})
	-- 	end,
	-- }) -- Autopairs, integrates with both cmp and treesitter
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				{
					---Add a space b/w comment and the line
					padding = true,
					---Whether the cursor should stay at its position
					sticky = true,
					---Lines to be ignored while (un)comment
					ignore = nil,
					toggler = {
						line = "gcc",
						block = "gbc",
					},
					opleader = {
						line = "gc",
						block = "gb",
					},
					extra = {
						above = "gcO",
						below = "gco",
						eol = "gcA",
					},
					mappings = {
						basic = true,
						extra = true,
					},
				},
			})
		end,
	})
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("skill.plugins.nvim-tree")
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("skill.plugins.lualine")
		end,
	})
	-- use { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" }
	-- use { "ahmedkhalf/project.nvim", commit = "628de7e433dd503e782831fe150bb750e56e55d6" }
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
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
		end,
	})
	-- use { "goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" }
	-- use {"folke/which-key.nvim"}

	-- Completions
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("skill.plugins.completions")
		end,
	}) -- The completion plugin

	-- Snippets
	use({ "L3MON4D3/LuaSnip" }) --snippet engine

	-- LSP
	use({ "neovim/nvim-lspconfig" }) -- enable LSP
	use({ "williamboman/mason.nvim" }) -- simple to use language server installer
	use({ "williamboman/mason-lspconfig.nvim" })
	use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
	use({ "jayp0521/mason-null-ls.nvim" })
	-- use { "RRethy/vim-illuminate", commit = "a2e8476af3f3e993bb0d6477438aad3096512e42" }

	-- Telescope
	use({ "BurntSushi/ripgrep" })
	use({ "nvim-telescope/telescope-fzy-native.nvim" })
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})
	use({
		"nvim-telescope/telescope-frecency.nvim",
		requires = { "kkharji/sqlite.lua" },
		ignore_patterns = { "*.git/*", "*/node_modules/*" },
	})
	use({ "nvim-lua/popup.nvim" })
	use({ "nvim-telescope/telescope-media-files.nvim" })
	use({
		"nvim-telescope/telescope.nvim",
		extensions = {
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
				find_cmd = "rg",
			},
		},
		config = function()
			local telescope = require("telescope")
			telescope.load_extension("fzf")
			telescope.load_extension("fzy_native")
			telescope.load_extension("media_files")
			telescope.load_extension("frecency")
		end,
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
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
		end,
	})
	use({ "p00f/nvim-ts-rainbow" })
	use({ "nvim-treesitter/playground" })
	use({
		"kdheepak/lazygit.nvim",
		config = function()
			vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
			vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
			vim.g.lazygit_floating_window_corner_chars = { "╭", "╮", "╰", "╯" } -- customize lazygit popup window corner characters
			vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
			vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed
		end,
	})
	use({
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })

			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })

			-- Actions
			map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
			map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
			map("n", "<leader>hS", gs.stage_buffer)
			map("n", "<leader>hu", gs.undo_stage_hunk)
			map("n", "<leader>hR", gs.reset_buffer)
			map("n", "<leader>hp", gs.preview_hunk)
			map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end)
			map("n", "<leader>tb", gs.toggle_current_line_blame)
			map("n", "<leader>hd", gs.diffthis)
			map("n", "<leader>hD", function()
				gs.diffthis("~")
			end)
			map("n", "<leader>td", gs.toggle_deleted)

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
		end,
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
					map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
					map("n", "<leader>hS", gs.stage_buffer)
					map("n", "<leader>hu", gs.undo_stage_hunk)
					map("n", "<leader>hR", gs.reset_buffer)
					map("n", "<leader>hp", gs.preview_hunk)
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end)
					map("n", "<leader>tb", gs.toggle_current_line_blame)
					map("n", "<leader>hd", gs.diffthis)
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end)
					map("n", "<leader>td", gs.toggle_deleted)

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
				signs = {
					add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
					change = {
						hl = "GitSignsChange",
						text = "│",
						numhl = "GitSignsChangeNr",
						linehl = "GitSignsChangeLn",
					},
					delete = {
						hl = "GitSignsDelete",
						text = "_",
						numhl = "GitSignsDeleteNr",
						linehl = "GitSignsDeleteLn",
					},
					topdelete = {
						hl = "GitSignsDelete",
						text = "‾",
						numhl = "GitSignsDeleteNr",
						linehl = "GitSignsDeleteLn",
					},
					changedelete = {
						hl = "GitSignsChange",
						text = "~",
						numhl = "GitSignsChangeNr",
						linehl = "GitSignsChangeLn",
					},
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				yadm = {
					enable = false,
				},
			})
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
