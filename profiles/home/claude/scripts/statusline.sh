#!/usr/bin/env bash
input=$(cat)

# Extract from JSON API
MODEL=$(echo "$input" | jq -r '.model.display_name')
CWD=$(echo "$input" | jq -r '.workspace.current_dir')
CONTEXT_PERCENT=$(echo "$input" | jq -r '(.context_window.used_percentage // 0) | floor' 2>/dev/null)
CONTEXT_PERCENT=${CONTEXT_PERCENT:-0}

# Get git branch
cd "$CWD" 2>/dev/null || true
GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")

# Strip gwq worktree branch suffix (=<branch>) from directory basename
DIR=${CWD##*/}
DIR=${DIR%%=*}

echo "${DIR}${GIT_BRANCH:+ | $GIT_BRANCH} | ${MODEL} | ${CONTEXT_PERCENT}%"
