-- Use a protected call so we don't error out on first use
local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
	return
end

packer.startup(function(use)
	use({ "wbthomason/packer.nvim" }) -- Have packer manage itself
	use({ "nvim-lua/plenary.nvim" }) -- Useful lua functions used by lots of plugins
	use({
		"RRethy/vim-hexokinase",
		run = "make hexokinase",
		setup = function()
			vim.g.Hexokinase_highlighters = { "virtual" }
		end,
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	}) -- Autopairs, integrates with both cmp and treesitter
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
			local status_ok, nvim_tree = pcall(require, "nvim-tree")
			if not status_ok then
				return
			end

			local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
			if not config_status_ok then
				return
			end

			local tree_cb = nvim_tree_config.nvim_tree_callback

			nvim_tree.setup({
				hijack_netrw = true,
				update_focused_file = {
					enable = true,
					update_cwd = true,
				},
				renderer = {
					root_folder_modifier = ":t",
					icons = {
						glyphs = {
							default = "", -- 
							symlink = "",
							folder = {
								arrow_open = "-", -- 
								arrow_closed = "+", -- 
								default = "", -- 
								open = "", -- 
								empty = "", -- 
								empty_open = "", -- 
								symlink = "",
								symlink_open = "",
							},
							git = {
								unstaged = "",
								staged = "S",
								unmerged = "",
								renamed = "➜",
								untracked = "U",
								deleted = "",
								ignored = "◌",
							},
						},
					},
				},
				diagnostics = {
					enable = true,
					show_on_dirs = true,
					icons = {
						hint = "",
						info = "",
						warning = "",
						error = "",
					},
				},
				view = {
					width = 30,
					side = "left",
					mappings = {
						list = {
							{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
							{ key = "h", cb = tree_cb("close_node") },
							{ key = "v", cb = tree_cb("vsplit") },
						},
					},
				},
			})
		end,
	})

	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			local lualine = require("lualine")
			local colors = require("skill.theme.colors")

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			local config = {
				options = {
					-- globalstatus = true,
					disabled_filetypes = { "packer", "alpha", "NvimTree" }, -- Disable sections and component separators
					component_separators = "",
					section_separators = "",
					theme = {
						normal = { c = { fg = colors.fg, bg = colors.bg } },
						inactive = { c = { fg = colors.fg, bg = colors.bg } },
					},
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_d = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {
						{
							"filename",
							cond = conditions.buffer_not_empty,
							color = { fg = colors.fg },
							padding = { left = 6 },
						},
					},
					lualine_x = {},
				},
			}

			local function ins_left(component)
				table.insert(config.sections.lualine_c, component)
			end

			local function ins_right(component)
				table.insert(config.sections.lualine_x, component)
			end

			ins_left({
				function()
					return " ⛛ "
				end,
				color = function()
					local mode_color = {
						n = colors.yellow,
						i = colors.cyan,
						v = colors.red,
						[""] = colors.red,
						V = colors.red,
						c = colors.magenta,
						no = colors.red,
						s = colors.orange,
						S = colors.orange,
						[""] = colors.orange,
						ic = colors.yellow,
						R = colors.violet,
						Rv = colors.violet,
						cv = colors.red,
						ce = colors.red,
						r = colors.cyan,
						rm = colors.cyan,
						["r?"] = colors.cyan,
						["!"] = colors.red,
						t = colors.red,
					}
					return { fg = mode_color[vim.fn.mode()] }
				end,
				padding = { left = 2 },
			})

			ins_left({
				"filename",
				cond = conditions.buffer_not_empty,
				color = { fg = colors.fg },
			})

			ins_left({
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				diagnostics_color = {
					color_error = { fg = colors.red },
					color_warn = { fg = colors.yellow },
					color_info = { fg = colors.cyan },
				},
			})

			ins_right({
				function()
					local msg = ""
					local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
					local clients = vim.lsp.get_active_clients()
					if next(clients) == nil then
						return msg
					end
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end
					return msg
				end,
				fmt = string.upper,
				color = { fg = colors.base5 },
			})

			ins_right({
				"filetype",
				fmt = string.upper,
				color = { fg = colors.base5 },
			})

			ins_right({
				"location",
				color = { fg = colors.base5 },
			})

			ins_right({
				"branch",
				icon = "שׂ",
				color = { fg = colors.cyan, gui = "bold" },
			})

			lualine.setup(config)
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
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })

	-- Snippets
	use({ "L3MON4D3/LuaSnip" }) --snippet engine

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
		end,
	}) -- enable LSP
	use({ "williamboman/mason.nvim" }) -- simple to use language server installer
	use({ "williamboman/mason-lspconfig.nvim" })
	use { "williamboman/mason-lspconfig.nvim" }
	use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
  use { "jayp0521/mason-null-ls.nvim" }
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
	-- Git
	-- use { "lewis6991/gitsigns.nvim", commit = "2c6f96dda47e55fa07052ce2e2141e8367cbaaf2" }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])
