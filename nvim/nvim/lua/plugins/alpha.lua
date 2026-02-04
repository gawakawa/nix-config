return {
	name = "alpha-nvim",
	dir = "@alpha_nvim@",
	lazy = false,
	dependencies = { { dir = "@nvim_web_devicons@" } },
	config = function()
		require("alpha").setup(require("alpha.themes.dashboard").config)
	end,
}
