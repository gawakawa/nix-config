# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Test Commands

**IMPORTANT**: Claude Code cannot execute system rebuild commands (`nixos-rebuild switch`, `darwin-rebuild switch`, `home-manager switch`) as these require elevated privileges and system-level changes. These commands must be run manually by the user after Claude Code makes configuration changes.

- **NixOS/Linux** (user must execute):
  - Build and switch: `sudo nixos-rebuild switch --flake ".#nixos"`
  - Test configuration: `sudo nixos-rebuild dry-activate --flake ".#nixos"`
  - Build only: `sudo nixos-rebuild build --flake ".#nixos"`
  - Quick rebuild (uses alias `nrs` from zsh.nix): `nrs`
- **Darwin/macOS** (user must execute):
  - Build and switch: `darwin-rebuild switch --flake ".#mac"`
  - Build only: `darwin-rebuild build --flake ".#mac"`
  - Quick rebuild (uses alias `drs` from zsh.nix): `drs`
- **Home Manager** (user must execute):
  - Rebuild user environment: `home-manager switch --flake ".#$USER@$(hostname)"`
- **Formatting** (Claude Code can execute):
  - Format all: `nix fmt` (uses treefmt-nix with nixfmt-rfc-style and stylua)
- **Flake Management**:
  - Update all inputs: `nix flake update`
  - Update specific input: `nix flake lock --update-input nixpkgs`
  - Check flake: `nix flake check`
  - Show outputs: `nix flake show`

## MCP-NixOS Tools

This environment has access to mcp-nixos, a Model Context Protocol server that provides tools for searching and exploring NixOS packages, Home Manager options, and Darwin (macOS) configurations.

### Available Search Tools

**NixOS Packages & Options:**
- `mcp__nixos__nixos_search(query, search_type, channel, limit)` - Search packages, options, or programs
- `mcp__nixos__nixos_info(name, type, channel)` - Get detailed information about a package or option
- `mcp__nixos__nixos_channels()` - List available NixOS channels
- `mcp__nixos__nixos_stats(channel)` - Get statistics about packages and options

**Package Version History (NixHub):**
- `mcp__nixos__nixhub_package_versions(package_name, limit)` - Get version history with commit hashes for reproducible builds
- `mcp__nixos__nixhub_find_version(package_name, version)` - Find specific package version with nixpkgs commit hash

**Home Manager Configuration:**
- `mcp__nixos__home_manager_search(query, limit)` - Search through 4K+ Home Manager options
- `mcp__nixos__home_manager_info(name)` - Get detailed information about a specific Home Manager option
- `mcp__nixos__home_manager_options_by_prefix(option_prefix)` - Browse options by prefix (e.g., 'programs.git')
- `mcp__nixos__home_manager_list_options()` - List all Home Manager categories
- `mcp__nixos__home_manager_stats()` - Get Home Manager statistics

**Darwin/macOS Configuration:**
- `mcp__nixos__darwin_search(query, limit)` - Search through 1K+ macOS-specific options
- `mcp__nixos__darwin_info(name)` - Get detailed information about a Darwin option
- `mcp__nixos__darwin_options_by_prefix(option_prefix)` - Browse Darwin options by prefix (e.g., 'system.defaults')
- `mcp__nixos__darwin_list_options()` - List all Darwin categories
- `mcp__nixos__darwin_stats()` - Get Darwin configuration statistics

**Flake Discovery:**
- `mcp__nixos__nixos_flakes_search(query, limit)` - Search community flakes
- `mcp__nixos__nixos_flakes_stats()` - Get flake ecosystem statistics

## Architecture Overview

This is a unified Nix configuration supporting both NixOS (Linux) and Darwin (macOS):

- **Flake-based**: Uses `flake.nix` with flake-parts as entry point, inputs from nixpkgs, nix-darwin, home-manager, and treefmt-nix
- **Platform separation**: `darwin/` and `linux/` directories contain platform-specific system and home configurations
- **Home Manager integration**: User environment managed through platform-specific home.nix files importing shared program modules
- **Modular structure**: Programs organized in `programs/` directory with individual .nix files shared between platforms
- **Common packages**: `common-packages.nix` defines system packages available on both platforms
- **External Neovim**: Neovim configuration lives in `~/.config/nvim/` as a separate flake, invoked via `nix run ~/.config/nvim --` alias

### Key Components

- `flake.nix`: Main entry point using flake-parts, defining nixosConfigurations (x86_64-linux) and darwinConfigurations (aarch64-darwin)
- `common-packages.nix`: Shared system packages for both platforms (git, direnv, terminal tools, etc.)
- `darwin/configuration.nix`: macOS system configuration with nix-darwin and Homebrew integration
- `darwin/home.nix`: Darwin home-manager configuration importing shared program modules
- `linux/configuration.nix`: NixOS system configuration with Hyprland as primary window manager
- `linux/hardware-configuration.nix`: Hardware-specific configuration (auto-generated, do not edit manually)
- `linux/home.nix`: Linux home-manager configuration importing shared program modules plus Hyprland/Waybar
- `programs/`: Individual program configurations shared between platforms
  - Single-file modules: `git.nix`, `zsh.nix`, `starship.nix`, `direnv.nix`
  - Linux-specific: `hyprland.nix`, `waybar.nix`
  - Directory module: `wezterm/` with `default.nix` as entry point

### Neovim Setup

Neovim is managed **outside** this repository:
- Configuration location: `~/.config/nvim/` (separate flake repository)
- Access via zsh alias: `nvim = "nix run ~/.config/nvim --"` defined in `programs/zsh.nix:7`
- Shortcut alias: `v = "nvim"` for quick access
- This allows independent versioning and updates without affecting system configuration

## Directory Structure

```
~/.config/nix-config/
├── flake.nix                      # Main entry point using flake-parts
├── flake.lock                     # Locked dependency versions
├── common-packages.nix            # Shared system packages for both platforms
├── darwin/                        # macOS-specific configuration
│   ├── configuration.nix          # Darwin system configuration with Homebrew
│   └── home.nix                   # Darwin home-manager configuration
├── linux/                         # NixOS/Linux-specific configuration
│   ├── configuration.nix          # NixOS system configuration with Hyprland
│   ├── hardware-configuration.nix # Hardware-specific configuration (auto-generated)
│   └── home.nix                   # Linux home-manager configuration
└── programs/                      # Shared program configurations
    ├── direnv.nix                 # direnv configuration
    ├── git.nix                    # Git configuration
    ├── hyprland.nix               # Hyprland window manager (Linux only)
    ├── starship.nix               # Starship prompt
    ├── waybar.nix                 # Waybar status bar (Linux only)
    ├── zsh.nix                    # Zsh shell with aliases and prezto
    └── wezterm/                   # WezTerm terminal configuration
        ├── default.nix            # Entry point
        ├── wezterm.lua            # WezTerm Lua configuration
        └── images/                # Image assets
```

### Directory Organization Principles

- **Root Level**: Core flake configuration using flake-parts, with shared packages in common-packages.nix
- **Platform Separation**: `darwin/` and `linux/` contain platform-specific system and home configurations
- **Program Configurations**: `programs/` contains modular configurations imported by platform-specific `home.nix` files
- **Module Types**: Single-file `.nix` modules for simple configs; directory-based modules with `default.nix` for complex programs
- **Separation of Concerns**: Nix handles package management and system integration, while Lua/shell configs handle program behavior
- **Linux-specific Modules**: `hyprland.nix` and `waybar.nix` are only imported in `linux/home.nix`

## Code Style Guidelines

### Nix
- Use 2-space indentation, no tabs
- Follow RFC 166 style implemented by nixfmt-rfc-style
- Group and sort imports logically
- Keep module options organized and grouped by category
- Use descriptive names following Nix conventions (camelCase for attributes)
- Format with `nix fmt` before committing

### Lua
- Format with stylua (configured in treefmt)
- Follow existing patterns in program configurations
- Use descriptive variable names

### General
- Prefer declarative Nix options over imperative shell scripts
- Keep modules small and focused (one program per file in `programs/`)
- Document platform-specific behavior when relevant
- All configuration should be reproducible and declarative

### Formatters by Language
- Nix: nixfmt-rfc-style (via `nix fmt`)
- Lua: stylua (via `nix fmt`)

## Platform-Specific Notes

### Darwin (macOS)
- Uses Homebrew for casks (GUI apps) and some system tools
- Darwin-specific packages in `darwin/configuration.nix`
- Nix daemon managed by Determinate Nix (`nix.enable = false`)
- System architecture: aarch64-darwin (Apple Silicon)
- Homebrew casks: Amethyst (window manager), Claude
- Mac App Store apps: LINE, Goodnotes 6, Kindle

### Linux (NixOS)
- **Window Manager**: Hyprland (Wayland compositor) configured in `programs/hyprland.nix`
- **Status Bar**: Waybar configured in `programs/waybar.nix`
- **Desktop Environment**: GNOME and GDM are disabled (`services.displayManager.gdm.enable = false`, `services.desktopManager.gnome.enable = false`)
- **Input Method**: fcitx5 with mozc for Japanese input
- **Locale**: ja_JP.UTF-8 (Japanese locale throughout system)
- **Audio**: PipeWire with ALSA compatibility
- **System architecture**: x86_64-linux
- **Boot**: systemd-boot with EFI support
- **Timezone**: Asia/Tokyo
- **Programs**: nix-ld enabled for running unpatched binaries

## Shell Aliases

The following convenient aliases are defined in `programs/zsh.nix`:

- `v` → `nvim` - Quick Neovim access
- `nvim` → `nix run ~/.config/nvim --` - Run Neovim from separate flake
- `c` → `claude` - Quick Claude Code access
- `ls` → `ls -A` - Show hidden files by default
- `find` → `fd` - Use fd instead of find
- `nrs` → Full NixOS rebuild switch command with impure flag
- `drs` → Full Darwin rebuild switch command

## Binary Cache Configuration

The flake is configured to use nix-community binary cache:
- Substituter: `https://nix-community.cachix.org`
- Public key: `nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=`

Linux configuration also uses IOG cache for Haskell packages:
- Substituter: `https://cache.iog.io`
- Public key: `hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=`
