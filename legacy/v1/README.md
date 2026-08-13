# V1 architecture reference

V1 used eight specialized OpenCode agents (`orchestrator`, `explorer`, `implementer`, `tester`, `reviewer`, `debugger`, `ui-designer`, `writer`) plus role-mirroring skills and a prompt-defined review/implement loop.

The exact historical V1 remains available in Git history/tags. V2 intentionally does not install these legacy definitions. This directory exists to document the comparison target for system evals.

V2 changes:
- deterministic checks move to `.agent/harness`;
- debugger/writer/test-runner behavior is no longer a mandatory agent hop;
- the orchestrator becomes optional;
- skills are reduced to reusable capabilities;
- evidence, candidates, and A/B evals are first-class.
