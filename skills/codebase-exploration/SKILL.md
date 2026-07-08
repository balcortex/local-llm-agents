# Codebase Exploration Skill

Use this skill when the user asks to understand a repository, feature, module, or unfamiliar codebase.

## Goal

Build an accurate mental model of the project before suggesting changes.

## Procedure

1. Start at the root.
   - Identify README files.
   - Identify dependency files.
   - Identify build, lint, test, and configuration files.

2. Identify the project type.
   - Application, library, data pipeline, dashboard, notebook project, service, or mixed repo.

3. Find entry points.
   - CLI entry points.
   - App startup files.
   - Main scripts.
   - Notebooks.
   - Scheduled jobs.

4. Map the core flow.
   - Inputs.
   - Transformations.
   - Outputs.
   - External systems.

5. Inspect tests.
   - Test framework.
   - Coverage of important paths.
   - Missing or weak tests.

6. Summarize findings.
   - Keep the summary evidence-based.
   - Mention uncertainty clearly.

## Output

```markdown
## Project summary

## Key files

## Main workflow

## Dependencies and configuration

## Tests

## Risks or unknowns
```

## Common mistakes

- Explaining files that are not relevant to the user's question.
- Assuming architecture without reading files.
- Ignoring configuration and environment files.
- Missing generated files or notebooks.
