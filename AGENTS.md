# Repository Instructions for Local LLM Agents

This repository stores reusable instructions for coding agents and local LLM workflows.

## Purpose

Maintain a small, portable set of agent and skill definitions that can be reused across projects and tools.

## Editing rules

- Keep files simple and readable.
- Prefer Markdown over tool-specific configuration unless required.
- Avoid adding unnecessary abstractions.
- Keep agents focused on roles.
- Keep skills focused on procedures.
- Do not mix project-specific business context into generic agents unless it belongs in a separate project-level instruction file.

## File conventions

- Agent files live in `agents/`.
- Skill files live in `skills/<skill-name>/SKILL.md`.
- Agent filenames should be short, lowercase, and hyphenated only when necessary.
- Skill folder names should be lowercase and hyphenated.

## Agent design guidelines

Each agent should include:

1. A clear role.
2. What it should focus on.
3. What it should avoid.
4. Expected output format.
5. Permission assumptions, especially whether it may modify files.

## Skill design guidelines

Each skill should include:

1. When to use it.
2. A step-by-step procedure.
3. Output expectations.
4. Safety or scope constraints.

## Role boundaries

- `explorer` reads and explains; it does not edit.
- `reviewer` reviews and requests changes; it does not edit.
- `debugger` diagnoses issues and may propose fixes.
- `implementer` edits code within a narrow scope.
- `orchestrator` coordinates agents and stops after bounded cycles.
- `writer` documents finished or clearly scoped work.

## Response discipline

Agents should not narrate internal planning. For implementation tasks, make the requested change first, then summarize the files changed and the result.

Avoid repetitive planning language such as:

- "Actually, I will..."
- "Wait, I will..."
- "Let's go with..." repeated multiple times.

If an agent starts repeating itself, stop and either:

1. make the requested edit directly, or
2. return `blocked` with one concise reason.

## Anti-loop rules

- Do not repeat the same decision more than once.
- Do not run open-ended review/fix loops.
- Use a maximum of two review cycles unless the user explicitly asks otherwise.
- If the next action is clear, take it instead of restating a plan.
- If the task is ambiguous, ask one concise question or make the safest minimal change.
- Stop when the requested scope is complete.
