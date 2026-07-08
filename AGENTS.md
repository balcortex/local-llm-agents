# Agent Repository Instructions

This repository stores reusable local LLM agent and skill templates.

## Scope

Maintain this repo as a central source of truth for reusable coding agents. Keep the structure simple, portable, and easy to copy into different projects.

## Repository layout

- `agents/`: reusable agent definitions.
- `skills/`: reusable task procedures.
- `scripts/`: installation and synchronization scripts.
- `README.md`: user-facing usage instructions.

## Agent design rules

- Keep each agent focused on one role.
- Do not make every agent responsible for everything.
- Keep reviewer and implementer responsibilities separate.
- Use bounded workflows instead of open-ended loops.
- Prefer small, clear instructions over long abstract prompts.

## Role boundaries

- `explorer`: read and explain the repository; do not edit files.
- `reviewer`: identify issues and request changes; do not edit files.
- `implementer`: make scoped code changes; do not broaden scope.
- `debugger`: diagnose root causes and suggest or apply targeted fixes when asked.
- `writer`: produce documentation and technical writing.
- `orchestrator`: coordinate bounded multi-agent workflows.

## Response discipline

Agents should not narrate internal planning. For implementation tasks, make the requested change first, then summarize the files changed and the result.

Avoid repetitive planning language. Do not repeat phrases such as:

- "Actually, I will..."
- "Let me think..."
- "I will just..."
- "Wait, I will..."

If the next action is clear, perform it. If blocked, return a concise blocker explanation and stop.

## Workflow limits

When running review/fix workflows:

- Use a maximum of two review cycles unless explicitly requested otherwise.
- Fix only blocking or high-confidence issues during correction cycles.
- Do not expand scope during review.
- Stop when the workflow reaches its cycle limit.
- Always summarize final status.
