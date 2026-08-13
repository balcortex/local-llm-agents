---
name: debugging
description: Diagnose a concrete failing behavior from harness/test evidence and define the smallest safe correction.
compatibility: opencode,codex
---

# Debugging

Use only after a concrete failure, error, or failing check exists.

1. Restate the observed failure.
2. Trace the smallest relevant code path.
3. Gather evidence for the most plausible root cause.
4. Apply or propose the smallest safe correction.
5. Re-run only the focused validation justified by the change.

Do not broaden the task. Do not repeatedly test the same hypothesis without new evidence.
