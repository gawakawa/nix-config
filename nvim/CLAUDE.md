# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Nix flake-based Neovim configuration using lazy.nvim for plugin management. The unique architecture uses Nix to declaratively manage plugins while lazy.nvim handles runtime loading, bridging Nix's reproducibility with Neovim's plugin ecosystem.

## Development Commands

```bash
# Format code (nixfmt for .nix, stylua for .lua)
nix fmt

# Format check (CI mode)
nix fmt -- --ci

# Flake check
nix flake check

# Build package
nix build

# Run Neovim with this config
nix run

# Development shell (generates .mcp.json)
nix develop
```

**Note**: Nix flakes only recognize files tracked by git. New or modified files must be staged (`git add`) before they are visible to flake commands like `nix build` or `nix flake check`.

## Architecture

### Plugin Management Flow

1. **Plugin Declaration** (`nix/pkgs/vim-plugins/default.nix`)
   - Custom plugins built with `pkgs.vimUtils.buildVimPlugin`
   - Standard plugins from `pkgs.vimPlugins`
   - All plugin sources are pinned with specific revisions and hashes

2. **Plugin Normalization** (`nix/plugins.nix`)
   - Converts plugin pnames to placeholder format (e.g., `nvim-treesitter` → `nvim_treesitter`)
   - Returns attribute set of all plugins keyed by normalized names
   - Includes custom `lazy_nvim` build from `nix/pkgs/vim-plugins/lazy-nvim.nix`

3. **Config Placeholder Substitution** (`nix/lib/make-neovim-wrapper.nix`)
   - Builds Neovim config derivation from `nvim/` directory
   - Substitutes `@plugin_name@` placeholders in all files with Nix store paths
   - Example: `@lazy_nvim@` in `nvim/init.lua:4` → `/nix/store/.../lazy.nvim`
   - Creates wrapper script that sets `MY_CONFIG_PATH` and adds tools to `PATH`

4. **Runtime Loading** (`nvim/lua/plugins/*.lua`)
   - Each plugin has a Lua config file returning lazy.nvim spec
   - Plugins use `dir = "@plugin_name@"` instead of GitHub URLs
   - lazy.nvim loads plugins from substituted Nix store paths
   - Plugin management features disabled (install/update/check)

### Tool Management

External tools (LSPs, formatters, linters) are declared in `nix/tools.nix` and added to PATH via the wrapper script. This provides:
- Telescope search tools (ripgrep, fd)
- LSP servers (rust-analyzer, gopls, clang-tools, etc.)
- Formatters for conform.nvim (nixfmt, rustfmt, biome, etc.)

### Lua Configuration Structure

- `nvim/init.lua` - Entry point, sets up lazy.nvim and core settings
- `nvim/lua/plugins/` - One file per plugin with lazy.nvim spec
- `nvim/lua/config/` - Shared configuration modules

## Adding New Plugins

1. Add to `nix/pkgs/vim-plugins/default.nix`:
   - If from nixpkgs: add `pkgs.vimPlugins.plugin-name` to list
   - If custom: build with `vimUtils.buildVimPlugin` (see existing examples)

2. Create config in `nvim/lua/plugins/plugin_name.lua`:
   ```lua
   return {
     dir = "@plugin_name@", -- placeholder will be substituted
     lazy = false, -- or specify load conditions
     config = function()
       -- plugin setup
     end,
   }
   ```

3. Plugin normalization is automatic (hyphens/dots → underscores)

## Adding External Tools

Add packages to the list in `nix/tools.nix`. They'll be available in PATH when running Neovim via the wrapper.

## Linting

Pre-commit hooks run automatically via `git-hooks-nix`:
- **Nix**: `statix` (static analysis), `deadnix` (dead code detection)
- **Lua**: `selene` (configured in `selene.toml` with `vim` standard library from `vim.yml`)
- **GitHub Actions**: `actionlint`

Selene allows `mixed_table` lint due to lazy.nvim spec style.

## MCP Integration

Development shell generates `.mcp.json` with `mcp-nixos` server for Claude Code. Use MCP tools (`mcp__nixos__*`) for real-time NixOS/Home Manager package and option lookups instead of relying on training data.

## CI/CD

GitHub Actions (`.github/workflows/ci.yml`) runs `nix flake check` (includes all pre-commit hooks) and `nix build` on Ubuntu and macOS.
