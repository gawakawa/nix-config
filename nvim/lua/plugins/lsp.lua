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

			-- LSP server setup using new vim.lsp.config API
			vim.lsp.config.denols = {}
			vim.lsp.config.gopls = {}
			vim.lsp.config.hls = {}
			-- vim.lsp.config.lua_ls = {}
			vim.lsp.config.prismals = {}
			vim.lsp.config.purescriptls = {}
			vim.lsp.config.rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
						},
					},
				},
			}
			vim.lsp.config.terraformls = {}

			-- Enable LSP servers
			vim.lsp.enable({ "denols", "gopls", "hls", "prismals", "purescriptls", "rust_analyzer", "terraformls" })
		end,
	},
}
