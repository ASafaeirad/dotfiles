local M = {}
local function setup()
	require("illuminate").configure({
		providers = {
			"lsp",
			"treesitter",
			"regex",
		},
		delay = 100,
		-- under_cursor: whether or not to illuminate under the cursor
		under_cursor = true,
		-- large_file_cutoff: number of lines at which to use large_file_config
		-- The `under_cursor` option is disabled when this cutoff is hit
		large_file_cutoff = 1000,
		-- large_file_config: config to use for large files (based on large_file_cutoff).
		-- Supports the same keys passed to .configure
		-- If nil, vim-illuminate will be disabled for large files.
		large_file_overrides = nil,
	})
end

M.setup = setup

return M
