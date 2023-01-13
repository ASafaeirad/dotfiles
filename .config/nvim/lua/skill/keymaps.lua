local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local command_opts = {}
local keymap = vim.api.nvim_set_keymap

-- Leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts_map = {
	n = opts,
	t = term_opts,
	c = command_opts,
}

vim.g.VM_Mono_hl = "DiffText"
vim.g.VM_Extend_hl = "DiffAdd"
vim.g.VM_Cursor_hl = "Visual"
vim.g.VM_Insert_hl = "DiffChange"

local keymaps = {
	[""] = {
		["<leader>l"] = "<Cmd>lua require'nvim-tree.lib'.collapse_all()<CR>",
		["<C-l>"] = "<Cmd>lua require'nvim-tree.lib'.collapse_all()<CR>",
	},
	n = {
		["<C-Space>"] = "<Nop>",
		["<leader>R"] = ":source $MYVIMRC<CR>",
		["<C-h>"] = "<C-w>h",
		["<C-j>"] = "<C-w>j",
		["<C-k>"] = "<C-w>k",
		["<C-l>"] = "<C-w>l",
		["<C-Up>"] = ":resize -2<CR>",
		["<C-Down>"] = ":resize +2<CR>",
		["<C-Left>"] = ":vertical resize -2<CR>",
		["<C-Right>"] = ":vertical resize +2<CR>",
		["<M-l>"] = ":bnext<CR>",
		["<M-h>"] = ":bprevious<CR>",
		["<C-\\>"] = ":NvimTreeToggle<CR>",
		["<leader>e"] = ":NvimTreeToggle<CR>",
		["<M-k>"] = "mz:m-2<cr>`z",
		["<M-j>"] = "mz:m+<cr>`z",
		["<leader>n"] = ":nohl<CR>",
		["<leader>ff"] = "<Cmd>Telescope find_files<CR>",
		["<leader>ft"] = "<Cmd>Telescope live_grep<CR>",
		["x"] = '"_x',
		["<leader>q"] = ":Bdelete<CR>",
		["gdn"] = ":lua vim.diagnostic.goto_next()<CR>",
		["gdp"] = ":lua vim.diagnostic.goto_prev()<CR>",
		["<leader>oc"] = "<Cmd>!code %<CR>",
		["<leader>A"] = "<Cmd>Alpha<CR>",
		["<leader><leader>"] = "<Cmd>lua require('telescope').extensions.frecency.frecency{ sorter = require('telescope.config').values.file_sorter(),  }<CR>",

		["<C-d>"] = "<C-d>zz",
		["<C-u>"] = "<C-d>zz",
		["n"] = "nzzzv",
		["N"] = "Nzzzv",

		["<leader>gg"] = ":LazyGit<CR>",
		["<leader>gp"] = "<Cmd>lua require 'gitsigns'.next_hunk({ navigation_message = false })<CR>",
		["<leader>gn"] = "<Cmd>lua require 'gitsigns'.prev_hunk({ navigation_message = false })<CR>",
		["<leader>gl"] = "<Cmd>lua require 'gitsigns'.blame_line()<CR>",
		["<leader>gr"] = "<Cmd>lua require 'gitsigns'.reset_hunk()<CR>",
		["<leader>gR"] = "<Cmd>lua require 'gitsigns'.reset_buffer()<CR>",
		["<leader>gs"] = "<Cmd>lua require 'gitsigns'.stage_hunk()<CR>",
		["<leader>gu"] = "<Cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>",
		["<leader>gf"] = "<Cmd>Telescope git_status<CR>",
		["<leader>gb"] = "<Cmd>Telescope git_branches<CR>",
		["<leader>gc"] = "<Cmd>Telescope git_commits<CR>",
		["<leader>gC"] = "<Cmd>Telescope git_bcommits<CR>",
		["<leader>gd"] = "<Cmd>Gitsigns diffthis HEAD<CR>",

		["<leader>ld"] = "<Cmd>Telescope diagnostics bufnr=0 theme=get_ivy<CR>",
		["<leader>lw"] = "<Cmd>Telescope diagnostics<CR>",
		["<leader>lf"] = "<Cmd>Format<CR>",
		["<leader>li"] = "<Cmd>LspInfo<CR>",
		["<leader>lI"] = "<Cmd>Mason<CR>",
		["<leader>ln"] = "<Cmd>lua vim.diagnostic.goto_next()<CR>",
		["<leader>lp"] = "<Cmd>lua vim.diagnostic.goto_prev()<CR>",
		["<leader>ll"] = "<Cmd>lua vim.lsp.codelens.run()<CR>",
		["<leader>lq"] = "<Cmd>lua vim.diagnostic.setloclist()<CR>",
		["<leader>lr"] = "<Cmd>lua vim.lsp.buf.rename()<CR>",
		["<leader>ls"] = "<Cmd>Telescope lsp_document_symbols<CR>",
		["<leader>lS"] = "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
		["<leader>le"] = "<Cmd>Telescope quickfix<CR>",

		["<leader>sb"] = "<Cmd>Telescope git_branches<CR>",
		["<leader>ss"] = "<Cmd>SessionManager load_session<CR>",
		["<leader>sc"] = "<Cmd>Telescope colorscheme<CR>",
		["<leader>sf"] = "<Cmd>Telescope find_files<CR>",
		["<leader>sh"] = "<Cmd>Telescope help_tags<CR>",
		["<leader>sH"] = "<Cmd>Telescope highlights<CR>",
		["<leader>sM"] = "<Cmd>Telescope man_pages<CR>",
		["<leader>sr"] = "<Cmd>Telescope oldfiles<CR>",
		["<leader>sR"] = "<Cmd>Telescope registers<CR>",
		["<leader>st"] = "<Cmd>Telescope live_grep<CR>",
		["<leader>sk"] = "<Cmd>Telescope keymaps<CR>",
		["<leader>sC"] = "<Cmd>Telescope commands<CR>",
		["<leader>sp"] = "<Cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<CR>",
		["<leader>rl"] = "<Cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>",
	},
	v = {
		["<"] = "<gv",
		[">"] = ">gv",
		["<M-j>"] = ":m .+1<CR>==",
		["<M-k>"] = ":m .-2<CR>==",
		["p"] = '"_dP',
	},
	x = {
		["J"] = ":move '>+1<CR>gv-gv",
		["K"] = ":move '<-2<CR>gv-gv",
		["<M-j>"] = ":move '>+1<CR>gv-gv",
		["<M-k>"] = ":move '<-2<CR>gv-gv",
	},
	["!"] = {
		["<S-Insert>"] = "<C-R>+",
		["<C-v>"] = "<C-R>+",
	},
	t = {
		["<C-v>"] = "<Esc>pi",
		["<C-S-v>"] = "<Esc>pi",
		-- ["<esc>"] = "<C-><C-n>",
		-- ["<C-h>"] = "<Cmd>wincmd h<CR>",
		-- ["<C-j>"] = "<Cmd>wincmd j<CR>",
		-- ["<C-k>"] = "<Cmd>wincmd k<CR>",
		-- ["<C-l>"] = "<Cmd>wincmd l<CR>",
	},
}

-- vim.g.VM_maps["Undo"] = "u"
-- vim.g.VM_maps["Redo"] = "<C-r>"

local function set_keymaps()
	for mode, map in pairs(keymaps) do
		local opt = opts_map[mode] or opts
		for key, val in pairs(map) do
			if val then
				vim.api.nvim_set_keymap(mode, key, val, opt)
			else
				pcall(vim.api.nvim_del_keymap, mode, key)
			end
		end
	end
end

set_keymaps()
