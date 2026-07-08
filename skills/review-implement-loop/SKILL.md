# Review Implement Loop Skill

Use this skill for bounded implement-test-review-fix-validation workflows.

## Default workflow

1. Implement the requested change.
2. Test or manually verify the requested behavior when useful.
3. Review only the requested scope.
4. Fix only blocking or high-confidence issues.
5. Run one final focused test or review, depending on the issue type.
6. Stop.

## UI workflow

For UI features, use:

1. Define a small UI direction or design review.
2. Implement the UI change.
3. Test the behavior and obvious responsive/accessibility concerns.
4. Review code quality and bug risks.
5. Fix only blocking or high-confidence issues.
6. Stop after one correction cycle.

## Limits

- Maximum correction cycles: 1 by default.
- Maximum review passes: 2 by default.
- Maximum test passes: 2 by default.
- Do not run open-ended loops.
- Do not expand scope during review, testing, or UI design.

## Final summary

Include:

- Files changed.
- Tests/checks performed.
- Review or validation status.
- Remaining issues, if any.
