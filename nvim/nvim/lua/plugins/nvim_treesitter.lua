return {
	name = "nvim-treesitter",
	dir = "@nvim_treesitter@",
	event = "BufReadPre",
	config = function()
		vim.opt.runtimepath:append("@treesitter_parsers@")

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
