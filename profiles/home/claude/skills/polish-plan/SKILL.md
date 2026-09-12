---
name: polish-plan
description: "Rewrite the current session's plan file so a reader with no conversation context can follow it, by deleting provenance notes, exploration narration, and duplicated facts — never by adding content."
when_to_use: "When the user runs /polish-plan, or asks to clean up the plan file with phrases like 'plan を書き直せ', 'plan を削って', 'plan が冗長'."
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Edit, Write
model: opus
---

# Polish Plan

Edit the plan file at the path this session already knows from its plan-mode
context, in place. If that path isn't apparent from context, ask the user for
it instead of guessing.

## Ground rule

Never add information not already present in the plan file. Reasoning and
decisions discussed elsewhere in the conversation, but not written into the
plan, must not be added — that would be fabrication. The only allowed
operations are deleting and rephrasing text already in the file. A sentence
that can't be made self-contained by deleting or rephrasing gets deleted, not
explained.

## What to delete

- Provenance of a decision: "ユーザーへの確認で決定した", "議論で確定",
  "調査で確認済み". Also `(確定)` and similar suffixes on headings.
- Narration of the exploration/investigation process: "〜を直接読んで確認済み".
  Keep only the conclusion.
- Duplicated facts. When the same fact appears in more than one section, keep
  the occurrence in the section that actually produces output (a task list, a
  file to write) and delete the rest. If no occurrence is clearly closer to
  output, keep the one with more supporting detail and delete the shallower
  restatement.
- Rejected alternatives with no stated reason. Ones with a reason collapse
  into a one-line entry under an "out of scope" note.
- Decorative bold with no signal, `---` dividers, and tables whose columns
  restate each other.

## What to rephrase

Turn conversation-relative phrasing into a sentence that stands on its own.
Rephrase only text that introduces content that still needs a lead-in after
editing (e.g. a colon-terminated line before a list) — deleting it outright
would orphan what follows. Anything else matching "What to delete" gets
deleted, not rephrased.

- "上記の通り X にする" → "X にする"
- "ユーザーの回答から確定した前提:" → "前提:"
