# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Test Commands
- Build NixOS configuration: `sudo nixos-rebuild switch --flake ".#nixos" --impure`
- Check NixOS configuration: `sudo nixos-rebuild dry-activate --flake ".#nixos" --impure`
- Format Nix files: `nixfmt-rfc-style filename.nix`
- Format Lua files: `stylua filename.lua`
- Rebuild home-manager: `home-manager switch`

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