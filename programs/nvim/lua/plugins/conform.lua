return {
	name = "conform.nvim",
	dir = "@conform_nvim@",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ formatters = { "treefmt" }, async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
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
			format_on_save = function(bufnr)
				return {
					timeout_ms = 3000,
					formatters = { "treefmt" },
				}
			end,
		})
	end,
}
