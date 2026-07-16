---
name: code-review
description: Review scoped code changes for correctness, edge cases, maintainability, security risks, and missing verification without editing files.
compatibility: opencode
---

# Code Review Skill

Use this skill when reviewing code or a pull request.

## Checklist

- Correctness and edge cases.
- Input validation and error handling.
- State management and race conditions.
- Maintainability and naming.
- Unnecessary complexity.
- Security risks.
- Missing tests or manual checks.
- Conformance with supplied acceptance criteria and design decisions.

## Review discipline

- Do not edit files.
- Focus on actionable findings.
- Separate blocking issues from suggestions.
- Give each blocking issue a stable identifier.
- Include file, location, impact, and the smallest required correction.
- Avoid scope creep.
- Return `approved` if there are no blocking issues.
- Make findings self-contained so an orchestrator can forward them to another agent.

## Narration

Concise review narration is allowed using `Inspecting`, `Checking`, `Found`, and `Result`. Narrate each distinct review area once, then return structured findings. Do not repeat completed checks or restart after approval/request changes.
