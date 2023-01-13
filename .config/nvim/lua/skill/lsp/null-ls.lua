local null_ls_ok, null_ls = pcall(require, "null-ls")
local mason_null_ok, mason_null_ls = pcall(require, "mason-null-ls")

if not mason_null_ok or not null_ls_ok then
	print("ERROR")
	return
end

local M = {}

local null_servers = vim.tbl_deep_extend("force", vim.g.formatters, vim.g.linters)

function M.setup()
	mason_null_ls.setup({
		ensure_installed = null_servers,
		automatic_installation = false,
	})

	local formatting = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
	local code_actions = null_ls.builtins.code_actions

	-- Format on save
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	null_ls.setup({
		sources = {
			formatting.prettierd,
			formatting.stylua,
			diagnostics.eslint_d,
			code_actions.eslint_d,
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
end

return M
