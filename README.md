# nix-config

Unified Nix configuration for NixOS (Linux) and nix-darwin (macOS).

## Requirements

- Nix with flakes enabled
- NixOS or nix-darwin

## Usage

### NixOS
```bash
sudo nixos-rebuild switch --flake ".#nixos" --accept-flake-config --impure
```

### Darwin
```bash
sudo darwin-rebuild switch --flake ".#mac"
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
├── hosts/
│   ├── mac/
│   │   └── configuration.nix
│   └── nixos/
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── home/
│   ├── mac/
│   │   └── default.nix
│   └── nixos/
│       ├── default.nix
│       ├── hyprland/
│       └── waybar/
└── profiles/
    ├── hosts/
    │   └── packages.nix
    └── home/
        ├── claude/
        ├── direnv/
        ├── git/
        ├── gpg/
        ├── starship/
        ├── wezterm/
        └── zsh/
```
