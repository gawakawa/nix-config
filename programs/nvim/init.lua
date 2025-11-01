vim.loader.enable()

-- Add the modified lazy.nvim to runtime path
local lazypath = "@lazy_nvim@"
vim.opt.rtp:prepend(lazypath)

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Core settings (from lua/config/lazy.lua)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.guifont = "FiraCode Nerd Font:h15"

-- Setup lazy.nvim
require("lazy").setup({
	defaults = { lazy = true },
	spec = "plugins",

	-- Disable plugin management features (Nix handles this)
	install = {
		missing = false, -- Don't install missing plugins
	},
	checker = {
		enabled = false, -- Don't check for updates
	},
})
