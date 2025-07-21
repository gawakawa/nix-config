return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"bash",
				"css",
				"dockerfile",
				"gitignore",
				"go",
				"haskell",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"nix",
				"prisma",
				"purescript",
				"rust",
				"sql",
				"terraform",
				"tsx",
				"typescript",
				"yaml",
			},
			sync_install = false,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
