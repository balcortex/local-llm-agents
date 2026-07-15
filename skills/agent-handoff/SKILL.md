---
name: agent-handoff
description: Transfer decisions, findings, acceptance criteria, exact technical details, and file paths between specialized agents in a bounded workflow.
compatibility: opencode
---

# Agent Handoff Skill

Use this skill when one agent's output is required by another agent.

## Principle

The orchestrator owns cross-agent context. A receiving agent should not be told to recover information from a sibling agent's previous chat.

## Procedure

1. Read the originating agent's complete result.
2. Extract:
   - confirmed decisions;
   - constraints and scope limits;
   - acceptance criteria;
   - exact technical details such as code, selectors, schemas, commands, and paths;
   - unresolved questions or blockers.
3. Translate those details into instructions appropriate for the receiving role.
4. Include the relevant context directly in the new task prompt.
5. State what the receiving agent must produce.
6. Use a durable file under `.opencode/handoffs/` only when the content is long, exact, reused, or difficult to preserve inline.
7. When using a file, provide both a concise inline summary and the exact path.

## Handoff template

```text
Goal
- ...

Context from previous agents
- ...

Relevant files
- ...

Acceptance criteria
- ...

Scope limits
- ...

Required response
- ...
```

## Recovery

If the receiving agent reports missing context:

1. Check the prior result.
2. Retry with the missing details included.
3. Reinvoke the originating agent only if its result was incomplete.
4. Stop after a bounded retry if the information cannot be recovered.

## Rules

- Never use only "see the previous turn."
- Do not summarize away implementation-critical details.
- Distinguish confirmed decisions from optional suggestions.
- Do not expand scope while translating the handoff.
