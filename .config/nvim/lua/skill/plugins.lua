local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
	return
end

packer.startup(function(use)
	use({ "wbthomason/packer.nvim" })
	use({ "nvim-lua/plenary.nvim" })
	use({ "moll/vim-bbye" })
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("skill.plugins.comment").config()
		end,
	})
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	-- UI
	use({
		"RRethy/vim-hexokinase",
		run = "make hexokinase",
		setup = function()
			vim.g.Hexokinase_highlighters = { "virtual" }
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("skill.plugins.lualine")
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("skill.plugins.indent-blankline").config()
		end,
	})
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("skill.plugins.nvim-tree").config()
		end,
	})

	-- Completions
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "saadparwaiz1/cmp_luasnip" })
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-nvim-lua" })
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("skill.plugins.completions").config()
		end,
	})
	use({ "folke/neodev.nvim", module = "neodev" })
	use({ "L3MON4D3/LuaSnip" })

	-- LSP
	use({ "neovim/nvim-lspconfig" })
	use({ "williamboman/mason.nvim" })
	use({ "williamboman/mason-lspconfig.nvim" })
	use({ "jose-elias-alvarez/null-ls.nvim" })
	use({ "jayp0521/mason-null-ls.nvim" })
	use({
		"RRethy/vim-illuminate",
		config = function()
			require("skill.plugins.illuminate").setup()
		end,
	})

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
	})
	use({ "nvim-telescope/telescope-media-files.nvim" })
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("skill.plugins.telescope").config()
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("skill.plugins.nvim-treesitter").config()
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
		on_attach = require("skill.plugins.gitsigns").on_attach,
		config = function()
			require("skill.plugins.gitsigns").config()
		end,
	})

	use({
		"akinsho/toggleterm.nvim",
		config = function()
			require("skill.plugins.toggleterm").setup()
		end,
	})

	-- use { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" }
	-- use { "ahmedkhalf/project.nvim", commit = "628de7e433dd503e782831fe150bb750e56e55d6" }
	-- use { "goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" }
	-- use {"folke/which-key.nvim"}

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
