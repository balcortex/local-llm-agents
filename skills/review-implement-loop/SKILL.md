# Review Implement Loop Skill

Use this skill when coordinating a bounded implement-review-fix-review workflow.

## Procedure

1. Define the exact task scope.
2. Ask the implementer to make the minimal change.
3. Ask the reviewer to review only the requested scope.
4. If there are blocking or high-confidence issues, ask the implementer to fix only those issues.
5. Ask the reviewer for one final validation.
6. Stop and summarize.

## Cycle limits

- Maximum review cycles: 2.
- Maximum follow-up fix attempts: 1 after the first review.
- Do not continue indefinitely.
- Do not fix non-blocking suggestions unless the user explicitly requests them.

## Output

```markdown
## Workflow summary
- Task: <task>
- Steps completed: <steps>

## Files changed
- `<path>`: <description>

## Review status
<approved / approved with comments / request changes>

## Remaining issues
- <only if any>

## Suggested next step
<one next step>
```

## Constraints

- Keep roles separate.
- Reviewer does not edit.
- Implementer edits only scoped issues.
- Orchestrator stops after the cycle limit.
