# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

**IMPORTANT**: Claude Code cannot execute system rebuild commands as these require elevated privileges. These must be run manually by the user after configuration changes.

- **NixOS** (user must execute): `sudo nixos-rebuild switch --flake ".#nixos" --accept-flake-config --impure`
- **Darwin** (user must execute): `darwin-rebuild switch --flake ".#mac" --accept-flake-config`
- **Format code**: `nix fmt` (uses treefmt-nix with nixfmt-rfc-style and stylua)
- **Check flake**: `nix flake check`
- **Update inputs**: `nix flake update` or `nix flake lock --update-input <name>`

## Development Shell

Enter the dev shell with `nix develop` to get pre-commit hooks:
- **treefmt**: Format check for Nix and Lua
- **statix**: Nix linter (ignores hardware-configuration.nix)
- **deadnix**: Unused code detection (ignores hardware-configuration.nix)
- **actionlint**: GitHub Actions linter
- **selene**: Lua linter

## CI Pipeline

CI runs on push to main and PRs (`.github/workflows/ci.yml`):
1. Format check: `nix fmt -- --ci`
2. Flake check: `nix flake check`
3. Build NixOS/Darwin configuration

Builds are cached via Cachix (`gawakawa` cache).

## Architecture Overview

Unified Nix configuration for NixOS (x86_64-linux) and Darwin (aarch64-darwin):

- **flake.nix**: Entry point using flake-parts, defines `nixosConfigurations.nixos` and `darwinConfigurations.mac`
- **common-packages.nix**: Shared system packages for both platforms
- **darwin/**: macOS system config (`configuration.nix`) and home-manager (`home.nix`)
- **linux/**: NixOS system config (`configuration.nix`, `hardware-configuration.nix`) and home-manager (`home.nix`)
- **programs/**: Shared program modules imported by platform-specific `home.nix` files

### Program Modules

Located in `programs/`, imported by both platforms unless noted:
- `git.nix`, `zsh.nix`, `starship.nix`, `direnv.nix`, `gpg.nix` - Cross-platform
- `hyprland.nix`, `waybar.nix` - Linux only (Wayland compositor and status bar)
- `wezterm/` - Directory module with `default.nix` entry point and `wezterm.lua`

### External Dependencies

- **Neovim**: Managed separately at `~/.config/nvim/` (own flake), accessed via alias `nvim = "nix run ~/.config/nvim --"`
- **hardware-configuration.nix**: Auto-generated, do not edit manually

## Platform Notes

### Darwin (macOS)
- Homebrew integration for GUI apps (casks) in `darwin/configuration.nix`
- Nix daemon managed by Determinate Nix (`nix.enable = false`)

### Linux (NixOS)
- Hyprland as Wayland compositor with Waybar status bar
- fcitx5 with mozc for Japanese input (ja_JP.UTF-8 locale)
- PipeWire audio, systemd-boot, nix-ld enabled

## Key Aliases (from programs/zsh.nix)

- `nrs` - NixOS rebuild switch with impure flag
- `drs` - Darwin rebuild switch
- `v` / `nvim` - Run Neovim from separate flake
- `flake-init <template>` - Initialize from gawakawa/flake-templates
