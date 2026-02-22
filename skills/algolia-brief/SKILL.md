---
name: algolia-brief
description: Generate an Algolia-branded campaign or creative brief with objectives, audience, messaging, and deliverables.
user-invocable: true
allowed-tools: Read, Grep
argument-hint: "[campaign name] [goal: awareness|pipeline|adoption] [audience]"
---

# Algolia campaign brief generator

Create structured campaign/creative briefs aligned with Algolia brand and messaging.

## Reference files

- [Voice & tone](../algolia-shared-reference/brand-core/voice-and-tone.md)
- [Terminology](../algolia-shared-reference/brand-core/terminology.md)
- [Messaging framework](../algolia-shared-reference/brand-core/messaging-framework.md)
- [Campaign brief template](../algolia-shared-reference/content-templates/campaign-brief.md)

## Brief sections

1. **Campaign overview**: Name, owner, dates, budget range
2. **Objective**: Business goal + 2-3 KPIs with targets
3. **Target audience**: Primary ICP, pain points, decision criteria, channels
4. **Key message**: Core message (1 sentence) + 3-4 supporting proof points + tone
5. **Deliverables**: Asset list with owners, due dates, status
6. **Channels & distribution**: Where and how content will be promoted
7. **Measurement**: Success metrics, reporting cadence, tools
8. **Brand guardrails**: Mandatory terminology, visual requirements, approval process

## Rules
- Core message must tie back to Algolia positioning from the messaging framework
- Supporting messages must use approved stats and proof points
- Tone selection must reference the voice-and-tone spectrum
- All product names must follow terminology guidelines
- Include brand guardrails section with mandatory do's and don'ts
- KPIs must be specific and measurable

Create brief: $ARGUMENTS
