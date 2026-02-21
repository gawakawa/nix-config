# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Problem-Solving Approach

**CRITICAL**: Always follow this order when debugging:

1. **Understand the current state** - Gather facts about what is actually happening
2. **Identify the root cause** - Analyze the facts to determine why it's happening
3. **Propose solutions** - Only after understanding the cause, suggest fixes

**Never jump to solutions before understanding the problem**. Speculation without evidence leads to wrong fixes.

## Code Style

- Write comments in English.
- Keep comments minimal—only add them when the code isn't self-explanatory.

## Nix Usage Notes

**Do NOT use `nix develop` or `nix shell`**. Use these alternatives instead:

- **direnv**: Automatically loads the environment when entering a directory with `.envrc`. Just `cd` into the project.
- **comma (`,`)**: Run any package temporarily without installing it. Example: `, cowsay hello`

**Flake and git tracking**: Nix flakes in Git repositories only see files that have been `git add`-ed. After creating new files, run `git add <file>` before any flake evaluation (`nix build`, `nix flake check`, `nixos-rebuild`, etc.), otherwise the files will be invisible to Nix.

## Context Backup Recovery

Pre-compaction backups are saved automatically.

**To recover context**, run:
```bash
~/.claude/recover-context.sh
```
