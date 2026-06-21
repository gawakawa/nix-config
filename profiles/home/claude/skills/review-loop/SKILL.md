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

While the condition is unmet, `/goal`'s Stop hook re-drives another turn; this
skill's instructions stay in context, so each re-drive runs one more iteration.
When a round prints `REVIEW-LOOP-STATUS: CLEAN` (or iteration 5 is reached) the
goal auto-clears and the loop ends. Press Esc to stop early. (`/goal` is
user-only and can't be set from a skill, so you type that one line to arm it.)

## One iteration

Every turn — including each `/goal` re-drive — execute this whole section from
step 1, starting with a **fresh** `/code-review`. Never re-emit a status off a
previous round or work from stale findings.

**Effort**: use the argument if provided (low|medium|high|max); else `high`.

1. **Review** — invoke the code-review skill via the Skill tool, passing effort
   as the positional arg (e.g. `args: "high"`). Never `--fix`/`--ultra`. Capture
   the findings.
2. **Triage** — dispatch a read-only Plan subagent (Agent, `subagent_type: Plan`)
   with the findings. Following the global problem-solving order (understand →
   root cause → fix), return per finding: `needs_fix` (bool), `reason`,
   `root_cause`, `fix_plan`. Constraint: analysis only — use **only** Read, Grep,
   and Glob; do **not** run Bash, and do not edit or write any files.
3. **Surface** — print the triage as a markdown `[FIX]/[SKIP]` list before any
   fix lands.
4. **Act**:
   - If any finding needs fixing → apply each `fix_plan` (Edit/Write/Bash). Do
     **not** commit. RESULT = `FIXED`.
   - If nothing needs fixing → if `git status` / `git diff main...HEAD` shows
     uncommitted fixes from earlier rounds, run `/commit` once to land them all.
     RESULT = `CLEAN`.
5. **Conclude** — set `N` = the iteration number on the most recent prior
   `REVIEW-LOOP-STATUS:` line in this conversation, + 1 (or `1` if none), and
   print as the **final line**, exactly:

   ```
   REVIEW-LOOP-STATUS: <RESULT> | iteration <N>
   ```

   This line is the only thing `/goal` reads to decide whether to re-drive.

If the loop stops on the turn cap while RESULT was `FIXED`, the applied fixes are
left **uncommitted** for the user to review and decide on.
