---
paths: profiles/home/claude/**, profiles/home/agents/**, profiles/home/codex/**
---

# Claude Code / Codex Configuration

- `~/.claude/` and `~/.codex/` are Nix-generated (ultimately symlinks into `/nix/store/`),
  not manually maintained
- Shared instructions (`AGENTS.md`) and skills live in `profiles/home/agents/`
- Claude Code-only settings (`settings.json`, agents, scripts) live in `profiles/home/claude/`
- Codex-only settings live in `profiles/home/codex/`
- `~/.claude/CLAUDE.md` is a symlink to `~/.codex/AGENTS.md`; edit `profiles/home/agents/AGENTS.md`,
  not either generated file
