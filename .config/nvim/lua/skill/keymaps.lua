local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<C-Space>", "<Nop>", opts)

-- Leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Resource
keymap("n", "<leader>R", ":source $MYVIMRC<CR>", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<M-l>", ":bnext<CR>", opts)
keymap("n", "<M-h>", ":bprevious<CR>", opts)
keymap("n", "<C-\\>", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Move text up and down
keymap("n", "<M-k>", "mz:m-2<cr>`z", opts)
keymap("n", "<M-j>", "mz:m+<cr>`z", opts)

keymap("n", "<leader>n", ":nohl<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<M-j>", ":m .+1<CR>==", opts)
keymap("v", "<M-k>", ":m .-2<CR>==", opts)

-- Visual Block --
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<M-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<M-k>", ":move '<-2<CR>gv-gv", opts)

keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", "<cmd>Telescope live_grep<CR>", opts)
keymap("n", "<leader><leader>", "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>", opts)

-- Better Registers --
keymap("v", "p", '"_dP', opts)
keymap("n", "x", '"_x', opts)

keymap("!", "<S-Insert>", "<C-R>+", {})
keymap("!", "<C-v>", "<C-R>+", {})
keymap("n", "<leader>q", ":Bdelete<CR>", opts)

keymap("n", "<leader>gg", ":LazyGit<CR>", opts)

keymap("n", "gdn", ":lua vim.diagnostic.goto_next()<CR>", opts)
keymap("n", "gdp", ":lua vim.diagnostic.goto_prev()<CR>", opts)
