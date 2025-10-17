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
			go = { "golines", "gofmt", "goimports" },
			haskell = { "fourmolu" },
			html = { "deno_fmt" },
			javascript = { "deno_fmt" },
			javascriptreact = { "deno_fmt" },
			json = { "deno_fmt" },
			jsonc = { "deno_fmt" },
			lua = { "stylua" },
			nix = { "nixfmt" },
			purescript = { "treefmt" },
			python = {
				"ruff_fix",
				"ruff_format",
				"ruff_organize_imports",
			},
			rust = { "rustfmt" },
			terraform = { "terraform_fmt" },
			typescript = { "deno_fmt" },
			typescriptreact = { "deno_fmt" },
		},
		formatters = {
			deno_fmt = {
				args = { "fmt", "--line-width", "70", "-" },
			},
			stylua = {
				args = { "--column-width", "70", "-" },
			},
			fourmolu = {
				args = { "--column-limit", "70" },
			},
			rustfmt = {
				args = { "--config", "max_width=70" },
			},
			golines = {
				args = { "--max-len", "70" },
			},
			purs_tidy = {
				command = "purs-tidy",
				args = { "format" },
				stdin = true,
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
