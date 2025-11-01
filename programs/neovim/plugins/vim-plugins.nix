{ pkgs, ... }:

let
  # Custom plugins not in nixpkgs
  move-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "move.nvim";
    version = "unstable-2024-02-21";
    src = pkgs.fetchFromGitHub {
      owner = "fedepujol";
      repo = "move.nvim";
      rev = "599b14047b82e92874b9a408e4df228b965c3a1d";
      hash = "sha256-LO6MT0gSZzmgUnV6CyRCvl9ibvJRTffTBjgBaKyA5u8=";
    };
  };
in

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

  # Custom plugins (Phase 5)
  move-nvim
  # goto-preview, codecompanion-nvim, vim-elin will be added next

  # Treesitter (Phase 4) - with parsers
  (nvim-treesitter.withPlugins (
    plugins: with plugins; [
      agda
      bash
      clojure
      css
      dockerfile
      gitignore
      go
      haskell
      html
      javascript
      json
      lua
      markdown
      nix
      prisma
      purescript
      rust
      sql
      terraform
      tsx
      typescript
      yaml
    ]
  ))
]
