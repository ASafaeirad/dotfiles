local options = {
	backup = false,
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	swapfile = false,
	undofile = true, -- enable persistent undo

	showtabline = 0, -- always show tabs
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	expandtab = true, -- convert tabs to spaces
	smartindent = true,

	clipboard = "unnamedplus",
	completeopt = { "menuone", "noselect" },
	fileencoding = "utf-8", -- the encoding written to a file
	mouse = "a", -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	smartcase = true,

	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	termguicolors = true, -- set term gui colors (most terminals support this)

	number = true, -- set numbered lines
	relativenumber = true, -- set relative numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}

	list = true,
	conceallevel = 1, -- so that `` is visible in markdown files
	cmdheight = 1, -- more space in the neovim command line for displaying messages
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = false, -- display lines as one long line
	linebreak = false, -- companion to wrap, don't split words
	scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor
	sidescrolloff = 1, -- minimal number of screen columns either side of cursor if wrap is `false`
	cursorline = true, -- highlight the current line
	guifont = "Input Mono,DejaVuSansMono Nerd Font Mono,VimFile:h12",

	timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
	updatetime = 300, -- faster completion (4000ms default)
}

-- vim.opt.listchars:append "space:⋅"
vim.opt.shortmess:append("c")
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- vim.g.transparency = 0.9
-- vim.cmd("let g:neovide_background_color = '#0f1117'.printf('%x', float2nr(255 * g:transparency))")
