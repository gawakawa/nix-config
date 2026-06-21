---
name: review-loop
description: "Iteratively run /code-review, triage which findings need addressing, fix them, and re-review until nothing worth addressing remains. Use when the user wants to clean up the current branch via repeated code review, or says 'review loop', 'レビューループ', 'code-review を回して直して', 'lint until clean'. Optional arg: code-review effort level (low|medium|high|max, default high)."
user-invocable: true
disable-model-invocation: false
allowed-tools: Skill(code-review), Skill(commit), Agent, Read, Edit, Write, Bash, Grep, Glob, TaskCreate, TaskUpdate, AskUserQuestion
model: opus
---

# Review Loop

Run `/code-review` → triage → fix → repeat until the triage finds nothing worth addressing.

**Safety cap**: 5 rounds maximum. If hit with outstanding findings, report them and stop without committing.

**Commit policy**: one `/commit` at the very end, only if fixes were applied. No per-round commits.

**Effort**: use the argument if provided (low|medium|high|max), otherwise default to `high`.

## Workflow

Use TaskCreate to track progress.

### Step 1: Setup

- Parse the effort level from the skill argument. Default: `high`.
- Create a task with title "review-loop" and record `round = 0`, `fixes_applied = false`.

### Step 2: Review (repeat up to MAX_ROUNDS)

Increment `round`. If `round > 5`, go to **Cap Reached**.

Invoke the code-review skill using the Skill tool, passing the effort level as the positional argument (e.g., `args: "high"`). Never pass `--fix` or `--ultra`.

Capture the findings from its inline output.

### Step 3: Triage

Dispatch a read-only Plan subagent (Agent tool, `subagent_type: Plan`) with:

- The full findings from Step 2.
- The current codebase context (relevant files if needed).
- Instruction: follow the global problem-solving order — understand the current state, identify the root cause, then propose a fix. For each finding return a JSON-like structured assessment: `needs_fix` (bool), `reason` (why or why not), `root_cause` (if needs_fix), `fix_plan` (concrete steps if needs_fix).
- Constraint: the subagent must NOT edit or write files and must NOT run Bash commands that write to files (no output redirections, no file-creating tools) — analysis only.

### Step 4: Surface triage

Print the triage summary as a markdown list so the user can see it before fixes land. Format:

```
## Round N triage
- [FIX] <finding> — <reason>
- [SKIP] <finding> — <reason>
```

### Step 5: Terminate check

If the triage marks **no** finding as `needs_fix`, print "✓ Nothing to address — loop complete." and go to **Commit**.

### Step 6: Fix

Implement each `fix_plan` in the main thread using Edit/Write/Bash. Do NOT commit.
Set `fixes_applied = true`.

Update the task status, then go back to **Step 2**.

---

### Cap Reached

Report the remaining findings plainly:

```
⚠️ MAX_ROUNDS (5) reached with outstanding findings:
<list each unaddressed finding>
Not committing — decide how to proceed.
```

Stop. Do not commit.

---

### Commit

If `fixes_applied = true`, invoke `/commit` once to commit all changes across all rounds.
If `fixes_applied = false` (triage found no actionable findings on round 1), report "No changes needed."
