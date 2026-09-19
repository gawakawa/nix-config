#!/usr/bin/env bash
input=$(cat)

# Extract from JSON API
MODEL=$(echo "$input" | jq -r '.model.display_name')
CWD=$(echo "$input" | jq -r '.workspace.current_dir')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
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
cd "$CWD" 2>/dev/null || true
GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")

# Strip gwq worktree branch suffix (=<branch>) from directory basename
DIR=${CWD##*/}
DIR=${DIR%%=*}

echo "${DIR}${GIT_BRANCH:+ | $GIT_BRANCH} | ${MODEL} | ${CONTEXT_PERCENT}%"
