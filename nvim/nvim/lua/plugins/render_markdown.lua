return {
	name = "render-markdown.nvim",
	dir = "@render_markdown_nvim@",
	dependencies = {
		{ name = "nvim-treesitter", dir = "@nvim_treesitter@" },
		{ name = "mini.nvim", dir = "@mini_nvim@" },
	},
	keys = {
		{ "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Render Markdown" },
	},
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
}
