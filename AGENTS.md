# Repository Guidelines

## Project Structure & Module Organization
- Root: `flake.nix` (entrypoint) and `flake.lock` (pins).
- Platforms: `linux/` (NixOS) and `darwin/` (macOS) with `configuration.nix` and `home.nix` per OS.
- Programs: `programs/*.nix` shared Home Manager modules (e.g., `zsh.nix`, `git.nix`). Directory modules: `nvim/` and `wezterm/`. Assets in `programs/images/`.

## Build, Test, and Development Commands
- NixOS: `sudo nixos-rebuild switch --flake ".#nixos"` (apply), `dry-activate` to validate without switching.
- macOS: `darwin-rebuild switch --flake ".#mac"` or `build` to compile only.
- Home Manager: `home-manager switch --flake ".#$USER@$(hostname)"`.
- Update inputs: `nix flake update`.

## Coding Style & Naming Conventions
- Format all code with `nix fmt` (handles Nix and Lua)
- Nix: 2‑space indent, no tabs. Filenames use `kebab-case.nix`. Keep module options sorted/grouped.
- General: small, focused modules under `programs/`; prefer declarative options over ad‑hoc shell.

## Testing Guidelines
- Sanity check evaluation: `nixos-rebuild dry-activate` (Linux) or `darwin-rebuild build` (macOS).
- User scope: `home-manager build --flake ".#..."` before `switch`.

## Security & Configuration Tips
- Do not commit secrets. Source tokens via environment or encrypted stores outside this repo.
- Prefer module options over inline scripts.
