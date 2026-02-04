return {
	name = "claude-code.nvim",
	dir = "@claude_code_nvim@",
	dependencies = {
		{ name = "plenary.nvim", dir = "@plenary_nvim@" },
	},
	lazy = false,
	config = function()
		require("claude-code").setup({
			window = {
				split_ratio = 0.4,
				position = "botright vsplit",
			},
		})

		-- Auto-close window when terminal exits
		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "*",
			callback = function(args)
				local bufname = vim.api.nvim_buf_get_name(args.buf)
				if bufname:match("claude") then
					vim.schedule(function()
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == args.buf then
								vim.api.nvim_win_close(win, true)
							end
						end
						if vim.api.nvim_buf_is_valid(args.buf) then
							vim.api.nvim_buf_delete(args.buf, { force = true })
						end
					end)
				end
			end,
		})
	end,
}
