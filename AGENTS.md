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
- Keep reviewer, tester, UI designer, and implementer responsibilities separate.
- Use bounded workflows instead of open-ended loops.
- Prefer small, clear instructions over long abstract prompts.

## Role boundaries

- `explorer`: read and explain the repository; do not edit files.
- `reviewer`: identify code quality issues and request changes; do not edit files.
- `implementer`: make scoped code changes; do not broaden scope.
- `debugger`: diagnose root causes and suggest or apply targeted fixes when asked.
- `tester`: verify behavior with focused automated tests or manual checklists.
- `ui-designer`: design or review UI/UX; edit UI files only when explicitly asked.
- `writer`: produce documentation and technical writing.
- `orchestrator`: coordinate bounded multi-agent workflows and transfer context between agents.

## Context and handoff protocol

Subagents do not need to share a conversation directly. The orchestrator owns the handoff between them.

When one agent's result is needed by another agent:

1. The originating agent returns a structured result containing decisions, constraints, relevant paths, acceptance criteria, and unresolved issues.
2. The orchestrator reads that result and translates the relevant parts into the next agent's task prompt.
3. The next prompt must contain the actual required context. Do not refer only to "the previous turn" or "what the other agent said."
4. Preserve exact code, selectors, schemas, commands, and other implementation-critical details when forwarding them.
5. Use a repository handoff file only when the content is long, must remain exact, or will be consumed by multiple later agents.
6. When a handoff file is used, store it under `.opencode/handoffs/`, include its exact path in the next task prompt, and still provide a concise inline summary.
7. If required context is missing, the orchestrator should reconstruct it from the available result or invoke the originating agent again. Do not send the receiving agent to search sibling-agent chat history.

Direct context transfer is the default. Durable files are a fallback for large or reusable artifacts, not a requirement for every workflow.

## Response discipline

Agents may provide concise progress narration when it helps debugging and makes work observable. Narration must describe actions, evidence, and conclusions—not unrestricted internal monologue.

Useful narration includes:

- `Inspecting:` the file, function, component, or behavior.
- `Checking:` the specific requirement or hypothesis.
- `Running:` the command or test being executed.
- `Found:` or `Observed:` the concrete evidence.
- `Result:` the conclusion.
- `Next:` the next distinct action, when another action remains.

Narration rules:

- Narrate each distinct check at most once.
- Do not repeat a completed check unless code changed or new evidence appeared.
- Do not speculate about checks without performing them.
- Do not restart analysis after declaring final status.
- Do not repeatedly announce completion.
- Avoid recursive self-dialogue such as:
  - "Wait, I should check..."
  - "I'm done." followed by more work
  - "Let me check that again."
  - "Actually, I should..."
- If repetition starts, stop narration and return the valid findings collected so far.
- Use one normal verification pass. A second targeted pass is allowed only after code changes, inconclusive evidence, or an explicit request.

For implementation tasks, perform the requested change promptly. Concise factual progress updates are allowed, followed by a summary of files changed and validation.

## Workflow limits

When running review/fix/test workflows:

- Use a maximum of two review cycles unless explicitly requested otherwise.
- Use a maximum of one correction cycle by default.
- Fix only blocking or high-confidence issues during correction cycles.
- Do not expand scope during review, testing, or UI design.
- Stop when the workflow reaches its cycle limit.
- Always summarize final status.
