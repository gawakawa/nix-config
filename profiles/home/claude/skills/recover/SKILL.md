---
name: recover
description: "Recover pre-compaction context from backup transcripts. Use when the user wants to restore conversation context after compaction, uses phrases like 'recover context', 'restore backup', or invokes /recover."
user-invocable: true
allowed-tools: Bash
model: claude-haiku-4-5-20251001
---

Recover pre-compaction conversation context by running the companion script and summarizing the result.

## Steps

1. Run the recovery script:
   ```bash
   bash ~/.claude/skills/recover/scripts/recover-context.sh
   ```

2. If the script exits with an error, inform the user that no backup was found for the current project.

3. If successful, summarize the recovered transcript for the user:
   - What task was being worked on
   - Key decisions and progress made
   - Pending items or next steps
   - Important file paths or code locations referenced
