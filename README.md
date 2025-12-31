# nix-config

Unified Nix configuration for NixOS (Linux) and nix-darwin (macOS).

## Requirements

- Nix with flakes enabled
- NixOS or nix-darwin

## Usage

### NixOS
```bash
sudo nixos-rebuild switch --flake ".#nixos" --impure
```

### Darwin
```bash
darwin-rebuild switch --flake ".#mac" --impure
```

## Development

```bash
nix fmt                               # Format code
nix flake check                       # Check flake
nix flake update                      # Update all inputs
nix flake lock --update-input <name>  # Update specific input
```

## Directory Structure

```
.
├── flake.nix
├── flake.lock
├── common-packages.nix
├── darwin/
│   ├── configuration.nix
│   └── home.nix
├── linux/
│   ├── configuration.nix
│   ├── hardware-configuration.nix
│   └── home.nix
└── programs/
    ├── direnv.nix
    ├── git.nix
    ├── hyprland.nix
    ├── starship.nix
    ├── waybar.nix
    ├── zsh.nix
    └── wezterm/
        ├── default.nix
        ├── wezterm.lua
        └── images/
```
