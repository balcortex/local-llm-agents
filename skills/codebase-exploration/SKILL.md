---
name: codebase-exploration
description: Inspect a repository and return a concise handoff covering structure, architecture, entry points, commands, relevant files, and constraints.
compatibility: opencode
---

# Codebase Exploration Skill

Use this skill when exploring a repository.

## Steps

1. Identify top-level files and folders.
2. Identify the application entry point.
3. Identify configuration files.
4. Identify dependencies and build, run, lint, and test commands.
5. Summarize the architecture and data flow.
6. Identify files relevant to the requested task.
7. Point out missing or unclear documentation.

## Output

Return a self-contained repository handoff with exact paths, commands, constraints, and facts the orchestrator should forward to the next agent.
