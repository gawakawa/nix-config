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

  logger-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "logger.nvim";
    version = "unstable-2023-05-25";
    src = pkgs.fetchFromGitHub {
      owner = "rmagatti";
      repo = "logger.nvim";
      rev = "63dd10c9b9a159fd6cfe08435d9606384ff103c5";
      hash = "sha256-4xQFk7+3NWEx1XUZApy4Ldi2xdsna+HdkOmq9vWP3B0=";
    };
  };

  goto-preview = pkgs.vimUtils.buildVimPlugin {
    pname = "goto-preview";
    version = "unstable-2024-09-29";
    src = pkgs.fetchFromGitHub {
      owner = "rmagatti";
      repo = "goto-preview";
      rev = "cf561d10b4b104db20375c48b86cf36af9f96e00";
      hash = "sha256-bOVXiLArwLuzHxC/8rc9yZdYjcBKJQIBZfhbQQe1D38=";
    };
  };

  codecompanion-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "codecompanion.nvim";
    version = "unstable-2025-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "olimorris";
      repo = "codecompanion.nvim";
      rev = "ee6c2a1b3793e73584459f7a2fbac88fce3c6f5b";
      hash = "sha256-YoHXtn2mMb+2617RbaBuVEwHksIfvcgAfHbW4Pr20M0=";
    };
    doCheck = false; # Skip require check (has many external adapter modules)
  };

  vim-elin = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-elin";
    version = "unstable-2024-10-18";
    src = pkgs.fetchFromGitHub {
      owner = "liquidz";
      repo = "vim-elin";
      rev = "f6dcd1bd7b16076c2a3f05fc82255988698d43cc";
      hash = "sha256-j7/CifqG1T4/Eh2anjTjvZKKAJt3G9SST5CtW9Xg5ho=";
    };
  };

  # Language-specific plugins (Phase 6)
  cornelis = pkgs.vimUtils.buildVimPlugin {
    pname = "cornelis";
    version = "unstable-2023-06-02";
    src = pkgs.fetchFromGitHub {
      owner = "isovector";
      repo = "cornelis";
      rev = "3691650f31fe3ec7f130b535aef147aad742b921";
      hash = "sha256-w71k4Gll99rS1TYmm92xkRAFMDGfm3g8j1TqROw4Fxs=";
    };
  };

  lean-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "lean.nvim";
    version = "unstable-2024-11-30";
    src = pkgs.fetchFromGitHub {
      owner = "Julian";
      repo = "lean.nvim";
      rev = "6e359b4472d40ed6752dfc6359e8338981ce6518";
      hash = "sha256-x2XDg5SL8ZfPK9LkO9HnVyMw9m56WBXp2sbdSA4z5Gk=";
    };
    doCheck = false; # Skip require check (has widget and infoview modules)
  };

  idris2-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "idris2-nvim";
    version = "unstable-2024-05-26";
    src = pkgs.fetchFromGitHub {
      owner = "ShinKage";
      repo = "idris2-nvim";
      rev = "19dcf61737293365c23c890ca622fa34aeb12780";
      hash = "sha256-zDb6ke7vzAUWoZPqOgFgszdKe78SI08WRQyPzKTqkXo=";
    };
    doCheck = false; # Skip require check (has REPL module dependencies)
  };

  switch-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "switch.vim";
    version = "unstable-2024-10-21";
    src = pkgs.fetchFromGitHub {
      owner = "AndrewRadev";
      repo = "switch.vim";
      rev = "4017a58f7ed8a2d76a288e36130affe8eb55e83a";
      hash = "sha256-oB8xWUPunEViZVCb7kyavuetw2lTM5IHpgNgcDW+DLA=";
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
  logger-nvim
  goto-preview
  codecompanion-nvim
  vim-elin

  # Language-specific plugins (Phase 6)
  cornelis
  nvim-hs-vim
  vim-textobj-user
  lean-nvim
  vim-matchup
  switch-vim
  tcomment_vim
  idris2-nvim

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
