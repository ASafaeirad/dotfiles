require("skill.globals")
require("skill.disable_builtins")
require("skill.options")
require("skill.keymaps")
require("skill.theme")
require("skill.init-packer")
require("skill.plugins")
require("skill.lsp")

if vim.g.neovide then
	require("skill.neovide")
end
