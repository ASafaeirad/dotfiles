local status_ok, lspconfig = pcall(require, "lspconfig")
local mason_ok, mason = pcall(require, "mason")
local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local handlers = require("skill.lsp.handlers")

if not status_ok or not mason_lsp_ok or not mason_ok then
	print("ERROR")
	return
end

local M = {}

local function setup()
	mason.setup()
	mason_lspconfig.setup({
		ensure_installed = vim.g.lsp_servers,
	})
	handlers.setup()

	for _, server in pairs(vim.g.lsp_servers) do
		local opts = { on_attach = handlers.on_attach, capabilities = handlers.capabilities }
		local has_custom_opts, server_custom_opts = pcall(require, "skill.lsp.settings." .. server)

		if has_custom_opts then
			opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
		end
		lspconfig[server].setup(opts)
	end
end

M.setup = setup
return M
