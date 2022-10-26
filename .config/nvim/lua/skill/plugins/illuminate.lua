local M = {}
local function setup()
	require("illuminate").configure({
		providers = {
			"lsp",
			"treesitter",
			"regex",
		},
		filetypes_denylist = {
			"alpha",
			"NvimTree",
		},
		delay = 100,
		under_cursor = true,
		large_file_cutoff = 1000,
		large_file_overrides = nil,
	})
end

M.setup = setup

return M
