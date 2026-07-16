---
name: ui-design
description: Produce an implementation-ready UI handoff covering layout, structure, styling, interaction states, responsiveness, accessibility, files, and acceptance checks.
compatibility: opencode
---

# UI Design Skill

Use this skill when designing, reviewing, or improving a user interface.

## Goals

- Improve clarity, usability, accessibility, and visual hierarchy.
- Keep UI changes simple and implementable.
- Preserve existing behavior unless a UI interaction requires change.
- Return a handoff that another agent can implement without access to the design conversation.

## Procedure

1. Inspect relevant existing UI files when available.
2. Identify the user goal, primary actions, stack, and constraints.
3. Review layout, spacing, typography, color/contrast, states, and responsiveness.
4. Define the smallest design that solves the issue.
5. Include exact HTML/component structure, class names, selectors, or tokens when they matter.
6. If editing is requested, modify only the necessary UI files.
7. Return a structured handoff or editing summary.

## UI checklist

- Main action is visible and clear.
- Current state is obvious.
- Text is readable.
- Controls have spacing and affordance.
- Keyboard users can interact with the UI.
- Focus states are visible where relevant.
- Layout works at common screen sizes.
- Contrast is acceptable.
- Default, hover, focus, active, disabled, loading, empty, and error states are considered when relevant.
- No unnecessary dependencies are added.

## Design handoff

Include:

- goal and existing constraints;
- layout and hierarchy;
- component or HTML structure;
- visual styling and tokens;
- interaction states;
- responsive behavior;
- accessibility requirements;
- implementation files;
- acceptance checks;
- open decisions.

Use a `.opencode/handoffs/` file only when explicitly requested or when the artifact is too long or exact to preserve reliably inline.

## Narration

Concise UI narration is allowed using `Inspecting`, `Checking`, `Found`, and `Decision`. Do not repeat settled design areas without new evidence.
