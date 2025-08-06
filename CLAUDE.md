# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Test Commands
- Build NixOS configuration: `sudo nixos-rebuild switch --flake ".#nixos" --impure`
- Build Darwin configuration: `darwin-rebuild build --flake ".#mac" --impure`
- Check NixOS configuration: `sudo nixos-rebuild dry-activate --flake ".#nixos" --impure`
- Format Nix files: `nixfmt-rfc-style filename.nix`
- Format Lua files: `stylua filename.lua`
- Rebuild home-manager: `home-manager switch`

## Architecture Overview
This is a unified Nix configuration supporting both NixOS (Linux) and Darwin (macOS):

- **Flake-based**: Uses `flake.nix` as the entry point with inputs from nixpkgs, nix-darwin, and home-manager
- **Cross-platform**: Conditional logic in `configuration.nix` handles platform-specific settings
- **Home Manager integration**: User environment managed through home-manager with shared `home.nix`
- **Modular structure**: Programs organized in `programs/` directory with individual .nix files

### Key Components
- `flake.nix`: Main entry point defining nixosConfigurations and darwinConfigurations
- `configuration.nix`: Platform-specific system configuration with conditional Darwin/NixOS logic
- `home.nix`: User environment configuration importing program modules
- `programs/`: Individual program configurations (neovim, git, zsh, etc.)
- `programs/nvim/`: Neovim configuration with Lua plugins managed by lazy.nvim

### Neovim Setup
- Uses lazy.nvim as plugin manager
- Configuration split between Nix (`programs/neovim.nix`) and Lua (`programs/nvim/`)
- Platform-specific handling: Linux copies files, Darwin creates symlinks
- Plugins organized in `programs/nvim/lua/plugins/` with individual .lua files

## Directory Structure

```
/home/iota/.config/nix-config/
├── flake.nix                      # Main flake entry point with nixosConfigurations and darwinConfigurations
├── flake.lock                     # Flake input lockfile
├── configuration.nix              # System configuration with platform-specific conditionals
├── hardware-configuration.nix     # Hardware-specific NixOS configuration
├── home.nix                       # Home Manager configuration importing program modules
├── CLAUDE.md                      # This documentation file
├── lang/                          # Language-specific development environments
│   ├── go/                        # Go development flake
│   │   ├── flake.nix
│   │   └── flake.lock
│   ├── idris2/                    # Idris2 development flake
│   │   ├── flake.nix
│   │   └── flake.lock
│   ├── lean/                      # Lean theorem prover development flake
│   │   ├── flake.nix
│   │   └── flake.lock
│   ├── purescript/                # PureScript development flake
│   │   ├── flake.nix
│   │   └── flake.lock
│   ├── rust/                      # Rust development flake
│   │   ├── flake.nix
│   │   └── flake.lock
│   └── typescript/                # TypeScript development flake
│       ├── flake.nix
│       └── flake.lock
└── programs/                      # User program configurations
    ├── direnv.nix                 # Directory environment management
    ├── git.nix                    # Git configuration
    ├── hyprland.nix               # Hyprland window manager configuration
    ├── neovim.nix                 # Neovim Nix configuration
    ├── starship.nix               # Starship prompt configuration
    ├── wezterm.nix                # WezTerm terminal emulator Nix config
    ├── wezterm.lua                # WezTerm Lua configuration
    ├── zsh.nix                    # Zsh shell configuration
    ├── images/                    # Static assets
    │   └── shami_momo.JPG         # Wallpaper or UI image
    └── nvim/                      # Neovim Lua configuration
        ├── init.lua               # Main Neovim init file
        ├── init.lua.backup        # Backup of init configuration
        ├── lazy-lock.json         # Lazy.nvim plugin lockfile
        └── lua/                   # Lua configuration modules
            ├── config/            # Core configuration
            │   └── lazy.lua       # Lazy.nvim setup
            └── plugins/           # Individual plugin configurations
                ├── auto_save.lua       # Auto-save functionality
                ├── autopairs.lua       # Auto-pairing brackets/quotes
                ├── bufferline.lua      # Buffer tab line
                ├── comment.lua         # Code commenting
                ├── conform.lua         # Code formatting
                ├── copilot.lua         # GitHub Copilot integration
                ├── goto.lua            # Code navigation
                ├── idris2.lua          # Idris2 language support
                ├── lean.lua            # Lean theorem prover support
                ├── lsp.lua             # Language Server Protocol
                ├── lualine.lua         # Status line
                ├── luasnip.lua         # Snippet engine
                ├── move.lua            # Line/block movement
                ├── neo_tree.lua        # File explorer
                ├── nvim_cmp.lua        # Completion engine
                ├── nvim_treesitter.lua # Syntax highlighting/parsing
                ├── surround.lua        # Text surrounding operations
                ├── telescope.lua       # Fuzzy finder
                ├── toggleterm.lua      # Terminal integration
                ├── tokyonight.lua      # Color scheme
                └── trouble.lua         # Diagnostics list
```

### Directory Organization Principles

- **Root Level**: Core flake and system configuration files
- **lang/**: Isolated development environments as separate flakes for different programming languages
- **programs/**: Modular program configurations imported by `home.nix`
- **programs/nvim/**: Self-contained Neovim configuration with lazy.nvim plugin management
- **Separation of Concerns**: Nix handles package management and system integration, Lua handles runtime configuration

## Code Style Guidelines
- **Nix**: Use 2-space indentation. Follow the RFC style implemented by nixfmt-rfc-style.
- **Lua**: Use stylua for formatting, follow existing convention in similar files.
- **Git**: Default branch name is "main", no rebase on pull.
- **Formatters**:
  - Nix: nixfmt-rfc-style
  - Lua: stylua
  - TypeScript/JavaScript: deno_fmt
  - Rust: rustfmt
  - Haskell: fourmolu
  - PureScript: purs_tidy
- **Naming**: Use descriptive names following the conventions of each language.
- **Error Handling**: Follow idiomatic error handling for each language.
- **Imports**: Group imports logically, similar to existing files.

All changes should align with the NixOS functional and declarative paradigm.