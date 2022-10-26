local M = {}

local function setup()
	local lualine = require("lualine")

	local colors = require("skill.theme.theme").palette

	local conditions = {
		buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end,
		hide_in_width = function()
			return vim.o.columns > 80
		end,
		hide_small = function()
			return vim.o.columns > 140
		end,
		check_git_workspace = function()
			local filepath = vim.fn.expand("%:p:h")
			local gitdir = vim.fn.finddir(".git", filepath .. ";")
			return gitdir and #gitdir > 0 and #gitdir < #filepath
		end,
	}

	local function list_formatters(filetype)
		local sources = require("null-ls.sources")
		local supported_formatters = sources.get_supported(filetype, "formatting")
		local active_formatters = {}
		table.sort(supported_formatters)

		for _, s in pairs(supported_formatters) do
			for _, a in pairs(vim.g.formatters) do
				if a == s then
					table.insert(active_formatters, a)
				end
			end
		end
		return active_formatters
	end

	local function list_linters(filetype)
		local sources = require("null-ls.sources")
		local supported_linters = sources.get_supported(filetype, "diagnostics")
		local active_linters = {}

		table.sort(supported_linters)

		for _, s in pairs(supported_linters) do
			for _, a in pairs(vim.g.formatters) do
				if a == s then
					table.insert(active_linters, a)
				end
			end
		end
		return active_linters
	end

	local config = {
		options = {
			theme = {
				normal = {
					a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
					b = { bg = colors.base4, fg = colors.bg, gui = "bold" },
					x = { fg = colors.base7, gui = "bold" },
					y = { fg = colors.cyan, gui = "bold" },
					z = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
				},
				insert = {
					a = { bg = colors.cyan, fg = colors.bg, gui = "bold" },
				},
				visual = {
					a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				},
				replace = {
					a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				},
				command = {
					a = { bg = colors.magenta, fg = colors.bg, gui = "bold" },
				},
				inactive = {
					a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
				},
			},
			globalstatus = true,
			disabled_filetypes = { "packer", "alpha", "NvimTree" }, -- Disable sections and component separators
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = {
				function()
					return "  ⛛  "
				end,
			},
			lualine_b = {
				function()
					return " "
				end,
			},
			lualine_c = {
				{ "filetype", fmt = string.upper, color = { fg = colors.base7 } },
				{ "filename", color = { fg = colors.fg } },
				{ "location" },
				{
					"diagnostics",
					sources = { "nvim_lsp" },
					-- symbols = { error = " ", warn = " ", info = " " },

					diagnostics_color = {
						error = { fg = colors.red },
						warn = { fg = colors.yellow },
						info = { fg = colors.cyan },
					},
				},
			},
			lualine_x = {
				{
					function(msg)
						-- msg = msg or kind.icons.ls_inactive .. "LS Inactive"
						msg = ""

						local buf_clients = vim.lsp.buf_get_clients()

						if next(buf_clients) == nil then
							if type(msg) == "boolean" or #msg == 0 then
								return "轢LS Inactive"
							end
							return msg
						end

						local buf_ft = vim.bo.filetype
						local buf_client_names = {}
						local only_lsp = ""
						local lsp_icon = "歷"

						-- add lsp
						for _, client in pairs(buf_clients) do
							if client.name ~= "null-ls" then
								local _added_client = client.name
								only_lsp = only_lsp .. _added_client
								_added_client = string.sub(client.name, 1, 7)
								table.insert(buf_client_names, _added_client)
							end
						end

						-- add formatter
						local supported_formatters = {}
						for _, fmt in pairs(list_formatters(buf_ft)) do
							table.insert(supported_formatters, fmt)
						end

						vim.list_extend(buf_client_names, supported_formatters)

						-- add linter
						local supported_linters = {}
						for _, lnt in pairs(list_linters(buf_ft)) do
							table.insert(supported_linters, lnt)
						end
						vim.list_extend(buf_client_names, supported_linters)

						-- return lsp_icon .. table.concat(buf_client_names, ", ")
						--
						if conditions.hide_small() then
							return lsp_icon .. table.concat(buf_client_names, "  ")
						elseif conditions.hide_in_width() then
							return only_lsp
						else
							return string.sub(only_lsp, 1, 5)
						end
					end,
					fmt = string.upper,
				},
			},
			lualine_y = {
				{
					"branch",
					icon = "שׂ",
					fmt = function(msg)
						if string.len(msg) < 20 then
							return msg
						else
							return string.sub(msg, 1, 17) .. ""
						end
					end,
				},
			},
			lualine_z = {
				function()
					return os.date("%H:%M")
				end,
			},
		},
		inactive_sections = {},
	}

	config.inactive_sections = config.sections

	lualine.setup(config)
end

M.setup = setup

return M
