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

# Format tokens in k units
INPUT_TOKENS_K=$((INPUT_TOKENS / 1000))
OUTPUT_TOKENS_K=$((OUTPUT_TOKENS / 1000))

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

# Extract basenames for display
PLAN_NAME="${PLAN_FILE:+${PLAN_FILE##*/}}"
TODO_NAME="${TODO_FILE:+${TODO_FILE##*/}}"

# Output format
echo "[$MODEL] 📊 ${CONTEXT_PERCENT}% ⬇️ ${INPUT_TOKENS_K}k ⬆️ ${OUTPUT_TOKENS_K}k | 📁 ${CWD##*/} ${GIT_BRANCH:+🌿 $GIT_BRANCH}"
echo "📋 ${PLAN_NAME:-none} ✅ ${TODO_NAME:-none}"
