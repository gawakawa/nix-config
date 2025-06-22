return {
	"stevearc/conform.nvim",
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
	opts = {
		formatters_by_ft = {
			css = { "deno_fmt" },
			haskell = { "fourmolu" },
			html = { "deno_fmt" },
			javascript = { "deno_fmt" },
			javascriptreact = { "deno_fmt" },
			json = { "deno_fmt" },
			jsonc = { "deno_fmt" },
			lua = { "stylua" },
			nix = { "nixfmt" },
			purescript = { "purs_tidy" },
			rust = { "rustfmt" },
			terraform = { "terraform_fmt" },
			typescript = { "deno_fmt" },
			typescriptreact = { "deno_fmt" },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = { timeout_ms = 3000 },
	},
}
