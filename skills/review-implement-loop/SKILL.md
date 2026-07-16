---
name: review-implement-loop
description: Coordinate a bounded implement-test-review-fix-validation workflow with explicit context transfer between specialized agents.
compatibility: opencode
---

# Review Implement Loop Skill

Use this skill for bounded implement-test-review-fix-validation workflows.

## Context rule

After every agent result, the orchestrator must extract the relevant details and include them in the next task prompt. Do not tell a later agent only to use "the previous turn."

Use direct inline transfer for concise results. Use `.opencode/handoffs/` only for long, exact, or reusable artifacts.

## Default workflow

1. Explore when repository structure or commands are unclear.
2. Implement the requested change using the relevant exploration or design context.
3. Test or manually verify the requested behavior when useful.
4. Review only the requested scope.
5. Translate exact blocking or high-confidence findings into one correction task.
6. Run one final focused test or review, depending on the issue type.
7. Stop.

## UI workflow

1. Ask the UI designer for an implementation-ready handoff.
2. Pass its relevant layout, structure, states, accessibility, responsive behavior, and file guidance to the implementer.
3. Implement the UI change.
4. Test behavior and obvious responsive/accessibility concerns.
5. Review code quality and bug risks.
6. Fix only blocking or high-confidence issues.
7. Stop after one correction cycle.

## Limits

- Maximum correction cycles: 1 by default.
- Maximum review passes: 2 by default.
- Maximum test passes: 2 by default.
- Do not run open-ended loops.
- Do not expand scope during review, testing, or UI design.
- A missing-context blocker should receive one corrected retry with the omitted context before the workflow stops.

## Final summary

Include:

- Files changed.
- Tests/checks performed.
- Review or validation status.
- Remaining issues, if any.

## Repetition recovery

Useful progress narration may be preserved, but the orchestrator must detect repeated checks or repeated completion statements. Preserve valid findings, retry the malformed subagent once with a bounded continuation prompt, and stop that subagent if repetition continues.
