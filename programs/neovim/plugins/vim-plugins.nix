{ pkgs, ... }:

# Plugin set for Neovim
with pkgs.vimPlugins;
[
  # Core / UI
  tokyonight-nvim
  lualine-nvim
  nvim-web-devicons

  # LSP (Phase 2A)
  mason-nvim
  mason-lspconfig-nvim
  nvim-lspconfig
]
