---
name: implementation
description: Apply a scoped code change from direct requirements or a structured handoff while preserving constraints and reporting exact files and validation.
compatibility: opencode
---

# Implementation Skill

Use this skill when making code changes.

## Context intake

- Read the current task as the complete instruction set.
- Read every referenced file or handoff path.
- Preserve confirmed design, debugging, testing, and review decisions.
- Do not search sibling-agent chat history.
- Resolve minor omissions from repository conventions; block only when safe implementation is impossible.

## Rules

- Modify only necessary files.
- Keep changes scoped and readable.
- Do not add dependencies unless requested.
- Do not redesign unrelated code.
- Prefer simple solutions.
- Fix only listed blocking or high-confidence issues during a correction cycle.
- Summarize files changed, validation performed, deviations, and final status.

## Anti-loop rules

- Do not write a long plan before editing.
- Do not repeat the same decision.
- If blocked, name the exact missing input and stop.
