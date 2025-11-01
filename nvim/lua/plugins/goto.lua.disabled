return {
	name = "goto-preview",
	dir = "@goto_preview@",
	event = "BufEnter",
	config = function()
		require("goto-preview").setup()

		vim.keymap.set("n", "gtd", require("goto-preview").goto_preview_definition)
		vim.keymap.set("n", "gtt", require("goto-preview").goto_preview_type_definition)
		vim.keymap.set("n", "gti", require("goto-preview").goto_preview_implementation)
		vim.keymap.set("n", "gtP", require("goto-preview").close_all_win)
	end,
}
