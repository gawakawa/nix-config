return {
	name = "telescope.nvim",
	dir = "@telescope_nvim@",
	dependencies = {
		{ name = "plenary.nvim", dir = "@plenary_nvim@" },
	},
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word under Cursor" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "%.git/" },
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = { "--hidden" },
				},
			},
		})
	end,
}
