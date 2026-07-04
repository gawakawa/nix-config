#!/usr/bin/env bash
# PreToolUse guard for Bash: verify the real command (from stdin) before denying,
# because the gating `if` prefix matcher fails open on ${...}/compound commands.
# $1 = kind (add|reset), $2 = reason to show on deny.
kind="$1"
reason="$2"
cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0 # parse失敗は allow
[ -z "$cmd" ] && exit 0                                           # 空入力も allow（安全側）

case "$kind" in
add) re='^[[:space:]]*git[[:space:]]+add[[:space:]]+(-A|--all|-u|\.)([[:space:]]|$)' ;;
reset) re='^[[:space:]]*git[[:space:]]+reset[[:space:]]+--hard([[:space:]]|$)' ;;
*) exit 0 ;;
esac

# 区切り文字（; & | と subshell/group の () {}）を改行に潰し、各セグメント先頭で照合。
# → git が「コマンド位置」にある時だけ一致。引用符内の言及や引数は拾わない。
printf '%s' "$cmd" | tr ';&|(){}' '\n' | grep -Eq "$re" || exit 0 # 不一致は allow

jq -n --arg r "$reason" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
