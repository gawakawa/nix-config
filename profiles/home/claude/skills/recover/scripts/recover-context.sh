#!/usr/bin/env bash
set -euo pipefail

p=$(pwd | sed 's|/|-|g; s|^|-|')

s=$(find ~/.claude/projects/"$p" -maxdepth 1 -name '*.jsonl' -type f -printf '%T@\t%f\n' 2>/dev/null |
  sort -rn | head -1 | cut -f2 | sed 's/\.jsonl$//')

if [[ -z $s ]]; then
  echo "Error: No session found for project key '$p'" >&2
  exit 1
fi

b=$(find ~/.local/state/claude/backups/"$s" -maxdepth 1 -name '*.jsonl' -type f -printf '%T@\t%p\n' 2>/dev/null |
  sort -rn | head -1 | cut -f2)

if [[ -z $b ]]; then
  echo "Error: No backup found for session '$s'" >&2
  exit 1
fi

cat "$b"
