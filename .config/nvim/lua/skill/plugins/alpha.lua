local M = {}

local function setup()
	local alpha = require("alpha")
	local dashboard = require("alpha.themes.dashboard")

	local function footer()
		local total_plugins = #vim.tbl_keys(packer_plugins)
		local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
		local version = vim.version()
		local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

		return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
	end

	local logo = {
		"",
		"",
		"",
		"",
		" ______     __  __     __     __         __        ",
		"/\\  ___\\   /\\ \\/ /    /\\ \\   /\\ \\       /\\ \\       ",
		'\\ \\___  \\  \\ \\  _"-.  \\ \\ \\  \\ \\ \\____  \\ \\ \\____  ',
		" \\/\\_____\\  \\ \\_\\ \\_\\  \\ \\_\\  \\ \\_____\\  \\ \\_____\\ ",
		"  \\/_____/   \\/_/\\/_/   \\/_/   \\/_____/   \\/_____/ ",
		"",
		"",
		"",
		"",
	}

	local function button(sc, txt, keybind, keybind_opts)
		local b = dashboard.button(sc, txt, keybind, keybind_opts)
		b.opts.hl_shortcut = "Comment"
		b.opts.hl = "Comment"
		return b
	end

	dashboard.section.header.val = logo
	dashboard.section.header.opts.hl = "Type"

	dashboard.section.buttons.val = {
		button("f", "  File Explorer", "<CMD>Telescope find_files<CR>"),
		button("n", "  New File", "<CMD>ene!<CR>"),
		button("r", "  Recent files", ":Telescope oldfiles <CR>"),
		button("t", "  Find Text", "<CMD>Telescope live_grep<CR>"),
		button("l", "  Load last Session", "<CMD>SessionManager load_last_session<CR>"),
		button("s", "  Load Session", "<CMD>SessionManager load_session<CR>"),
		button("c", "  Configuration", "<CMD>edit $HOME/.config/nvim/<CR>"),
		button("q", "  Quit", ":qa<cr>"),
		button("", ""),
	}

	dashboard.section.footer.val = footer()
	dashboard.section.footer.opts.hl = "Comment"

	alpha.setup(dashboard.opts)

	require("alpha").setup(require("alpha.themes.dashboard").config)
end

M.setup = setup

return M
