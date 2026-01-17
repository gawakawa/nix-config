#!/usr/bin/env bash
input=$(cat)

transcript_path=$(echo "$input" | jq -r '.transcript_path')
session_id=$(echo "$input" | jq -r '.session_id')

backup_dir="$HOME/.local/state/claude/backups/$session_id"
mkdir -p "$backup_dir"

if [ -f "$transcript_path" ]; then
  timestamp=$(date +%Y%m%d_%H%M%S)
  cp "$transcript_path" "$backup_dir/${timestamp}.jsonl"
fi
