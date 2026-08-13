---
name: skill-maintainer
description: Analyze historical agent/eval evidence and propose minimal evidence-backed skill or agent changes without modifying production definitions.
compatibility: opencode,codex
---

# Skill Maintainer

This is a maintenance/evaluation skill, not part of normal task execution.

## Allowed
- inspect run summaries and eval results;
- identify repeated, reproducible failure patterns;
- distinguish prompt/skill problems from tool, model, context, test, or control-flow problems;
- propose the smallest candidate diff;
- define an A/B evaluation plan.

## Forbidden
- modify production agents or skills directly;
- create instructions from a single anecdotal failure;
- change stable eval expectations to make a candidate win;
- bypass deterministic harness rules;
- auto-promote a candidate.

## Evidence threshold
A prompt/skill change requires either:
- at least 3 independent failures showing the same pattern; or
- a reproducible benchmark deficiency.

Prefer solutions in this order:
1. deterministic code/check/gate;
2. tool or project configuration;
3. better evidence/context;
4. prompt/skill change.

Return:
- observed behavior;
- concrete evidence;
- root-cause classification;
- minimal proposed change;
- expected benefit;
- A/B eval design;
- regression risks;
- recommendation: NO_CHANGE | CREATE_CANDIDATE.
