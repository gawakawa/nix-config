# nix-config

Unified Nix configuration for NixOS (Linux) and nix-darwin (macOS).

## Requirements

- Nix with flakes enabled
- NixOS or nix-darwin

## Setup

### macOS

1. Install Lix:
   ```bash
   curl -sSf -L https://install.lix.systems/lix | sh -s -- install
   ```

2. Source the Nix environment:
   ```bash
   . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
   ```

3. Apply the configuration:
   ```bash
   nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ~/.config/nix-config#mac
   ```

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
├── flakes/     # Flake-parts modules
├── home/       # Home Manager configurations (per-host)
│   ├── mac/
│   └── nixos/
├── hosts/      # System configurations (per-host)
│   ├── mac/
│   └── nixos/
├── lib/        # Utility functions
├── nvim/       # Neovim configuration (separate flake)
├── overlays/   # Nix package overlays
└── profiles/   # Host-independent shared configurations
    ├── home/   #   Shared Home Manager modules
    └── hosts/  #   Shared host modules
```
