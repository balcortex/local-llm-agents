# Code Review Skill

Use this skill when reviewing code, pull requests, patches, or generated implementations.

## Procedure

1. Understand the requested change.
2. Inspect the modified files.
3. Check correctness first.
4. Check edge cases.
5. Check tests or missing test coverage.
6. Check maintainability.
7. Check security and data safety when relevant.
8. Separate blocking issues from suggestions.
9. End with a clear recommendation.

## Severity

- Blocking: likely bug, data loss, security issue, broken behavior, or failed requirement.
- Non-blocking: readability, maintainability, style, performance, or future improvement.

## Output

```markdown
## Review summary
<short summary>

## Blocking issues
- `<path>`: <issue and why it matters>

## Non-blocking suggestions
- `<path>`: <suggestion>

## Tests to add or check
- <test idea>

## Final recommendation
<approve / approve with comments / request changes>
```

## Constraints

- Do not modify files.
- Stay inside the requested review scope.
- Do not request changes for unrelated improvements.
