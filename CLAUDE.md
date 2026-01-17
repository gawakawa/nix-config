# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

**IMPORTANT**: Claude Code cannot execute system rebuild commands as these require elevated privileges. These must be run manually by the user after configuration changes.

- **NixOS** (user must execute): `sudo nixos-rebuild switch --flake ".#nixos" --accept-flake-config --impure`
- **Darwin** (user must execute): `sudo darwin-rebuild switch --flake ".#mac"`
- **Format code**: `nix fmt` (uses treefmt-nix with nixfmt-rfc-style, stylua, shfmt)
- **Check flake**: `nix flake check`
- **Update inputs**: `nix flake update` or `nix flake lock --update-input <name>`

## Development Shell

Enter the dev shell with `nix develop` to get pre-commit hooks:
- **treefmt**: Format check for Nix, Lua, and Shell scripts
- **statix**: Nix linter (ignores hardware-configuration.nix)
- **deadnix**: Unused code detection (ignores hardware-configuration.nix)
- **selene**: Lua linter
- **shellcheck**: Shell script linter

The dev shell also generates `.mcp.json` with NixOS MCP server configuration.

## CI Pipeline

CI runs on push to main and PRs (`.github/workflows/ci.yml`):
1. Flake check: `nix flake check` (includes format check via treefmt)
2. Build NixOS/Darwin configuration

Builds are cached via Cachix (`gawakawa` cache).

## Architecture Overview

Unified Nix configuration for NixOS (x86_64-linux) and Darwin (aarch64-darwin):

- **flake.nix**: Entry point using flake-parts, defines `nixosConfigurations.nixos` and `darwinConfigurations.mac`

```
.
├── flake.nix
├── home/       # Home Manager configurations (per-host)
│   ├── mac/
│   └── nixos/
├── hosts/      # System configurations (per-host)
│   ├── mac/
│   └── nixos/
├── lib/        # Utility functions
└── profiles/   # Host-independent shared configurations
    ├── home/   #   Shared Home Manager modules
    └── hosts/  #   Shared host modules
```

### Program Modules

Located in `profiles/home/`, each module is a directory with `default.nix` (cross-platform):
- `git/`, `zsh/`, `starship/`, `direnv/`, `gpg/` - Shell and development tools
- `wezterm/` - Terminal emulator with `wezterm.lua` config
- `claude/` - Claude Code configuration with agents and settings

Linux-only modules in `home/nixos/`:
- `hyprland/` - Wayland compositor
- `waybar/` - Status bar

### External Dependencies

- **Neovim**: Managed separately at `~/.config/nvim/` (own flake), accessed via alias `nvim = "nix run ~/.config/nvim --"`
- **hardware-configuration.nix**: Auto-generated, do not edit manually

## Platform Notes

### Darwin (macOS)
- Homebrew integration for GUI apps (casks) in `hosts/darwin/configuration.nix`
- Nix daemon managed by Determinate Nix (`nix.enable = false`)

### Linux (NixOS)
- Hyprland as Wayland compositor with Waybar status bar
- fcitx5 with mozc for Japanese input (ja_JP.UTF-8 locale)
- PipeWire audio, systemd-boot, nix-ld enabled

## Key Aliases (from profiles/home/zsh/)

- `nrs` - NixOS rebuild switch (with sudo and impure flag)
- `drs` - Darwin rebuild switch (with sudo)
- `v` / `nvim` - Run Neovim from separate flake
- `c` - Claude CLI
- `flake-init <template>` - Initialize from gawakawa/flake-templates (zsh function)
