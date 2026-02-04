return {
	name = "luasnip",
	dir = "@luasnip@",
	config = function()
		local ls = require("luasnip")
		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node

		ls.config.setup({
			enable_autosnippets = true,
		})

		-- Load Lean abbreviations (generated at build time)
		-- Source: https://github.com/leanprover/vscode-lean4/blob/master/lean4-unicode-input/src/abbreviations.json
		local ok, abbreviations = pcall(require, "data.lean_abbreviations")
		if not ok then
			vim.notify("Failed to load Lean abbreviations", vim.log.levels.WARN)
			return
		end

		local snippets = {}
		local autosnippets = {}

		-- Create fresh nodes for each snippet (LuaSnip doesn't allow node reuse)
		local function make_nodes(symbol)
			local prefix, suffix = symbol:match("^(.-)%$CURSOR(.*)$")
			if prefix then
				return { t(prefix), i(1), t(suffix) }
			else
				return { t(symbol) }
			end
		end

		for trigger, symbol in pairs(abbreviations) do
			-- Regular snippet for completion menu
			table.insert(snippets, s({ trig = trigger, desc = symbol }, make_nodes(symbol)))
			-- Autosnippet with space suffix trigger (space is consumed)
			table.insert(autosnippets, s({ trig = trigger .. " ", snippetType = "autosnippet" }, make_nodes(symbol)))
		end

		ls.add_snippets("all", snippets)
		ls.add_snippets("all", autosnippets)
	end,
}
