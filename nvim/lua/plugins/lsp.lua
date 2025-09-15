return {
	{
		"williamboman/mason.nvim",
		priority = 1000,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"denols",
					"gopls",
					"purescriptls",
					"rust_analyzer",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Configure diagnostics display
			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = {
					format = function(d)
						local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
						local w = wininfo.width - wininfo.textoff - 5
						local m = d.message
						if #m <= w then
							return m
						end

						local result, line = "", ""
						for word in m:gmatch("%S+") do
							if #line + #word > w then
								result = result .. line .. "\n"
								line = word
							else
								line = line == "" and word or line .. " " .. word
							end
						end
						return result .. line
					end,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- LSP server setup
			require("lspconfig").denols.setup({})
			require("lspconfig").gopls.setup({})
			require("lspconfig").hls.setup({})
			-- require("lspconfig").lua_ls.setup {}
			require("lspconfig").prismals.setup({})
			require("lspconfig").purescriptls.setup({})
			require("lspconfig").rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
						},
					},
				},
			})
			require("lspconfig").terraformls.setup({})
		end,
	},
}
