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
│   └── writer.md
└── skills/
    ├── codebase-exploration/
    │   └── SKILL.md
    ├── code-review/
    │   └── SKILL.md
    ├── debugging/
    │   └── SKILL.md
    └── technical-writing/
        └── SKILL.md
```

## Agents

Agents define reusable roles.

- `explorer`: understands codebases without changing files.
- `reviewer`: reviews code, PRs, risks, and edge cases without changing files.
- `debugger`: diagnoses errors, logs, failing tests, and runtime issues.
- `writer`: writes documentation, summaries, implementation notes, and technical messages.

## Skills

Skills define reusable procedures.

- `codebase-exploration`: how to inspect a project systematically.
- `code-review`: how to review changes and report findings.
- `debugging`: how to diagnose and resolve errors.
- `technical-writing`: how to write clear technical documentation and summaries.

## How to use

### As a central template

Keep this repository in GitHub and update it over time. For each project, copy the relevant files into that project according to the tool you are using.

Example for opencode-style project agents:

```bash
mkdir -p .opencode/agents
cp path/to/local-llm-agents/agents/reviewer.md .opencode/agents/reviewer.md
cp path/to/local-llm-agents/agents/explorer.md .opencode/agents/explorer.md
cp path/to/local-llm-agents/agents/debugger.md .opencode/agents/debugger.md
cp path/to/local-llm-agents/agents/writer.md .opencode/agents/writer.md
```

### As shared instructions

Copy or adapt `AGENTS.md` into the root of a project when using tools that read repository-level agent instructions.

### As skills

Copy the relevant skill folder into the location expected by your tool.

## Design principles

1. Keep agents small and focused.
2. Prefer read-only agents by default.
3. Do not hide uncertainty.
4. Ask for confirmation before destructive actions.
5. Keep tool-specific formats out of the central layer until needed.
6. Evolve gradually based on repeated workflows.

## Recommended first workflow

1. Use `explorer` to understand the repository.
2. Use `debugger` when something fails.
3. Use `reviewer` before opening a PR.
4. Use `writer` to prepare documentation or PR summaries.
