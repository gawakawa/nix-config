return {
	name = "tokyonight.nvim",
	dir = "@tokyonight_nvim@",
	lazy = false,
	priority = 1000,
	config = function()
		-- Muted but visible foreground for subtle UI elements
		local muted_fg = "#7a88cf"

		require("tokyonight").setup({
			transparent = true,
			style = "night",
			on_colors = function(colors)
				colors.comment = muted_fg
			end,
			on_highlights = function(highlights, colors)
				-- Line number visibility: absolute (current line) vs relative (other lines)
				highlights.LineNr = { fg = colors.orange, bold = true }
				highlights.LineNrAbove = { fg = muted_fg }
				highlights.LineNrBelow = { fg = muted_fg }
				highlights.DiagnosticUnnecessary = { fg = muted_fg }
				-- Make selected completion item more visible
				highlights.PmenuSel = { bg = colors.blue7, fg = colors.fg, bold = true }
			end,
		})
		vim.cmd([[colorscheme tokyonight]])
	end,
}
