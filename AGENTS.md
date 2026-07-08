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
3. Quality checks.
4. Expected output.
5. Common mistakes to avoid.

## Safety and reliability

- Do not recommend destructive commands without explaining risk.
- Do not fabricate file paths, APIs, schemas, or test results.
- Clearly separate observed facts from assumptions.
- Prefer small, verifiable changes over broad rewrites.
- When reviewing code, cite concrete files, functions, or snippets whenever possible.

## Current agents

- `explorer`
- `reviewer`
- `debugger`
- `writer`

## Current skills

- `codebase-exploration`
- `code-review`
- `debugging`
- `technical-writing`
