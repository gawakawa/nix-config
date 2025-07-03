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