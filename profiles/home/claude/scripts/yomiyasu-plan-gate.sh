#!/usr/bin/env bash
# PreToolUse guard for ExitPlanMode: deny while the plan fails yomiyasu-gate.
plan=$(jq -r '.tool_input.plan // empty' 2>/dev/null)
[ -z "$plan" ] && exit 0
report=$(printf '%s' "$plan" | yomiyasu-gate)
[ $? -eq 1 ] || exit 0 # pass, or gate/lint error -> allow

jq -n --arg r "yomiyasu lint score is below 90. Revise the plan file with Skill(yomiyasu), then call ExitPlanMode again.
$report" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
