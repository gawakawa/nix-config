return {
	name = "lean.nvim",
	dir = "@lean_nvim@",
	event = { "BufReadPre *.lean", "BufNewFile *.lean" },
	dependencies = {
		{ name = "nvim-lspconfig", dir = "@nvim_lspconfig@" },
		{ name = "plenary.nvim", dir = "@plenary_nvim@" },
		{ name = "vim-matchup", dir = "@vim_matchup@" },
		{ name = "switch.vim", dir = "@switch_vim@" },
		{ name = "tcomment_vim", dir = "@tcomment_vim@" },
		{ name = "telescope.nvim", dir = "@telescope_nvim@" },
		{ name = "nvim-cmp", dir = "@nvim_cmp@" },
	},
	opts = {
		mappings = true,
	},
}
