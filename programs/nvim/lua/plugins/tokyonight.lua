return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			transparent = true,
			style = "night",
			on_colors = function(colors)
				colors.comment = "#7a88cf"
			end,
			on_highlights = function(highlights, colors)
				highlights.DiagnosticUnnecessary = { fg = "#7a88cf" }
			end,
		})
		vim.cmd([[colorscheme tokyonight]])
	end,
}
