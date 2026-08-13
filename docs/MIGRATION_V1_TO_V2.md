# Migration from V1 to V2

V1 centered the workflow on an OpenCode orchestrator coordinating eight specialized agents and several role-mirroring skills. V2 keeps semantic work with the primary coding agent and moves objective validation into an executable harness.

## Active V2 roles

- `implementer`: scoped editing for OpenCode.
- `reviewer`: scoped non-editing review.
- `explorer`: optional repository exploration.
- `ui-designer`: optional UI/UX specialist.
- `orchestrator`: optional coordinator for models that benefit from delegation.

The old `debugger`, `tester`, and `writer` agent hops are not part of the default V2 flow. Debugging and documentation remain available as skills. Deterministic test execution belongs in `.agent/project.json` and `Agent-Check.ps1`.

## Recommended migration

1. Create a feature branch in the target project.
2. Install V2 with `Install-Codex.ps1`, `Install-Opencode.ps1`, or `Install-Project.ps1 -Runtime Both`.
3. Review `.agent/project.json` and make required checks trustworthy.
4. If the project already has `AGENTS.md`, merge `.agent/AGENTS.local-llm-agents.md` rather than overwriting blindly.
5. Run several normal tasks using the primary agent directly against the harness.
6. For OpenCode local models, compare direct + harness against optional orchestrator + harness before standardizing on the orchestrator.
7. Convert repeated real failures into eval cases before changing production prompts.

## Rollback

The V1 source remains in Git history. The V2 package also records the V1 base commit in `SOURCE_BASE.txt`. Use Git tags/commits for a full historical rollback rather than mixing V1 and V2 agent definitions in one installed project.
