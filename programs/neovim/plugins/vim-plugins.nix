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

  # Utilities (Phase 3)
  lazygit-nvim
  nvim-autopairs
  auto-save-nvim
  comment-nvim
  nvim-surround
  bufferline-nvim
  toggleterm-nvim
  trouble-nvim
  conform-nvim
  copilot-vim
  # move-nvim, goto-preview, codecompanion-nvim will be added in Phase 5 (custom build)
]
