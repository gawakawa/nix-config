#!/usr/bin/env bash
input=$(cat)
queue="$HOME/.local/state/claude/retrospect-queue.jsonl"

case $(echo "$input" | jq -r '.hook_event_name') in
SessionEnd)
  session_id=$(echo "$input" | jq -r '.session_id')
  grep -q "\"$session_id\"" "$queue" 2>/dev/null && exit 0
  mkdir -p "$(dirname "$queue")"
  echo "$input" | jq -c '{session_id, transcript_path, cwd}' >>"$queue"
  ;;
SessionStart)
  cwd=$(echo "$input" | jq -r '.cwd')
  pending=$(jq -r --arg cwd "$cwd" 'select(.cwd == $cwd) | .transcript_path' "$queue" 2>/dev/null)
  [ -n "$pending" ] && printf 'Unprocessed retrospect transcripts for this project:\n%s\n' "$pending"
  ;;
esac
exit 0
