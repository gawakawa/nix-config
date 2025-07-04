return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
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
