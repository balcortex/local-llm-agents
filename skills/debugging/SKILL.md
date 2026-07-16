---
name: debugging
description: Diagnose a failing behavior from evidence, identify the smallest plausible root cause, define a targeted correction, and specify focused verification.
compatibility: opencode
---

# Debugging Skill

Use this skill when diagnosing a bug, failing behavior, or error message.

## Steps

1. Reproduce or restate the failure.
2. Locate the likely failing code path.
3. Gather evidence for the smallest plausible root cause.
4. Propose the smallest safe fix.
5. Verify with a targeted test or manual check.

## Handoff requirements

Return:

- observed failure and reproduction conditions;
- evidence with relevant files or logs;
- root cause;
- exact targeted correction;
- verification step;
- confidence level.

The handoff must be usable by a separate implementer without access to the debugging conversation.

## Rules

- Avoid broad rewrites.
- Prefer targeted fixes.
- Stop after one fix attempt unless asked to continue.

## Narration

Use concise hypothesis-based narration: `Inspecting`, `Checking`, `Found`, `Result`, and `Next`. Check each hypothesis once unless new evidence or a code change justifies a targeted revisit.
