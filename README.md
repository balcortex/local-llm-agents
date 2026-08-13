# Local LLM Agents V2

Reusable agent, skill, harness, and evaluation templates for **Codex** and **OpenCode + local models**.

V2 changes the architecture from prompt-heavy multi-agent orchestration to an **agent-driven deterministic harness**:

```text
You
 ↓
Codex  OR  OpenCode + Gemma/Qwen
 ↓
implement / reason
 ↓
.agent/harness/Agent-Check.ps1
 ├─ FAIL → agent receives concrete evidence and makes a focused correction
 ├─ BLOCKED/LIMIT_REACHED → stop and report
 └─ PASS → scoped review → done
```

The agent is allowed to run the harness. The agent is **not** allowed to redefine what counts as passing, weaken required checks, or bypass attempt limits.

## What is included

```text
local-llm-agents/
├── AGENTS.md                     # small global agent contract
├── agents/                       # OpenCode V2 agents
│   ├── orchestrator.md           # optional fallback/coordinator
│   ├── explorer.md
│   ├── implementer.md
│   ├── reviewer.md
│   └── ui-designer.md
├── skills/
│   ├── debugging/
│   ├── documentation/
│   └── skill-maintainer/
├── scripts/
│   ├── Install-Project.ps1
│   ├── Install-Codex.ps1
│   ├── Install-Opencode.ps1
│   ├── Update-Project.ps1
│   ├── Get-AgentStatus.ps1
│   ├── Initialize-AgentProject.ps1
│   ├── Agent-Check.ps1
│   ├── Agent-Status.ps1
│   ├── Export-AgentCandidate.ps1
│   ├── Run-CodexWorkflow.ps1     # optional scripted fallback
│   ├── Run-Evals.ps1
│   └── Compare-Evals.ps1
├── schemas/
├── templates/
├── evals/reviewer/               # starter A/B eval set
├── candidates/
├── docs/ARCHITECTURE.md
└── legacy/v1/                    # V1 architecture reference
```

# Quick start: Codex

## 1. Put this repo next to or inside your target project

Recommended central layout:

```text
C:\repos\
├── local-llm-agents\
└── my-project\
```

Install from the central source:

```powershell
C:\repos\local-llm-agents\scripts\Install-Codex.ps1 `
  -ProjectRoot C:\repos\my-project `
  -KeepSource
```

If instead you copied/cloned `local-llm-agents` *inside* `my-project`, from the project root run:

```powershell
.\local-llm-agents\scripts\Install-Codex.ps1
```

The temporary nested source is removed by default. Add `-KeepSource` to keep it.

## 2. Inspect the generated validation config

The installer also copies the reusable Codex skills to `.agents/skills/` so Codex can discover them at project scope.

The installer creates:

```text
my-project/.agent/project.json
```

It attempts to detect common commands from `package.json`, Python project structure, or .NET files. **Review this file before relying on it.** Example:

```json
{
  "schema_version": 1,
  "max_validation_attempts": 2,
  "checks": [
    {
      "name": "tests",
      "command": "npm test",
      "required": true,
      "timeout_seconds": 600
    },
    {
      "name": "lint",
      "command": "npm run lint",
      "required": false,
      "timeout_seconds": 300
    }
  ]
}
```

A required check that cannot run is a failure/blocker, not a pass.

## 3. Use Codex normally

Open the project:

```powershell
cd C:\repos\my-project
codex
```

Then ask normally:

```text
Add keyboard remapping support. Follow the project harness and stop when required checks pass or the harness blocks further attempts.
```

`AGENTS.md` already tells Codex to use:

```powershell
.\.agent\harness\Agent-Check.ps1
```

after implementation. Codex remains the primary agent and runs the harness itself.

### Reset validation attempts for a new task

The harness intentionally persists attempt count to stop open-ended retry loops. At the start of a new independent task, reset it:

```powershell
.\.agent\harness\Agent-Check.ps1 -ResetAttempts
```

This command also performs a validation run. If you only want to reset state manually, delete:

```text
.agent/runs/validation-state.json
```

A future version can introduce task IDs so resets are automatic per task.

# Quick start: OpenCode + Gemma/Qwen

Install:

```powershell
C:\repos\local-llm-agents\scripts\Install-Opencode.ps1 `
  -ProjectRoot C:\repos\my-project `
  -KeepSource
```

This installs the same `.agent` harness plus:

```text
.opencode/agents/
.opencode/skills/
```

The V2 OpenCode agent set is intentionally smaller:

- `implementer`
- `reviewer`
- `explorer`
- `ui-designer`
- `orchestrator` (**optional**)

Start by trying the primary model directly against the harness. Use the orchestrator only if evals show that your local model benefits from explicit delegation.

# Install both runtimes

```powershell
.\scripts\Install-Project.ps1 `
  -ProjectRoot C:\repos\my-project `
  -Runtime Both `
  -KeepSource
```

# Existing AGENTS.md

The installer does **not** overwrite an existing root `AGENTS.md` by default. Instead it writes the reusable contract to:

```text
.agent/AGENTS.local-llm-agents.md
```

Merge the relevant rules into your project instructions, or explicitly replace it:

```powershell
.\scripts\Install-Codex.ps1 `
  -ProjectRoot C:\repos\my-project `
  -OverwriteAgentsMd `
  -KeepSource
```

# Daily workflow

For a normal coding task:

```text
1. Ask Codex/OpenCode for the change normally.
2. The coding agent implements it.
3. The agent runs Agent-Check.ps1.
4. Required checks return objective PASS/FAIL evidence.
5. On FAIL, the agent makes a focused correction and re-runs the harness.
6. The harness enforces max_validation_attempts.
7. After PASS, the agent performs a concise scoped review and stops.
```

The deterministic harness handles things such as tests, lint, build, type-checking, or project-specific validation commands. It does not ask an LLM whether an exit code means success.

## Check status manually

Inside an installed project:

```powershell
.\.agent\harness\Agent-Status.ps1
```

# Updating projects from the central repo

Keep one central clone as the source of truth:

```text
C:\repos\local-llm-agents\
```

After you update that repo, update any installed project with:

```powershell
C:\repos\local-llm-agents\scripts\Update-Project.ps1 `
  -TargetProject C:\repos\my-project
```

The installer records version, source commit, runtime, and hashes in:

```text
.agent/manifest.json
```

Check whether a project is current:

```powershell
C:\repos\local-llm-agents\scripts\Get-AgentStatus.ps1 `
  -TargetProject C:\repos\my-project
```

## Local drift protection

If a managed installed file has been edited locally, updates do **not** overwrite it silently. The updater reports drift and skips that file. Use `-Force` only when you intentionally want the central copy to replace local changes:

```powershell
.\scripts\Update-Project.ps1 `
  -TargetProject C:\repos\my-project `
  -Force
```

Project-specific files such as `.agent/project.json` are not replaced during normal updates.

# Feeding improvements back to the central repo

Do **not** automatically sync modified project prompts back into the source repository.

Use:

```text
project evidence
   ↓
candidate
   ↓
A/B eval
   ↓
human decision
   ↓
promote or reject
```

Export a locally modified agent/skill as a candidate:

```powershell
C:\repos\local-llm-agents\scripts\Export-AgentCandidate.ps1 `
  -SourceProject C:\repos\my-project `
  -RelativePath ".opencode\agents\reviewer.md" `
  -Reason "Missed the same API regression in several real runs"
```

The candidate is copied under `candidates/`; it does not change the production agent.

# A/B evals

V2 includes a small starter reviewer eval suite. It is intentionally simple; add real regression cases from your projects over time.

Run the included baseline against a candidate:

```powershell
.\scripts\Run-Evals.ps1 `
  -BaselinePrompt .\evals\reviewer\baseline.md `
  -CandidatePrompt .\evals\reviewer\candidate-example.md `
  -EvalSet reviewer `
  -Repetitions 2
```

Optionally pin the Codex model:

```powershell
.\scripts\Run-Evals.ps1 `
  -BaselinePrompt .\evals\reviewer\baseline.md `
  -CandidatePrompt .\candidates\reviewer\my-candidate.md `
  -Model YOUR_CODEX_MODEL `
  -Repetitions 2
```

Results are written under `eval-results/`. Compare a result file with:

```powershell
.\scripts\Compare-Evals.ps1 `
  -ResultsFile .\eval-results\<run>\results.json
```

## Eval discipline

- Keep stable eval expectations separate from candidate generation.
- Add real failures as regression cases.
- Include negative cases so prompts are not rewarded for flagging everything.
- Keep model, task, tools, and evaluation conditions the same between A and B.
- Treat tiny differences as noise; inspect individual failures before promotion.
- V2 never auto-promotes a candidate.

# Skill maintainer

`skills/skill-maintainer/SKILL.md` analyzes evidence and may recommend a candidate only when a repeated pattern or reproducible benchmark deficiency exists.

It should prefer:

```text
deterministic gate/check
→ tool/config fix
→ better evidence/context
→ prompt/skill change
```

A normal coding task should never invoke skill maintenance automatically.

# Optional scripted Codex workflow

The preferred V2 mode is **agent-driven**: open Codex interactively and let Codex call the harness.

For automation/experiments there is also:

```powershell
.\scripts\Run-CodexWorkflow.ps1 `
  -ProjectRoot C:\repos\my-project `
  -Task "Add a pause menu"
```

This is a fallback/automation helper, not the main architecture.

# Codex CLI requirements

The A/B runner uses current `codex exec` capabilities including non-interactive execution and structured output. Keep Codex CLI reasonably current. If your installed CLI has different flags, check:

```powershell
codex exec --help
```

The everyday agent-driven harness does **not** depend on structured-output support; only the included eval helper does.

# Recommended first real-world experiment

1. Install V2 into one disposable or feature-branch project.
2. Configure `.agent/project.json` with trustworthy required checks.
3. Run 10–20 normal tasks with Codex directly + harness.
4. Keep run evidence; note failures/loops manually.
5. Try the same task class with OpenCode + Gemma if desired.
6. Only introduce the optional orchestrator if the local model's results demonstrate a coordination problem.
7. Convert repeated real failures into eval cases.
8. Propose candidate changes and A/B test them before promotion.

# Design notes and limitations

- V2 is intentionally conservative: no autonomous self-modification or auto-promotion.
- `Agent-Check.ps1` executes commands from your local `.agent/project.json`; treat that configuration as executable code and review it.
- Attempt state is currently project-level, not task-ID-level. Reset it when beginning an unrelated task.
- The starter eval suite is illustrative, not statistically meaningful by itself.
- Nested reviewer-agent execution is not required for the initial V2 experiment; deterministic checks + scoped review by the active agent are the default. A dedicated reviewer can be used natively in OpenCode or added later to the Codex harness once real-world results justify it.

See `docs/ARCHITECTURE.md` for the conceptual architecture.
