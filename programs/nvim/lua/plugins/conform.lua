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
				nix = { "nixfmt" },
				rust = { "rustfmt" },
				purescript = { "purs_tidy" },
				python = { "ruff_format", "ruff_organize_imports" },
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				json = { "biome" },
				jsonc = { "biome" },
				go = { "goimports", "gofmt" },
				haskell = { "fourmolu" },
				cabal = { "cabal_fmt" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = function(bufnr)
				return {
					timeout_ms = 3000,
				}
			end,
		})
	end,
}
