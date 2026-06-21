---
name: review-loop
description: "One disciplined pass of /code-review -> triage -> fix on the current branch; pair with /goal to repeat until clean or a turn cap. Use when the user says 'review loop', 'レビューループ', 'code-review を回して直して', 'lint until clean'. Optional arg: code-review effort (low|medium|high|max, default high)."
user-invocable: true
disable-model-invocation: false
allowed-tools: Skill(code-review), Skill(commit), Agent, Read, Edit, Write, Bash, Grep, Glob
model: opus
---

# Review Loop

This skill runs **one** pass of `/code-review` → triage → fix and ends by
printing an exact status line. Repetition is driven by Claude Code's `/goal`,
which reads that line — not by this skill.

## Run it as a loop

Arm the goal, then invoke the skill:

```
/goal After each turn, read the most recent line beginning "REVIEW-LOOP-STATUS:". Stop if its result is CLEAN, or if its iteration number is 5 or more. Otherwise run one more /review-loop iteration.
/review-loop high
```

Press Esc to stop early. (`/goal` is user-only and can't be set from a skill, so you type that one line to arm it.)

## One iteration

Run steps 1–5 in order, starting with a **fresh** `/code-review` each time.

**Effort**: use the argument if provided (low|medium|high|max); else `high`.

1. **Review** — invoke the code-review skill via the Skill tool, passing effort
   as the positional arg (e.g. `args: "high"`). Never `--fix`/`--ultra`. Capture
   the findings. On the **first** iteration (`N` will be 1), if `git status --short`
   already shows changes, tell the user that the branch has pre-existing uncommitted
   work — the commit step asks which files to stage, so it won't be swept in without
   their selection.
2. **Triage** — dispatch a Plan subagent (Agent, `subagent_type: Plan`) with the
   findings. Per finding return: `needs_fix` (bool), `reason`, `root_cause`,
   `fix_plan`. Use only Read, Grep, and Glob — do not run Bash.
3. **Surface** — print the triage as a markdown `[FIX]/[SKIP]` list before any
   fix lands.
4. **Act**:
   - If any finding needs fixing → apply each `fix_plan` (Edit/Write/Bash). Do
     **not** commit. RESULT = `FIXED`.
   - If nothing needs fixing → RESULT = `CLEAN`.
5. **Conclude**:
   - If RESULT is `CLEAN`, run `git status --short`; if non-empty, run `/commit`
     once (the commit skill confirms which files to stage).
   - Run `git status --short`. If it shows uncommitted changes, say so **loudly**
     and list them.
   - Set `N` = the iteration number on the most recent prior `REVIEW-LOOP-STATUS:`
     line in this conversation, + 1 (or `1` if none). If `N == 1` and RESULT is
     `FIXED`, remind the user that a bare `/review-loop` runs once — to repeat
     automatically, arm a `/goal` as shown in **Run it as a loop**.
   - Print as the **final line**, exactly:

   ```
   REVIEW-LOOP-STATUS: <RESULT> | iteration <N>
   ```

   This line is the only thing `/goal` reads to decide whether to re-drive.
