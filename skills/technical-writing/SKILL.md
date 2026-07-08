# Technical Writing Skill

Use this skill when writing documentation, README sections, PR summaries, changelog entries, implementation notes, or technical messages.

## Goal

Communicate technical work clearly, accurately, and with the right level of detail for the audience.

## Procedure

1. Identify the audience.
   - Developer.
   - Reviewer.
   - Manager.
   - Non-technical stakeholder.

2. Identify the purpose.
   - Explain.
   - Summarize.
   - Request review.
   - Document usage.
   - Record implementation details.

3. Gather facts.
   - What changed?
   - Why did it change?
   - How was it validated?
   - What limitations remain?

4. Draft clearly.
   - Use short sections.
   - Prefer bullet points for scannability.
   - Avoid unnecessary jargon.
   - Keep caveats visible.

5. Review for accuracy.
   - Do not claim tests passed unless evidence exists.
   - Do not exaggerate impact.
   - Do not omit known limitations.

## PR summary format

```markdown
## Summary
- <change>

## Why
- <reason>

## Validation
- <test/check>

## Notes
- <risk or follow-up>
```

## Documentation format

```markdown
# <Title>

## Overview

## Usage

## Details

## Notes
```

## Common mistakes

- Writing too much background before the main point.
- Mixing uncertain assumptions with confirmed facts.
- Using vague phrases like "some improvements" without details.
- Forgetting validation or limitations.
