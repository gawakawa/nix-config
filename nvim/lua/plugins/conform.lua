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
			css = { "treefmt" },
			go = { "golines", "gofmt", "goimports" },
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
			terraform = { "terraform_fmt" },
			typescript = { "treefmt" },
			typescriptreact = { "treefmt" },
		},
		formatters = {
			fourmolu = {
				args = { "--column-limit", "70" },
			},
			golines = {
				args = { "--max-len", "70" },
			},
			treefmt = {
				command = "nix",
				args = { "fmt", "--", "$FILENAME" },
				stdin = false,
			},
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = { timeout_ms = 3000 },
	},
}
