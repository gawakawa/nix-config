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
- **Formatting** (Claude Code can execute):
  - Format Nix files: `nixfmt filename.nix`
  - Format Lua files: `stylua filename.lua`
  - Format all: `nix fmt` (uses treefmt-nix with nixfmt and stylua)
- **Flake Management**:
  - Update all inputs: `nix flake update`
  - Update specific input: `nix flake lock --update-input nixpkgs`
  - Check flake: `nix flake check`

## Architecture Overview
This is a unified Nix configuration supporting both NixOS (Linux) and Darwin (macOS):

- **Flake-based**: Uses `flake.nix` with flake-parts as entry point, inputs from nixpkgs, nix-darwin, home-manager, and treefmt-nix
- **Platform separation**: `darwin/` and `linux/` directories contain platform-specific system and home configurations
- **Home Manager integration**: User environment managed through platform-specific home.nix files importing shared program modules
- **Modular structure**: Programs organized in `programs/` directory with individual .nix files shared between platforms
- **Common packages**: `common-packages.nix` defines system packages available on both platforms

### Key Components
- `flake.nix`: Main entry point using flake-parts, defining nixosConfigurations (x86_64-linux) and darwinConfigurations (aarch64-darwin)
- `common-packages.nix`: Shared system packages for both platforms (git, direnv, neovim, terminal tools, etc.)
- `darwin/configuration.nix`: macOS system configuration with nix-darwin and Homebrew integration
- `linux/configuration.nix`: NixOS system configuration with GNOME and Hyprland support
- `darwin/home.nix` & `linux/home.nix`: Platform-specific home-manager configurations importing program modules
- `programs/`: Individual program configurations (neovim, git, zsh, wezterm, starship, direnv, hyprland) shared between platforms
- `nvim/`: Neovim configuration with Lua plugins managed by lazy.nvim

### Neovim Setup
- Uses lazy.nvim as plugin manager
- Configuration split between Nix (`programs/neovim.nix`) and Lua (`nvim/`)
- `programs/neovim.nix` creates a symlink to `nvim/` directory using `mkOutOfStoreSymlink`
- Extra packages: stack (for cornelis/Agda), babashka and clj-kondo (for elin/Clojure)
- Plugins organized in `nvim/lua/plugins/` with individual .lua files

## Directory Structure

```
~/.config/nix-config/
├── flake.nix                      # Main flake entry point using flake-parts
├── flake.lock                     # Flake input lockfile
├── common-packages.nix            # Shared system packages for both platforms
├── CLAUDE.md                      # This documentation file
├── AGENTS.md                      # Additional repository guidelines
├── darwin/                        # macOS-specific configuration
│   ├── configuration.nix          # Darwin system configuration with Homebrew
│   └── home.nix                   # Darwin-specific home-manager configuration
├── linux/                         # NixOS/Linux-specific configuration
│   ├── configuration.nix          # NixOS system configuration with GNOME/Hyprland
│   ├── hardware-configuration.nix # Hardware-specific NixOS configuration (auto-generated)
│   └── home.nix                   # Linux-specific home-manager configuration
├── programs/                      # User program configurations imported by platform-specific home.nix
│   ├── direnv.nix                 # Directory environment management
│   ├── git.nix                    # Git version control configuration
│   ├── hyprland.nix               # Hyprland Wayland compositor configuration (Linux only)
│   ├── neovim.nix                 # Neovim Nix configuration with symlink setup
│   ├── starship.nix               # Starship cross-shell prompt configuration
│   ├── wezterm.nix                # WezTerm terminal emulator package
│   ├── wezterm.lua                # WezTerm Lua runtime configuration
│   ├── zsh.nix                    # Zsh shell configuration with plugins
│   └── images/                    # Static assets (wallpapers, etc.)
└── nvim/                          # Neovim Lua configuration managed by lazy.nvim
    ├── init.lua                   # Main Neovim initialization file
    ├── lazy-lock.json             # Lazy.nvim plugin lockfile
    └── lua/                       # Lua configuration modules
        ├── config/                # Core Neovim configuration
        │   └── lazy.lua           # Lazy.nvim plugin manager setup
        └── plugins/               # Individual plugin configurations
            ├── auto_save.lua      # Automatic file saving
            ├── autopairs.lua      # Bracket/quote pairing
            ├── bufferline.lua     # Buffer tab line
            ├── codecompanion.lua  # Code companion AI integration
            ├── comment.lua        # Code commenting utilities
            ├── conform.lua        # Code formatting engine
            ├── copilot.lua        # GitHub Copilot integration
            ├── cornelis.lua       # Agda/Cornelis support
            ├── elin.lua           # Clojure/elin REPL integration
            ├── goto.lua           # Code navigation
            ├── idris2.lua         # Idris2 language support
            ├── lazygit.lua        # Git TUI integration
            ├── lean.lua           # Lean theorem prover support
            ├── lsp.lua            # Language Server Protocol config
            ├── lualine.lua        # Status line configuration
            ├── luasnip.lua        # Snippet engine
            ├── move.lua           # Line/block movement
            ├── neo_tree.lua       # File explorer
            ├── nvim_cmp.lua       # Completion engine
            ├── nvim_treesitter.lua# Syntax highlighting/parsing
            ├── surround.lua       # Text surrounding operations
            ├── telescope.lua      # Fuzzy finder
            ├── toggleterm.lua     # Terminal integration
            ├── tokyonight.lua     # Color scheme
            └── trouble.lua        # Diagnostics management
```

### Directory Organization Principles

- **Root Level**: Core flake configuration using flake-parts, with shared packages in common-packages.nix
- **Platform Separation**: `darwin/` and `linux/` contain platform-specific system and home configurations
- **Program Configurations**: `programs/` contains modular program configurations imported by platform-specific `home.nix` files
- **Editor Configuration**: `nvim/` is self-contained with lazy.nvim managing plugins and Lua handling runtime configuration
- **Separation of Concerns**: Nix handles package management and system integration, while Lua/shell configs handle program behavior
- **Symlink Approach**: Neovim config uses `mkOutOfStoreSymlink` to link directly to `nvim/` directory for easier development

## Code Style Guidelines

### Nix
- Use 2-space indentation, no tabs
- Follow RFC 166 style implemented by nixfmt-rfc-style
- Group and sort imports logically
- Keep module options organized and grouped by category
- Use descriptive names following Nix conventions (camelCase for attributes)
- Format all files with `nixfmt` before committing

### Lua
- Format with stylua (configured in treefmt)
- Follow existing patterns in `nvim/lua/plugins/`
- Each plugin gets its own file in `plugins/` directory
- Use descriptive variable names

### General
- Prefer declarative Nix options over imperative shell scripts
- Keep modules small and focused (one program per file in `programs/`)
- Document platform-specific behavior when relevant
- All configuration should be reproducible and declarative

## Commit Message Rules

- **Format**: Use gitmoji followed by concise English description (one line)
- **Examples**:
  - `✨ Add Hyprland configuration`
  - `🔧 Update nixpkgs to latest unstable`
  - `♻️ Refactor neovim plugin setup`
  - `📝 Update CLAUDE.md documentation`
- **NO signatures**: Never add Claude Code signatures, co-author lines, or any metadata
- **Command**: Search available emojis with `gitmoji -l`
- **Git config**: Default branch is "main", no rebase on pull (pull.rebase = false)

### Formatters by Language
- Nix: nixfmt-rfc-style (via `nixfmt` or `nix fmt`)
- Lua: stylua (via `stylua` or `nix fmt`)
- TypeScript/JavaScript: deno_fmt
- Rust: rustfmt
- Haskell: fourmolu
- PureScript: purs_tidy

## Platform-Specific Notes

### Darwin (macOS)
- Uses Homebrew for casks (GUI apps) and some system tools
- Darwin-specific packages in `darwin/configuration.nix`
- Nix daemon managed by Determinate Nix (`nix.enable = false`)
- System architecture: aarch64-darwin (Apple Silicon)

### Linux (NixOS)
- GNOME desktop environment with GDM display manager
- Hyprland Wayland compositor available as alternative
- fcitx5 with mozc for Japanese input
- System architecture: x86_64-linux
- Audio via PipeWire