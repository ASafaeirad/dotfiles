if pcall(require, "luasnip") then
	return
end

local ls = require("luasnip")
local types = require("luasnip.util.types")
local events = require("luasnip.util.events")

local snippet = ls.s
local t = ls.text_node
local add_snippets = ls.add_snippets

add_snippets(nil, {
	snippet("simple", t("wow, you were right!")),
})
