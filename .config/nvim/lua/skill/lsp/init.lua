local status_ok, lspconfig = pcall(require, "lspconfig")
local mason_ok, mason= pcall(require,"mason")
local null_ls_ok, null_ls = pcall(require, "null-ls")
local mason_lsp_ok, mason_lspconfig = pcall(require,"mason-lspconfig")
local mason_null_ok, mason_null_ls = pcall(require,"mason-null-ls")
local handlers = require("skill.lsp.handlers")

-- if not status_ok or not mason_lsp_ok or not mason_ok or not mason_null_ok or not null_ls_ok then
--   print ("ERROR")
--   return
-- end

vim.opt.relativenumber = false
vim.opt.number = false

local servers = { "sumneko_lua", "jsonls", "tsserver", "html" }
local null_servers = { "eslint_d", "prettierd", "stylua" }

mason.setup()
mason_lspconfig.setup({
    ensure_installed = servers
})
handlers.setup()

for _, server in pairs(servers) do
	local opts = { on_attach = handlers.on_attach, capabilities = handlers.capabilities }
	local has_custom_opts, server_custom_opts = pcall(require, "skill.lsp.settings." .. server)

	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end
	lspconfig[server].setup(opts)
end

mason_null_ls.setup({
    ensure_installed = null_servers,
    automatic_installation = false,
})

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		formatting.prettierd,
		formatting.stylua,
		diagnostics.eslint_d,
	},
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
