# AGENTS.md

## Problem-Solving Approach

When debugging, always follow this order:

1. Understand the current state
2. Identify the root cause
3. Propose solutions

Never jump to solutions before understanding the problem.

## Git Workflow

- Use the commit skill for commits, pr skill for pull requests.
- Use git-surgeon (skill) for hunk-level staging and for splitting, folding, squashing, rewording, or reordering commits. Never use interactive git commands or discard changes (`git checkout`, `git restore`) to work around a mixed diff.

## Code Style

- Write comments in English, only when the code isn't self-explanatory.

## Nix Usage Notes

Never use `nix develop` or `nix shell`. Instead:

- direnv: loads automatically on `cd`.
- comma (`,`): run packages without installing. Example: `, cowsay hello`

New files are invisible to flake eval until `git add`-ed. Run `git add <file>` before `nix build`, `nix flake check`, `nixos-rebuild`, etc.
