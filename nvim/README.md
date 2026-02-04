# Neovim Configuration

Nix flake-based Neovim configuration.

## Requirements

- Nix with flakes enabled
- direnv (optional)

## Usage

```bash
# Run from GitHub
nix run github:gawakawa/nvim

# Run locally
nix run path/to/this/repository
```

## Development

```bash
# Development shell (if not using direnv)
nix develop

# Build
nix build

# Run
nix run

# Format
nix fmt
```

## Directory Structure

```
.
├── .github/workflows/    # CI workflows
├── nix/
│   ├── lib/              # Neovim wrapper builder
│   ├── pkgs/             # Custom packages
│   ├── plugins.nix       # Plugin configuration
│   └── tools.nix         # External tools
├── nvim/
│   ├── init.lua          # Neovim init
│   └── lua/              # Lua modules
└── flake.nix             # Flake definition
```
