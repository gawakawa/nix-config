# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

**IMPORTANT**: Claude Code cannot execute system rebuild commands as these require elevated privileges. These must be run manually by the user after configuration changes.

- **NixOS** (user must execute): `sudo nixos-rebuild switch --flake ".#nixos" --accept-flake-config --impure`
- **Darwin** (user must execute): `sudo darwin-rebuild switch --flake ".#mac"`
- **Format code**: `nix fmt` (uses treefmt-nix with nixfmt-rfc-style, stylua, shfmt)
- **Check flake**: `nix flake check`
- **Update inputs**: `nix flake update` or `nix flake lock --update-input <name>`

## Pre-commit Hooks

Available via direnv (auto-loads when entering directory):
- **treefmt**: Format check for Nix, Lua, and Shell scripts
- **statix**: Nix linter (ignores hardware-configuration.nix)
- **deadnix**: Unused code detection (ignores hardware-configuration.nix)
- **actionlint**: GitHub Actions workflow linter
- **selene**: Lua linter
- **shellcheck**: Shell script linter (excludes `.envrc`)
- **workflow-timeout**: Ensures GitHub workflows have `timeout-minutes`

## CI Pipeline

CI runs on push to main and PRs (`.github/workflows/ci.yml`):
1. Flake check: `nix flake check` (includes format check via treefmt)
2. Build NixOS/Darwin configuration

Builds are cached via Cachix (`gawakawa` cache).

## Architecture Overview

Unified Nix configuration for NixOS (x86_64-linux) and Darwin (aarch64-darwin):

```
.
├── flake.nix      # Entry point, imports flake-parts modules from ./flakes
├── flakes/        # Flake-parts module organization
│   ├── hosts.nix      # nixosConfigurations.nixos + darwinConfigurations.mac
│   ├── lib/hosts.nix  # mkNixos and mkDarwin helper functions
│   ├── devShells.nix  # Development shell configuration
│   ├── treefmt.nix    # Formatter config (nixfmt, stylua, shfmt)
│   └── pre-commit.nix # Pre-commit hook definitions
├── home/          # Home Manager configurations (per-host entry points)
│   ├── mac/
│   └── nixos/
├── hosts/         # System configurations (per-host)
│   ├── mac/
│   └── nixos/
├── lib/           # Utility functions (importSubdirs, mkCachixWatchStore)
├── nvim/          # Neovim configuration (separate flake, built in CI)
└── profiles/      # Host-independent shared configurations
    ├── home/      #   Shared Home Manager modules (git, zsh, wezterm, claude, etc.)
    └── hosts/     #   Shared host modules
```

### Host Configuration Flow

`flakes/lib/hosts.nix` provides:
- `mkNixos`: Creates NixOS system config with Home Manager integration
- `mkDarwin`: Creates Darwin system config with Home Manager + mac-app-util

Each host is defined in `flakes/hosts.nix` by specifying `hostPath`, `homePath`, and `username`.

### External Dependencies

- **Neovim**: Separate flake at `./nvim/`, accessible via alias `nvim = "nix run ~/.config/nix-config/nvim --"`
- **hardware-configuration.nix**: Auto-generated, do not edit manually

## Platform Notes

### Darwin (macOS)
- Homebrew integration for GUI apps (casks) in `hosts/mac/configuration.nix`
- Lix managed by nix-darwin (`nix.enable = true`, `nix.package = pkgs.lix`)
- Automatic garbage collection and store optimization (daily)

### Linux (NixOS)
- Hyprland as Wayland compositor with Waybar status bar
- fcitx5 with mozc for Japanese input (ja_JP.UTF-8 locale)
- PipeWire audio, systemd-boot, nix-ld enabled

## Key Aliases and Functions (profiles/home/zsh/)

**Aliases:**
- `nrs` / `drs` - System rebuild (NixOS / Darwin)
- `v` / `nvim` - Run Neovim from separate flake
- `c` - Claude CLI

**Functions:**
- `flake-init <template>` - Initialize from gawakawa/flake-templates
- `init-gh-repo` - Create GitHub repo with initial commit and set secrets
- `set-all-secrets [repo]` - Set GH_TOKEN and CACHIX_AUTH_TOKEN secrets
- `push-to-cachix <flake-output>` - Push build outputs to gawakawa cachix cache
