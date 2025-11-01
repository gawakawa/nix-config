# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Test Commands

**IMPORTANT**: Claude Code cannot execute system rebuild commands (`nixos-rebuild switch`, `darwin-rebuild switch`, `home-manager switch`) as these require elevated privileges and system-level changes. These commands must be run manually by the user after Claude Code makes configuration changes.

- **NixOS/Linux** (user must execute):
  - Build and switch: `sudo nixos-rebuild switch --flake ".#nixos"`
  - Test configuration: `sudo nixos-rebuild dry-activate --flake ".#nixos"`
  - Build only: `sudo nixos-rebuild build --flake ".#nixos"`
- **Darwin/macOS** (user must execute):
  - Build and switch: `darwin-rebuild switch --flake ".#mac"`
  - Build only: `darwin-rebuild build --flake ".#mac"`
- **Home Manager** (user must execute):
  - Rebuild user environment: `home-manager switch --flake ".#$USER@$(hostname)"`
- **Formatting** (Claude Code can execute):
  - Format all: `nix fmt` (uses treefmt-nix with nixfmt and stylua)
- **Flake Management**:
  - Update all inputs: `nix flake update`
  - Update specific input: `nix flake lock --update-input nixpkgs`
  - Check flake: `nix flake check`

## MCP-NixOS Tools

This environment has access to mcp-nixos, a Model Context Protocol server that provides tools for searching and exploring NixOS packages, Home Manager options, and Darwin (macOS) configurations. These tools are integrated with Claude Code and available automatically.

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
- `mcp__nixos__home_manager_list_options()` - List all 131 Home Manager categories
- `mcp__nixos__home_manager_stats()` - Get Home Manager statistics

**Darwin/macOS Configuration:**
- `mcp__nixos__darwin_search(query, limit)` - Search through 1K+ macOS-specific options
- `mcp__nixos__darwin_info(name)` - Get detailed information about a Darwin option
- `mcp__nixos__darwin_options_by_prefix(option_prefix)` - Browse Darwin options by prefix (e.g., 'system.defaults')
- `mcp__nixos__darwin_list_options()` - List all 21 Darwin categories
- `mcp__nixos__darwin_stats()` - Get Darwin configuration statistics

**Flake Discovery:**
- `mcp__nixos__nixos_flakes_search(query, limit)` - Search community flakes
- `mcp__nixos__nixos_flakes_stats()` - Get flake ecosystem statistics

### Usage Examples

**Finding packages:**
```
Search for a package: mcp__nixos__nixos_search("neovim")
Get package details: mcp__nixos__nixos_info("neovim", "package")
Find specific version: mcp__nixos__nixhub_find_version("neovim", "0.9.5")
```

**Configuring Home Manager:**
```
Search options: mcp__nixos__home_manager_search("git")
Get option details: mcp__nixos__home_manager_info("programs.git.enable")
Browse by prefix: mcp__nixos__home_manager_options_by_prefix("programs.git")
```

**Configuring Darwin/macOS:**
```
Search options: mcp__nixos__darwin_search("dock")
Get option details: mcp__nixos__darwin_info("system.defaults.dock.autohide")
Browse by prefix: mcp__nixos__darwin_options_by_prefix("system.defaults.dock")
```

### Key Features
- Access to 130K+ NixOS packages and 22K+ configuration options
- 4K+ Home Manager settings for user environment configuration
- 1K+ macOS/Darwin-specific configuration options
- Historical package versions with nixpkgs commit hashes for reproducibility
- Real-time search with no local caching required

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
- `programs/`: Individual program configurations shared between platforms
  - Single-file modules: `git.nix`, `zsh.nix`, `starship.nix`, `direnv.nix`, `hyprland.nix`
  - Directory modules: `nvim/` and `wezterm/` with `default.nix` as entry point

### Neovim Setup
- Uses lazy.nvim as plugin manager
- Configuration in `programs/nvim/` directory with `default.nix` (entry point), `wrapper.nix` (package wrapper), and `config.nix` (configuration)
- Lua configuration files: `init.lua`, `lazy-lock.json`, and `lua/` directory for modular configs
- Extra packages wrapped via `wrapper.nix`: ripgrep and fd for telescope
- Plugins organized in `plugins/` directory with individual .lua files

## Directory Structure

```
~/.config/nix-config/
├── flake.nix                      # Main entry point using flake-parts
├── common-packages.nix            # Shared system packages for both platforms
├── darwin/                        # macOS-specific configuration
│   ├── configuration.nix          # Darwin system configuration with Homebrew
│   └── home.nix                   # Darwin home-manager configuration
├── linux/                         # NixOS/Linux-specific configuration
│   ├── configuration.nix          # NixOS system configuration with GNOME/Hyprland
│   ├── hardware-configuration.nix # Hardware-specific configuration (auto-generated)
│   └── home.nix                   # Linux home-manager configuration
└── programs/                      # Shared program configurations
    ├── *.nix                      # Single-file modules (git, zsh, starship, direnv, hyprland)
    ├── nvim/                      # Neovim configuration directory
    │   ├── default.nix            # Entry point
    │   ├── wrapper.nix            # Package wrapper with extra tools
    │   ├── init.lua               # Main Neovim initialization
    │   ├── lua/                   # Lua configuration modules
    │   └── plugins/               # Individual plugin configurations
    └── wezterm/                   # WezTerm configuration directory
        ├── default.nix            # Entry point
        └── wezterm.lua            # WezTerm Lua configuration
```

### Directory Organization Principles

- **Root Level**: Core flake configuration using flake-parts, with shared packages in common-packages.nix
- **Platform Separation**: `darwin/` and `linux/` contain platform-specific system and home configurations
- **Program Configurations**: `programs/` contains modular configurations imported by platform-specific `home.nix` files
- **Module Types**: Single-file `.nix` modules for simple configs; directory-based modules with `default.nix` for complex programs
- **Separation of Concerns**: Nix handles package management and system integration, while Lua/shell configs handle program behavior

## Code Style Guidelines

### Nix
- Use 2-space indentation, no tabs
- Follow RFC 166 style implemented by nixfmt-rfc-style
- Group and sort imports logically
- Keep module options organized and grouped by category
- Use descriptive names following Nix conventions (camelCase for attributes)

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

### Formatters by Language
- Nix: nixfmt-rfc-style (via `nix fmt`)
- Lua: stylua (via `nix fmt`)

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
