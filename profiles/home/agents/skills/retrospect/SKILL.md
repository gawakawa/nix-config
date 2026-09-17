---
name: retrospect
description: "Extract the corrections the user made during a session and save the recurring ones to Claude Code memory as type: feedback. When the user runs /retrospect, when a SessionStart notice reports unprocessed retrospect transcripts, or on phrases like '振り返って', '指摘を memory に', 'retrospect'."
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash, Read, Write, Edit
model: opus
---

# Retrospect

- Take the transcript paths from `~/.local/state/claude/retrospect-queue.jsonl` whose `cwd` matches this project; with no queue entry, use this session's own transcript at `~/.claude/projects/*/"$CLAUDE_CODE_SESSION_ID".jsonl`.
- Dump each one's user messages — plain ones, plus feedback given when denying a tool or plan:
  ```bash
  jq -r 'select(.type=="user") | .userFeedback // (.message.content|select(type=="string"))' "$transcript"
  ```
- Keep only corrections that will recur: tool choices, code conventions, workflow preferences.
- Drop task-specific facts and anything already in CLAUDE.md or an existing memory.
- Save what remains as `type: feedback` per the memory protocol in the system prompt.
- Delete the processed entries from the queue so the notice stops repeating.
