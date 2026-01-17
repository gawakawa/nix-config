#!/usr/bin/env bash
p=$(pwd | sed 's|/|-|g; s|^|-|')
s=$(find ~/.claude/projects/"$p" -maxdepth 1 -name '*.jsonl' -type f -printf '%T@\t%f\n' 2>/dev/null | sort -rn | head -1 | cut -f2 | sed 's/\.jsonl$//')
b=$(find ~/.local/state/claude/backups/"$s" -maxdepth 1 -name '*.jsonl' -type f -printf '%T@\t%p\n' 2>/dev/null | sort -rn | head -1 | cut -f2)
cat "$b"
