# Local LLM Agents

Central repository for reusable agent and skill instructions for local and cloud coding assistants.

This repository is intentionally simple. It is meant to be copied, symlinked, or referenced from tools such as opencode, Codex, Antigravity, LM Studio based workflows, and future local LLM setups.

## Structure

```text
local-llm-agents/
├── README.md
├── AGENTS.md
├── agents/
│   ├── explorer.md
│   ├── reviewer.md
│   ├── debugger.md
│   ├── implementer.md
│   ├── orchestrator.md
│   └── writer.md
└── skills/
    ├── codebase-exploration/
    │   └── SKILL.md
    ├── code-review/
    │   └── SKILL.md
    ├── debugging/
    │   └── SKILL.md
    ├── implementation/
    │   └── SKILL.md
    ├── review-implement-loop/
    │   └── SKILL.md
    └── technical-writing/
        └── SKILL.md
```

## Agents

Agents define reusable roles.

- `explorer`: understands codebases without changing files.
- `reviewer`: reviews code, pull requests, risks, and edge cases without changing files.
- `debugger`: diagnoses errors, logs, failing tests, and runtime issues.
- `implementer`: makes scoped code changes with minimal explanation.
- `orchestrator`: coordinates bounded workflows across agents.
- `writer`: writes documentation, summaries, implementation notes, and technical messages.

## Skills

Skills define reusable procedures.

- `codebase-exploration`: process for understanding a repository.
- `code-review`: checklist for reviewing code and changes.
- `debugging`: process for diagnosing and fixing failures.
- `implementation`: process for making small, safe code changes.
- `review-implement-loop`: bounded workflow for implement-review-fix-review cycles.
- `technical-writing`: process for writing documentation and technical communication.

## Suggested workflow

For a normal code change:

```text
@orchestrator Run a bounded review-implement workflow for this task:
<describe task>

Limits:
- Maximum 2 review cycles.
- Do not expand scope.
- Stop after final review.
```

For a manual workflow:

```text
@implementer make the scoped change
@reviewer review the change
@implementer fix confirmed blocking issues
@reviewer validate the fix
@writer update documentation if needed
```

## Using with opencode

Project-level agents usually live in:

```text
.opencode/agents/
```

Project-level skills usually live in:

```text
.opencode/skills/
```

Example PowerShell sync into a project:

```powershell
mkdir .opencode\agents -Force
Copy-Item C:\repos\local-llm-agents\agents\*.md .opencode\agents\ -Force

mkdir .opencode\skills -Force
Copy-Item C:\repos\local-llm-agents\skills\* .opencode\skills\ -Recurse -Force

Copy-Item C:\repos\local-llm-agents\AGENTS.md .\AGENTS.md -Force
```

## Design principles

- Keep agents small and role-specific.
- Keep skills procedural and reusable.
- Prefer bounded workflows over open-ended loops.
- Review agents should not edit code.
- Implementation agents should make small scoped changes.
- Orchestration should stop after a fixed number of cycles.
