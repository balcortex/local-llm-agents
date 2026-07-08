# Review Implement Loop Skill

Use this skill for bounded implement-review-fix-review workflows.

## Default workflow

1. Implement requested change.
2. Review only the requested scope.
3. Fix only blocking or high-confidence issues.
4. Run one final focused review.
5. Stop.

## Limits

- Maximum correction cycles: 1 by default.
- Maximum review passes: 2 by default.
- Do not run open-ended loops.
- Do not expand scope during review.

## Final summary

Include:

- Files changed.
- Review status.
- Remaining issues, if any.
