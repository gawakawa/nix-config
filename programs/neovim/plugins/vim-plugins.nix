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

  # Completion (Phase 2B)
  nvim-cmp
  cmp-nvim-lsp
  cmp-buffer
  cmp-path
  cmp-cmdline
  cmp_luasnip
  luasnip

  # File Navigation (Phase 2C)
  telescope-nvim
  plenary-nvim
  neo-tree-nvim
  nui-nvim
]
