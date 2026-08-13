# Local LLM Agent Contract

This project uses an agent-driven validation harness. The coding agent owns semantic work; deterministic project checks own pass/fail decisions.

## Core rules

- Complete the requested task with the smallest reasonable change.
- Use repository evidence instead of speculation.
- Do not broaden scope or perform unrelated refactors.
- Do not bypass, weaken, delete, or rewrite required validation checks just to obtain a pass.
- When `.agent/harness/Agent-Check.ps1` exists, run it after implementation before declaring the task complete.
- If validation fails, use the returned evidence for a focused correction, then run the harness again.
- If the harness reports `BLOCKED` or `LIMIT_REACHED`, stop and report the blocker instead of continuing indefinitely.
- When validation passes, perform a concise scoped review of the resulting diff before finishing.
- Treat project-specific instructions and acceptance criteria as higher priority than generic reusable guidance.

## Evidence and stopping

The harness may persist attempt counters and run evidence under `.agent/runs/`. Do not edit those artifacts to bypass limits.

A successful completion requires all required deterministic checks to pass. A check that could not run is not a pass.

## Optional skills

Use reusable skills only when they materially help:

- `debugging`: focused diagnosis after concrete failure evidence.
- `documentation`: documentation work grounded in actual project behavior.
- `skill-maintainer`: maintenance/evaluation only; never modify production skills automatically during normal coding work.

Keep reasoning concise and action-oriented. Do not repeat completed checks without new evidence or a code change.
