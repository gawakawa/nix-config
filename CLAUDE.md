# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Test Commands

**IMPORTANT**: Claude Code cannot execute system rebuild commands (`nixos-rebuild switch`, `darwin-rebuild switch`, `home-manager switch`) as these require elevated privileges and system-level changes. These commands must be run manually by the user after Claude Code makes configuration changes.

- **NixOS/Linux** (user must execute):
  - Build and switch: `sudo nixos-rebuild switch --flake ".#nixos" --impure`
  - Test configuration: `sudo nixos-rebuild dry-activate --flake ".#nixos" --impure`
  - Build only: `sudo nixos-rebuild build --flake ".#nixos" --impure`
- **Darwin/macOS** (user must execute):
  - Build and switch: `darwin-rebuild switch --flake ".#mac" --impure`
  - Build only: `darwin-rebuild build --flake ".#mac" --impure`
- **Home Manager** (user must execute):
  - Rebuild user environment: `home-manager switch --flake ".#$USER@$(hostname)"`
- **Development Environments**:
  - Enter language environment: `nix develop ./lang/[language]/`
  - Build language flake: `nix build ./lang/[language]/`
- **Formatting** (Claude Code can execute):
  - Format Nix files: `nixfmt filename.nix`
  - Format Lua files: `stylua filename.lua`

## Architecture Overview
This is a unified Nix configuration supporting both NixOS (Linux) and Darwin (macOS):

- **Flake-based**: Uses `flake.nix` as the entry point with inputs from nixpkgs, nix-darwin, and home-manager
- **Platform separation**: `darwin/` and `linux/` directories contain platform-specific system and home configurations
- **Home Manager integration**: User environment managed through platform-specific home.nix files importing shared program modules
- **Modular structure**: Programs organized in `programs/` directory with individual .nix files shared between platforms
- **Development environments**: Isolated language-specific development environments in `lang/` as separate flakes

### Key Components
- `flake.nix`: Main entry point defining nixosConfigurations and darwinConfigurations
- `darwin/configuration.nix`: macOS system configuration using nix-darwin
- `linux/configuration.nix`: NixOS system configuration 
- `darwin/home.nix` & `linux/home.nix`: Platform-specific home-manager configurations importing program modules
- `programs/`: Individual program configurations (neovim, git, zsh, etc.) shared between platforms
- `lang/`: Isolated development environments as separate flakes for different programming languages
- `nvim/`: Neovim configuration with Lua plugins managed by lazy.nvim

### Neovim Setup
- Uses lazy.nvim as plugin manager
- Configuration split between Nix (`programs/neovim.nix`) and Lua (`nvim/`)
- Platform-specific handling: Linux copies files, Darwin creates symlinks
- Plugins organized in `nvim/lua/plugins/` with individual .lua files

## Directory Structure

```
/Users/iota/.config/nix-config/
├── flake.nix                      # Main flake entry point with nixosConfigurations and darwinConfigurations
├── flake.lock                     # Flake input lockfile
├── CLAUDE.md                      # This documentation file
├── darwin/                        # macOS-specific configuration
│   ├── configuration.nix          # Darwin system configuration
│   └── home.nix                   # Darwin-specific home-manager configuration
├── linux/                         # NixOS/Linux-specific configuration
│   ├── configuration.nix          # NixOS system configuration
│   ├── hardware-configuration.nix # Hardware-specific NixOS configuration (auto-generated)
│   └── home.nix                   # Linux-specific home-manager configuration
├── lang/                          # Language-specific development environments
│   ├── go/                        # Go development flake with isolated environment
│   │   ├── flake.nix              # Go toolchain, libraries, and development tools
│   │   └── flake.lock             # Pinned Go environment dependencies
│   ├── idris2/                    # Idris2 development flake for functional programming
│   │   ├── flake.nix              # Idris2 compiler and related tools
│   │   └── flake.lock             # Pinned Idris2 environment dependencies
│   ├── lean/                      # Lean theorem prover development environment
│   │   ├── flake.nix              # Lean 4 compiler and mathematics libraries
│   │   └── flake.lock             # Pinned Lean environment dependencies
│   ├── purescript/                # PureScript development flake for functional web programming
│   │   ├── flake.nix              # PureScript compiler, spago, and Node.js tools
│   │   └── flake.lock             # Pinned PureScript environment dependencies
│   ├── rust/                      # Rust development flake with cargo ecosystem
│   │   ├── flake.nix              # Rust toolchain, cargo, and development utilities
│   │   └── flake.lock             # Pinned Rust environment dependencies
│   └── typescript/                # TypeScript/Node.js development environment
│       ├── flake.nix              # TypeScript compiler, Node.js, and package managers
│       └── flake.lock             # Pinned TypeScript environment dependencies
├── programs/                      # User program configurations imported by platform-specific home.nix
│   ├── direnv.nix                 # Directory environment management for automatic shell switching
│   ├── git.nix                    # Git version control configuration with aliases and settings
│   ├── hyprland.nix               # Hyprland Wayland compositor configuration (Linux only)
│   ├── neovim.nix                 # Neovim Nix configuration handling package management
│   ├── starship.nix               # Starship cross-shell prompt configuration
│   ├── wezterm.nix                # WezTerm terminal emulator Nix package configuration
│   ├── wezterm.lua                # WezTerm Lua runtime configuration for keybindings and appearance
│   ├── zsh.nix                    # Zsh shell configuration with plugins and aliases
│   └── images/                    # Static assets and media files
│       └── shami_momo.JPG         # Wallpaper image or UI asset
└── nvim/                          # Neovim Lua configuration managed separately from Nix
    ├── init.lua                   # Main Neovim initialization file loading all configurations
    ├── init.lua.backup            # Backup of previous init configuration
    ├── lazy-lock.json             # Lazy.nvim plugin lockfile ensuring reproducible plugin versions
    └── lua/                       # Lua configuration modules organized by functionality
        ├── config/                # Core Neovim configuration
        │   └── lazy.lua           # Lazy.nvim plugin manager setup and configuration
        └── plugins/               # Individual plugin configurations with isolated concerns
            ├── auto_save.lua      # Automatic file saving functionality
            ├── autopairs.lua      # Automatic bracket/quote pairing
            ├── bufferline.lua     # Buffer tab line for better file navigation
            ├── comment.lua        # Code commenting utilities with language awareness
            ├── conform.lua        # Code formatting engine with multiple formatter support
            ├── copilot.lua        # GitHub Copilot AI code completion integration
            ├── goto.lua           # Enhanced code navigation and jumping capabilities
            ├── idris2.lua         # Idris2 language support and REPL integration
            ├── lean.lua           # Lean theorem prover support with goal display
            ├── lsp.lua            # Language Server Protocol configuration for multiple languages
            ├── lualine.lua        # Customizable status line with git and diagnostic info
            ├── luasnip.lua        # Snippet engine for code template expansion
            ├── move.lua           # Line and block movement utilities
            ├── neo_tree.lua       # File explorer tree view with git integration
            ├── nvim_cmp.lua       # Completion engine with multiple sources
            ├── nvim_treesitter.lua# Syntax highlighting, parsing, and text objects
            ├── surround.lua       # Text surrounding operations (quotes, brackets, tags)
            ├── telescope.lua      # Fuzzy finder for files, buffers, and project search
            ├── toggleterm.lua     # Terminal integration with floating and split support
            ├── tokyonight.lua     # Color scheme configuration with variants
            └── trouble.lua        # Diagnostics and quickfix list management
```

### Directory Organization Principles

- **Root Level**: Core flake configuration and documentation
- **Platform Separation**: `darwin/` and `linux/` contain platform-specific system and home configurations
- **Development Environments**: `lang/` provides isolated, reproducible development environments as separate flakes
- **Program Configurations**: `programs/` contains modular program configurations imported by platform-specific `home.nix` files
- **Editor Configuration**: `nvim/` is self-contained with lazy.nvim managing plugins and Lua handling runtime configuration
- **Separation of Concerns**: Nix handles package management and system integration, while language-specific runtime configs (Lua, shell configs) handle behavior
- **Reproducibility**: Each language environment and the main system are pinned with lock files for consistent builds across machines

## Code Style Guidelines
- **Nix**: Use 2-space indentation. Follow the RFC style implemented by nixfmt.
- **Lua**: Use stylua for formatting, follow existing convention in similar files.
- **Git**: Default branch name is "main", no rebase on pull.
- **Formatters**:
  - Nix: nixfmt
  - Lua: stylua
  - TypeScript/JavaScript: deno_fmt
  - Rust: rustfmt
  - Haskell: fourmolu
  - PureScript: purs_tidy
- **Naming**: Use descriptive names following the conventions of each language.
- **Error Handling**: Follow idiomatic error handling for each language.
- **Imports**: Group imports logically, similar to existing files.

**IMPORTANT**: After modifying any file, always run the appropriate formatter:
- For .nix files: `nixfmt filename.nix`
- For .lua files: `stylua filename.lua`
- For other files: Use the corresponding formatter listed above

All changes should align with the NixOS functional and declarative paradigm.