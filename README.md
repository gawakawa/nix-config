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
