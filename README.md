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
│   ├── tester.md
│   ├── ui-designer.md
│   ├── writer.md
│   └── orchestrator.md
├── skills/
│   ├── agent-handoff/
│   │   └── SKILL.md
│   ├── codebase-exploration/
│   │   └── SKILL.md
│   ├── code-review/
│   │   └── SKILL.md
│   ├── debugging/
│   │   └── SKILL.md
│   ├── implementation/
│   │   └── SKILL.md
│   ├── testing/
│   │   └── SKILL.md
│   ├── ui-design/
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
| `orchestrator` | primary | Coordinates bounded workflows such as implement → test → review → fix → validate. |
| `explorer` | subagent | Explores a repository structure and explains how it works. |
| `reviewer` | subagent | Reviews code and reports issues without editing files. |
| `implementer` | subagent | Makes scoped code changes with minimal planning. |
| `debugger` | subagent | Diagnoses bugs, logs, stack traces, and failure modes. |
| `tester` | subagent | Verifies behavior with focused tests or manual checklists. |
| `ui-designer` | subagent | Designs or reviews UI/UX for clarity, usability, accessibility, and responsive behavior. |
| `writer` | subagent | Writes documentation, README updates, PR summaries, and technical notes. |

Recommended role separation:

```text
orchestrator  -> coordinates workflow
explorer      -> understands the repo
ui-designer   -> designs/reviews UI
implementer   -> edits code
tester        -> verifies behavior
reviewer      -> reviews code, does not edit
debugger      -> diagnoses bugs
writer        -> documents
```

## Context handoffs

The orchestrator is responsible for transferring context between subagents. A later agent should receive the actual decisions, constraints, acceptance criteria, issue descriptions, and relevant file paths in its own task prompt. It should not be told only to use information from a previous turn.

Preferred handoff:

```text
@ui-designer returns a structured UI handoff
        ↓
orchestrator extracts and forwards the relevant details
        ↓
@implementer receives a self-contained implementation task
```

For short results, the orchestrator forwards the required content inline. For long or exact artifacts, it may ask the originating agent to save a file under `.opencode/handoffs/`, then pass both a concise summary and the exact path to the next agent.

The repository includes the `agent-handoff` skill for this procedure.

## Recommended workflows

For a normal implementation:

```text
orchestrator -> implementer -> reviewer
```

For a behavior-sensitive feature:

```text
orchestrator -> implementer -> tester -> reviewer
```

For a UI feature:

```text
orchestrator -> ui-designer -> implementer -> tester -> reviewer
```

For a bug fix:

```text
orchestrator -> debugger -> implementer -> tester/reviewer
```

Keep workflows bounded. The default recommendation is one implementation pass, one validation/review pass, one correction pass, and one final validation.

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
│   │   ├── tester.md
│   │   ├── ui-designer.md
│   │   ├── writer.md
│   │   └── orchestrator.md
│   ├── handoffs/
│   └── skills/
│       ├── agent-handoff/
│       ├── codebase-exploration/
│       ├── code-review/
│       ├── debugging/
│       ├── implementation/
│       ├── testing/
│       ├── ui-design/
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
Run the standard UI implementation workflow and stop after one correction cycle.
```

The orchestrator should interpret that as:

```text
@ui-designer
    -> orchestrator forwards the concrete UI handoff
    -> @implementer
    -> @tester
    -> @reviewer
    -> optional targeted @implementer fix
    -> final validation
```

Each downstream task should contain the required context. A task such as `use the HTML and CSS from the previous turn` is incomplete unless the orchestrator also includes that HTML/CSS or a path to a durable handoff file.

To invoke subagents directly, select them through the `@` autocomplete so the mention becomes a structured agent reference:

```text
@explorer summarize this repository structure
@ui-designer review the layout and usability of this page
@implementer fix the blocking issue reported by the reviewer
@tester verify the gameplay behavior and list manual checks
@reviewer review the current implementation without editing files
```

## Notes

- Keep `agents/` and `skills/` as the source of truth.
- OpenCode skills require YAML frontmatter with `name` and `description`; all included skills follow that format.
- Use direct orchestrator context transfer by default and `.opencode/handoffs/` for long or exact artifacts.
- Avoid manually maintaining duplicated adapter files until a generator script exists.
- Prefer bounded workflows with a maximum number of review/fix/test cycles.
- If a model starts repeating planning text, stop it and re-run with a more direct prompt such as: `Edit the file directly. Do not write a plan. Summarize after editing.`
