return {
	name = "move.nvim",
	dir = "@move_nvim@",
	keys = {
		-- Normal Mode
		{ "<A-j>", ":MoveLine(1)<CR>", desc = "Move Line Up" },
		{ "<A-k>", ":MoveLine(-1)<CR>", desc = "Move Line Down" },
		{ "<A-h>", ":MoveHChar(-1)<CR>", desc = "Move Character Left" },
		{ "<A-l>", ":MoveHChar(1)<CR>", desc = "Move Character Right" },
		{ "<leader>wf", ":MoveWord(-1)<CR>", mode = { "n" }, desc = "Move Word Left" },
		{ "<leader>wb", ":MoveWord(1)<CR>", mode = { "n" }, desc = "Move Word Right" },
		-- Visual Mode
		{ "<A-j>", ":MoveBlock(1)<CR>", mode = { "v" }, desc = "Move Block Up" },
		{ "<A-k>", ":MoveBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Down" },
		{ "<A-h>", ":MoveHBlock(-1)<CR>", mode = { "v" }, desc = "Move Block Left" },
		{ "<A-l>", ":MoveHBlock(1)<CR>", mode = { "v" }, desc = "Move Block Right" },
	},
	opts = {
		-- Config here
	},
}
