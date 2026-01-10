#!/bin/bash
input=$(cat)

# Extract from JSON API
MODEL=$(echo "$input" | jq -r '.model.display_name')
SESSION_ID=$(echo "$input" | jq -r '.session_id')
CWD=$(echo "$input" | jq -r '.workspace.current_dir')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')
CACHE_CREATE=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
CACHE_READ=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')

# Calculate context usage percentage
TOTAL_TOKENS=$((INPUT_TOKENS + CACHE_CREATE + CACHE_READ))
if [ "$CONTEXT_SIZE" -gt 0 ] 2>/dev/null; then
  CONTEXT_PERCENT=$((TOTAL_TOKENS * 100 / CONTEXT_SIZE))
else
  CONTEXT_PERCENT=0
fi

# Get git branch
cd "$CWD" 2>/dev/null
GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")

# Get plan/todo file paths
PLAN_FILE=$(ls -t ~/.claude/plans/*.md 2>/dev/null | head -1)
TODO_FILE="$HOME/.claude/todos/${SESSION_ID}.json"
[ ! -f "$TODO_FILE" ] && TODO_FILE=""

# Output format
echo "[$MODEL] ctx:${CONTEXT_PERCENT}% in:${INPUT_TOKENS} out:${OUTPUT_TOKENS} | ${CWD##*/} ${GIT_BRANCH:+($GIT_BRANCH)} | plan:${PLAN_FILE:-none} todo:${TODO_FILE:-none}"
