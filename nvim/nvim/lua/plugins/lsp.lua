return {
	{
		name = "mason.nvim",
		dir = "@mason_nvim@",
		lazy = false,
		priority = 1000,
		config = function()
			require("mason").setup()
		end,
	},
	{
		name = "mason-lspconfig.nvim",
		dir = "@mason_lspconfig_nvim@",
		lazy = false,
		dependencies = {
			{ name = "mason.nvim", dir = "@mason_nvim@" },
			{ name = "nvim-lspconfig", dir = "@nvim_lspconfig@" },
		},
		config = function()
			require("mason-lspconfig").setup({})
		end,
	},
	{
		name = "nvim-lspconfig",
		dir = "@nvim_lspconfig@",
		lazy = false,
		dependencies = {
			{ name = "mason.nvim", dir = "@mason_nvim@" },
			{ name = "mason-lspconfig.nvim", dir = "@mason_lspconfig_nvim@" },
		},
		config = function()
			-- Configure diagnostics display
			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = {
					format = function(diagnostic)
						return string.format("%s\n(%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
					end,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- LSP server setup using new vim.lsp.config API
			vim.lsp.config.asm_lsp = {}
			vim.lsp.config.bashls = {}
			vim.lsp.config.clangd = {}
			vim.lsp.config.clojure_lsp = {}
			vim.lsp.config.denols = {}
			vim.lsp.config.gopls = {}
			vim.lsp.config.hls = {}
			vim.lsp.config.lua_ls = {}
			vim.lsp.config.prismals = {}
			vim.lsp.config.purescriptls = {}
			vim.lsp.config.rust_analyzer = {
				root_dir = function(bufnr, cb)
					cb(vim.fs.root(bufnr, { "Cargo.toml" }))
				end,
				settings = {
					["rust-analyzer"] = {
						check = { command = "clippy" },
					},
				},
			}
			vim.lsp.config.ruff = {}
			vim.lsp.config.terraformls = {}

			-- Enable LSP servers
			vim.lsp.enable({
				"asm_lsp",
				"bashls",
				"clangd",
				"clojure_lsp",
				"denols",
				"gopls",
				"hls",
				"lua_ls",
				"prismals",
				"purescriptls",
				"rust_analyzer",
				"ruff",
				"terraformls",
			})
		end,
	},
}
