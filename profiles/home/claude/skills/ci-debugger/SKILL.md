---
name: ci-debugger
description: "Analyze GitHub Actions CI logs to identify failure causes. Use when user wants to debug CI failures, investigate workflow errors, or understand why a build failed. Triggers on phrases like 'debug CI', 'why did CI fail', 'analyze workflow failure', 'check CI logs', 'CIが失敗しています', 'CIが落ちた', 'ワークフローのエラーを調査', 'ビルドが失敗した'. Accepts run ID or PR number as argument."
user-invocable: true
allowed-tools: Bash, Grep, AskUserQuestion
model: opus
context: fork
---

# CI Debugger

Debug GitHub Actions CI failures by extracting and analyzing error logs.

## Workflow

### Step 1: Identify Target Run

If run ID provided as argument, use it directly.

Otherwise, fetch recent failures and ask user to select:

```bash
gh run list --status failure --limit 5 --json databaseId,displayTitle,conclusion,createdAt
```

If only PR number given, get failed checks:

```bash
gh pr checks <pr-number> --json name,state,link
```

Use AskUserQuestion to confirm which run to analyze.

### Step 2: Download Logs

```bash
gh run view <run-id> --log > /tmp/ci-run-<run-id>.log
```

### Step 3: Search for Errors

Use Grep tool on the downloaded log file. Search patterns in priority order (see references/patterns.md for full list):

1. **GitHub Actions errors**: `##\[error\]`, `::error::`
2. **Exit codes**: `Process completed with exit code [1-9]`
3. **Nix errors**: `^error:`, `error: builder for .* failed`
4. **General failures**: `FAILED`, `fatal:`, `panic:`

Use appropriate context lines:
- `-C 5` for annotation errors
- `-B 15` for exit code failures (look backward)
- `-C 15` for Nix errors
- `-A 20` for stack traces

### Step 4: Output Results

Output matched log lines with context as-is. Do not summarize - preserve original format for accurate debugging.
