# Local LLM Agents

Reusable agent and skill templates for local LLM coding workflows across opencode, Codex, Antigravity, and other AI coding tools.

This repository is intended to be a central source of truth for reusable coding agents. For now, the most supported workflow is installing these agents into an opencode project.

## Repository structure

```text
local-llm-agents/
├── README.md
├── AGENTS.md
├── agents/
│   ├── explorer.md
│   ├── reviewer.md
│   ├── implementer.md
│   ├── debugger.md
│   ├── writer.md
│   └── orchestrator.md
├── skills/
│   ├── codebase-exploration/
│   │   └── SKILL.md
│   ├── code-review/
│   │   └── SKILL.md
│   ├── debugging/
│   │   └── SKILL.md
│   ├── implementation/
│   │   └── SKILL.md
│   ├── review-implement-loop/
│   │   └── SKILL.md
│   └── technical-writing/
│       └── SKILL.md
└── scripts/
    └── Install-Opencode.ps1
```

## Agents

| Agent | Mode | Purpose |
|---|---|---|
| `orchestrator` | primary | Coordinates bounded workflows such as implement → review → fix → review. |
| `explorer` | subagent | Explores a repository structure and explains how it works. |
| `reviewer` | subagent | Reviews code and reports issues without editing files. |
| `implementer` | subagent | Makes scoped code changes with minimal planning. |
| `debugger` | subagent | Diagnoses bugs, logs, stack traces, and failure modes. |
| `writer` | subagent | Writes documentation, README updates, PR summaries, and technical notes. |

Recommended role separation:

```text
orchestrator  -> coordinates workflow
explorer      -> understands the repo
reviewer      -> reviews, does not edit
implementer   -> edits code
debugger      -> diagnoses bugs
writer        -> documents
```

## Install into an opencode project

The intended workflow is:

```text
1. Copy or clone this full repository inside the root of the target project.
2. Run scripts/Install-Opencode.ps1 from the copied folder.
3. The script installs agents and skills into the target project.
4. By default, the copied local-llm-agents folder is removed after installation.
```

Example target project before installation:

```text
snake-test-2/
├── local-llm-agents/
│   ├── agents/
│   ├── skills/
│   ├── AGENTS.md
│   └── scripts/
│       └── Install-Opencode.ps1
└── ...project files
```

Run from the project root:

```powershell
cd C:\repos\snake-test-2
.\local-llm-agents\scripts\Install-Opencode.ps1
```

After installation:

```text
snake-test-2/
├── AGENTS.md
├── .opencode/
│   ├── agents/
│   │   ├── explorer.md
│   │   ├── reviewer.md
│   │   ├── implementer.md
│   │   ├── debugger.md
│   │   ├── writer.md
│   │   └── orchestrator.md
│   └── skills/
│       ├── codebase-exploration/
│       ├── code-review/
│       ├── debugging/
│       ├── implementation/
│       ├── review-implement-loop/
│       └── technical-writing/
└── ...project files
```

The temporary folder is removed by default:

```text
snake-test-2/local-llm-agents/  -> removed
```

## Keep the copied source folder

Use `-KeepSource` if you want to keep the copied `local-llm-agents` folder inside the target project after installation:

```powershell
.\local-llm-agents\scripts\Install-Opencode.ps1 -KeepSource
```

This is useful when debugging the installer or checking the installed files manually.

## Replace an existing AGENTS.md

By default, the installer does **not** overwrite an existing `AGENTS.md` in the target project.

To replace it:

```powershell
.\local-llm-agents\scripts\Install-Opencode.ps1 -OverwriteAgentsMd
```

You can combine options:

```powershell
.\local-llm-agents\scripts\Install-Opencode.ps1 -OverwriteAgentsMd -KeepSource
```

## Clone-and-install example

```powershell
cd C:\repos\snake-test-2
git clone https://github.com/balcortex/local-llm-agents.git
.\local-llm-agents\scripts\Install-Opencode.ps1
```

## Copy-and-install example

If you downloaded or copied the folder manually:

```powershell
cd C:\repos\snake-test-2
Copy-Item C:\repos\local-llm-agents .\local-llm-agents -Recurse -Force
.\local-llm-agents\scripts\Install-Opencode.ps1
```

## Test after installation

Restart opencode UI and open the target project.

If `orchestrator` is configured as a primary agent, select it as the active agent. Then try:

```text
Create a simple Snake game using HTML, CSS, and vanilla JavaScript.
Run one implement-review-fix-review cycle and stop after one correction cycle.
```

To invoke subagents directly, select them through the `@` autocomplete so the mention becomes a structured agent reference:

```text
@explorer summarize this repository structure
@reviewer review the current implementation without editing files
@implementer fix the blocking issue reported by the reviewer
```

## Notes

- Keep `agents/` and `skills/` as the source of truth.
- Avoid manually maintaining duplicated adapter files until a generator script exists.
- Prefer bounded workflows with a maximum number of review/fix cycles.
- If a model starts repeating planning text, stop it and re-run with a more direct prompt such as: `Edit the file directly. Do not write a plan. Summarize after editing.`
