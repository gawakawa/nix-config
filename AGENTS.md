# Repository Guidelines

## Project Structure & Module Organization
- Root: `flake.nix` (entrypoint) and `flake.lock` (pins).
- Platforms: `linux/` (NixOS) and `darwin/` (macOS) with `configuration.nix` and `home.nix` per OS.
- Programs: `programs/*.nix` shared Home Manager modules (e.g., `neovim.nix`, `zsh.nix`, `git.nix`). Assets in `programs/images/`.
- Neovim: `nvim/` Lua config managed by lazy.nvim.
- Dev envs: `lang/<language>/flake.nix` (isolated shells for Rust, Go, TypeScript, etc.).

## Build, Test, and Development Commands
- NixOS: `sudo nixos-rebuild switch --flake ".#nixos" --impure` (apply), `dry-activate` to validate without switching.
- macOS: `darwin-rebuild switch --flake ".#mac" --impure` or `build` to compile only.
- Home Manager: `home-manager switch --flake ".#$USER@$(hostname)"`.
- Update inputs: `nix flake update`.
- Language shells: `nix develop ./lang/rust` (replace `rust`).

## Coding Style & Naming Conventions
- Nix: 2‑space indent, no tabs; format with `nixfmt`. Filenames use `kebab-case.nix`. Keep module options sorted/grouped.
- Lua: format with `stylua`. Follow existing `nvim/` patterns.
- General: small, focused modules under `programs/`; prefer declarative options over ad‑hoc shell.

## Testing Guidelines
- Sanity check evaluation: `nixos-rebuild dry-activate` (Linux) or `darwin-rebuild build` (macOS).
- User scope: `home-manager build --flake ".#..."` before `switch`.
- Optional: `nix flake check` if checks are added in the future.

## Commit & Pull Request Guidelines
- Style: use Gitmoji + concise English (one line). Examples: `📝 Update documentation`, `✨ Add Hyprland config`, `♻️ Refactor neovim setup`.
- Scope: mention platform if relevant: `🔧 linux: enable pipewire`.
- PRs: include summary, affected modules/paths, platforms impacted (Linux/Darwin), manual post‑merge steps, and screenshots if UI/terminal appearance changes.
- No signatures or co‑author trailers; keep diffs minimal and focused.

## Security & Configuration Tips
- Do not commit secrets. Source tokens via environment or encrypted stores outside this repo.
- Prefer module options over inline scripts; keep `--impure` usage minimal and justified.
