#!/usr/bin/env bash
# PreToolUse guard for Bash: verify the real command (from stdin) before denying,
# because the gating `if` prefix matcher fails open on ${...}/compound commands.
# $1 = regex to match at command position, $2 = reason to show on deny.
re="$1"
reason="$2"
cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null)
[ -z "$cmd" ] && exit 0 # 空入力/parse失敗も allow（安全側）

# 区切り文字（; & | と subshell/group の () {}）を改行に潰し、各セグメント先頭で照合。
# → git が「コマンド位置」にある時だけ一致。引用符内の言及や引数は拾わない。
printf '%s' "$cmd" | tr ';&|(){}' '\n' | grep -Eq "$re" || exit 0 # 不一致は allow

jq -n --arg r "$reason" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
