return {
	name = "nvim-treesitter",
	dir = "@nvim_treesitter@",
	event = "BufReadPre",
	config = function()
		-- Add treesitter parsers from Nix
		vim.opt.runtimepath:append("@treesitter_parsers@")

		local configs = require("nvim-treesitter.configs")

		configs.setup({
			auto_install = false, -- Nix manages parsers
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
