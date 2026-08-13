# V2 Architecture

## Principle

**Agent-driven workflow, deterministic harness.** Codex or OpenCode+model performs semantic work. The harness owns objective checks, attempt limits, and evidence.

```text
Human
  -> coding agent (Codex or OpenCode + model)
      -> edit / reason
      -> .agent/harness/Agent-Check.ps1
           -> required project checks
           -> PASS / FAIL / BLOCKED / LIMIT_REACHED
      -> focused correction when evidence exists
      -> scoped review
      -> done
```

The agent may run the harness; it must not redefine what counts as passing.

## Runtime equivalence

- Codex: coding runtime/agent platform.
- OpenCode: coding runtime/agent platform.
- Gemma/Qwen/etc.: models used by OpenCode.

The same project harness is installed for either runtime.

## Why the orchestrator is optional

The default architecture lets the primary coding agent interact directly with the harness. `orchestrator.md` remains available for smaller/local models when evals demonstrate that explicit delegation improves outcomes enough to justify the extra calls/context.

## Self improvement

Normal runs produce evidence. Maintenance may create a candidate. The candidate is evaluated A/B against a stable eval set. Promotion is manual in V2.

```text
runs -> pattern -> candidate -> A/B eval -> human review -> promote/reject
```

Do not let candidate generation rewrite stable eval expectations.
