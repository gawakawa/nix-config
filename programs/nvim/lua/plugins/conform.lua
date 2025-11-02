return {
	name = "conform.nvim",
	dir = "@conform_nvim@",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				css = { "treefmt" },
				clojure = { "treefmt" },
				go = { "treefmt" },
				haskell = { "fourmolu" },
				html = { "treefmt" },
				javascript = { "treefmt" },
				javascriptreact = { "treefmt" },
				json = { "treefmt" },
				jsonc = { "treefmt" },
				lua = { "treefmt" },
				nix = { "treefmt" },
				purescript = { "treefmt" },
				python = { "treefmt" },
				rust = { "treefmt" },
				terraform = { "treefmt" },
				typescript = { "treefmt" },
				typescriptreact = { "treefmt" },
			},
			formatters = {
				treefmt = {
					command = "nix",
					args = { "fmt", "--", "$FILENAME" },
					stdin = false,
					cwd = require("conform.util").root_file({ ".git" }),
				},
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = { timeout_ms = 3000 },
		})
	end,
}
