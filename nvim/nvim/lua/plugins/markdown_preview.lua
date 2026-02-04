return {
	name = "markdown-preview.nvim",
	dir = "@markdown_preview_nvim@",
	ft = { "markdown" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	keys = {
		{ "<C-s>", "<Plug>MarkdownPreview", desc = "Start Markdown Preview" },
		{ "<M-s>", "<Plug>MarkdownPreviewStop", desc = "Stop Markdown Preview" },
		{ "<C-p>", "<Plug>MarkdownPreviewToggle", desc = "Toggle Markdown Preview" },
	},
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
}
