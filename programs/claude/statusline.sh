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

# Generate progress bar (20 chars width, 5% steps)
BAR_WIDTH=20
FILLED=$((CONTEXT_PERCENT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf '█%.0s' $(seq 1 $FILLED))
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf '░%.0s' $(seq 1 $EMPTY))"

# Get git branch
cd "$CWD" 2>/dev/null
GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")

# Output format
echo "📁 ${CWD##*/} ${GIT_BRANCH:+🌿 $GIT_BRANCH }🤖 ${MODEL} [${BAR}] ${CONTEXT_PERCENT}% ⬇️ ${INPUT_TOKENS_K}k ⬆️ ${OUTPUT_TOKENS_K}k"
