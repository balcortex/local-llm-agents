# Testing Skill

Use this skill when verifying implemented behavior, adding focused tests, or creating manual test checklists.

## Goals

- Verify the requested change works.
- Catch regressions and edge cases.
- Keep test scope small and relevant.
- Prefer existing project test tools over new dependencies.

## Procedure

1. Identify the expected behavior and acceptance criteria.
2. Inspect existing test structure and package scripts if available.
3. Choose the smallest useful test strategy:
   - existing automated tests
   - new focused unit/integration tests
   - manual checklist when no test framework exists
4. Run the smallest relevant command when allowed.
5. Report the result clearly.

## What to check

- Happy path behavior.
- Edge cases related to the change.
- Regression risks in nearby behavior.
- Input handling and invalid states.
- Browser/runtime compatibility when relevant.

## Output

Return:

```text
Test summary
- ...

Checks performed
- ...

Issues found
- none / issue list

Final test status
passed / failed / blocked
```

## Constraints

- Do not add a new test framework unless explicitly requested.
- Do not run broad or destructive commands.
- Do not expand the feature scope during testing.
- If tests cannot be run, provide concise manual verification steps.
