return {
	name = "idris2-nvim",
	dir = "@idris2_nvim@",
	ft = "idris2",
	dependencies = {
		{ name = "nvim-lspconfig", dir = "@nvim_lspconfig@" },
		{ name = "nui.nvim", dir = "@nui_nvim@" },
	},
}
