# Debugging Skill

Use this skill when diagnosing an error, failing test, crash, broken command, incorrect output, or unexpected behavior.

## Goal

Find the root cause and propose the smallest safe fix.

## Procedure

1. Capture the symptom.
   - Error message.
   - Stack trace.
   - Failing command.
   - Expected vs actual behavior.

2. Narrow the scope.
   - What changed recently?
   - Which files are involved?
   - Does the error happen consistently?

3. Read the relevant code.
   - Start at the stack trace location.
   - Trace inputs and outputs.
   - Check assumptions.

4. Check environment and configuration.
   - Environment variables.
   - Dependency versions.
   - File paths.
   - Permissions.
   - Runtime differences between local and server.

5. Identify root cause.
   - Separate symptoms from cause.
   - Explain evidence.

6. Propose a minimal fix.
   - Prefer targeted changes.
   - Avoid unrelated rewrites.

7. Verify.
   - Suggest a command, test, or manual check.

## Output

```markdown
## Symptom

## Likely root cause

## Evidence

## Suggested fix

## Verification

## Remaining uncertainty
```

## Common mistakes

- Treating the last stack trace line as the root cause without checking context.
- Ignoring environment variables or paths.
- Recommending destructive cleanup too early.
- Skipping verification.
