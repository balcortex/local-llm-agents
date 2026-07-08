# Debugging Skill

Use this skill when diagnosing errors, broken behavior, failing tests, runtime issues, or unexpected outputs.

## Procedure

1. State the observed symptom.
2. Identify expected behavior.
3. Read error messages, logs, and stack traces carefully.
4. Find the relevant file and function.
5. Check recent changes and assumptions.
6. Identify the most likely root cause.
7. Propose the smallest safe fix.
8. Suggest a verification step.

## Output

```markdown
## Symptom
<what is failing>

## Most likely cause
<root cause>

## Evidence
- `<path or log>`: <specific evidence>

## Suggested fix
<minimal fix>

## Verification
- <command or test>
```

## Constraints

- Prefer evidence over speculation.
- Do not rewrite unrelated code.
- Do not repeat the same plan.
- Stop after one fix attempt unless asked to continue.
