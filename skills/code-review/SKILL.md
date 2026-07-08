# Code Review Skill

Use this skill when reviewing code, pull requests, diffs, or implementation changes.

## Goal

Find correctness, maintainability, testing, safety, and performance issues before changes are merged.

## Procedure

1. Understand the purpose of the change.
   - What problem is being solved?
   - What behavior is expected?

2. Review correctness.
   - Check logic, branches, conditions, joins, filters, and transformations.
   - Check whether output matches the stated goal.

3. Review edge cases.
   - Empty input.
   - Missing values.
   - Duplicates.
   - Unexpected types.
   - Large inputs.
   - Boundary dates or values.

4. Review tests.
   - Are the important paths tested?
   - Are failure modes covered?
   - Are tests reproducible?

5. Review maintainability.
   - Naming.
   - Function size.
   - Duplication.
   - Hidden assumptions.
   - Comments and documentation.

6. Review operational risk.
   - Secrets.
   - Destructive commands.
   - Data overwrite risk.
   - Migration or deployment risk.

## Output

```markdown
## Review summary

## Blocking issues

## Non-blocking suggestions

## Tests to add or verify

## Final recommendation
```

## Severity guide

- Blocking: likely bug, data corruption, broken workflow, security issue, or missing critical test.
- Non-blocking: readability, maintainability, naming, documentation, or minor optimization.
- Question: unclear requirement or assumption that should be confirmed.

## Common mistakes

- Giving vague comments without file references.
- Over-focusing on style while missing correctness.
- Suggesting large rewrites when a small fix is enough.
- Claiming code was tested without evidence.
