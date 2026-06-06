# CLAUDE.md

Be concise. Don't pad sentences that can stand on their own.

## Problem-Solving Approach

When debugging, always follow this order:

1. Understand the current state
2. Identify the root cause
3. Propose solutions

Never jump to solutions before understanding the problem.

## Git Workflow

- Use the `/commit` skill for commits, `/pr` skill for pull requests.
- Never use `git add -A`, `git add .`, or `git add --all`. Stage files explicitly by name.
- Use `git revert` to undo commits, not `git reset`.

## Planning

- Split work into tasks small enough to revert cleanly if needed, and track progress with the task tool.
- Commit each completed task with the `/commit` skill.

## Code Style

- Write comments in English, only when the code isn't self-explanatory.

## Nix Usage Notes

Never use `nix develop` or `nix shell`. Instead:

- direnv: loads automatically on `cd`.
- comma (`,`): run packages without installing. Example: `, cowsay hello`

New files are invisible to flake eval until `git add`-ed. Run `git add <file>` before `nix build`, `nix flake check`, `nixos-rebuild`, etc.
