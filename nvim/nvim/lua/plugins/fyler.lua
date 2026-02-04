return {
	name = "fyler.nvim",
	dir = "@fyler_nvim@",
	dependencies = {
		{ name = "mini.nvim", dir = "@mini_nvim@" },
	},
	lazy = false,
	keys = {
		{ "<leader>e", "<cmd>Fyler<CR>", desc = "Open Fyler" },
	},
	config = function()
		require("mini.icons").setup()
		require("fyler").setup({
			views = {
				finder = {
					win = {
						kind = "split_right_most",
					},
				},
			},
		})
	end,
}
