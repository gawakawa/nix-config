return {
	name = "neo-tree.nvim",
	dir = "@neo_tree_nvim@",
	dependencies = {
		{ name = "plenary.nvim", dir = "@plenary_nvim@" },
		{ name = "nvim-web-devicons", dir = "@nvim_web_devicons@" },
		{ name = "nui.nvim", dir = "@nui_nvim@" },
	},
	keys = {
		{ "<C-n>", ":Neotree toggle<CR>", desc = "Toggle NeoTree" },
	},
	config = function()
		require("neo-tree").setup({
			window = {
				position = "right",
				width = 30,
				auto_resize = true,
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = true,
					hide_gitignored = true,
				},
			},
		})
	end,
}
