return {
	name = "toggleterm.nvim",
	dir = "@toggleterm_nvim@",
	config = function()
		require("toggleterm").setup({
			auto_scroll = false,
			direction = "float",
			open_mapping = [[<c-t>]],
			size = 20,
			start_in_insert = true,
			highlights = {
				Normal = {
					guibg = "NONE",
					ctermbg = "NONE",
				},
				NormalFloat = {
					guibg = "NONE",
					ctermbg = "NONE",
				},
				FloatBorder = {
					guibg = "NONE",
					ctermbg = "NONE",
				},
			},
		})

		vim.keymap.set("n", "<c-1>", ":1ToggleTerm<CR>")
		vim.keymap.set("n", "<c-2>", ":2ToggleTerm<CR>")
		vim.keymap.set("n", "<c-3>", ":3ToggleTerm<CR>")
		vim.keymap.set("n", "<c-4>", ":4ToggleTerm<CR>")
		vim.keymap.set("n", "<c-5>", ":5ToggleTerm<CR>")
	end,
}
