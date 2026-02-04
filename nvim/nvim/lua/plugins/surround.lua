return {
	name = "nvim-surround",
	dir = "@nvim_surround@",
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			-- Configuration here, or leave empty to use defaults
		})
	end,
}
