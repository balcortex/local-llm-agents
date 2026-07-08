# Implementation Skill

Use this skill when making a scoped code change.

## Procedure

1. Restate the requested scope briefly if needed.
2. Identify the minimum files required.
3. Edit only those files.
4. Preserve existing behavior outside the request.
5. Avoid unrelated refactors.
6. Check for obvious syntax and logic errors.
7. Summarize changed files and verification steps.

## Output

```markdown
## Files changed
- `<path>`: <what changed>

## Result
<short explanation>

## Verification
- <manual check or command>

## Notes
- <remaining caveat, if any>
```

## Constraints

- Do not write a long plan before editing.
- Do not broaden scope.
- Do not redesign unrelated code.
- Do not run destructive commands.
- If blocked, return `blocked` with one concise reason.
