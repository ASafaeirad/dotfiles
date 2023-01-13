vim.cmd([[
  fun! ReSource()
      source <afile>
  endfun

  augroup theme_user_config
    autocmd!
    autocmd BufWritePost $HOME/.config/nvim/**/*.lua call ReSource()
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

vim.g.formatters = { "prettierd", "stylua" }
vim.g.linters = { "eslint_d" }
vim.g.lsp_servers = { "sumneko_lua", "jsonls", "tsserver", "html", "prismals" }

require("skill")
