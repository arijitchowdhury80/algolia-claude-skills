---
name: algolia-deck
description: Create an Algolia-branded presentation with slide-by-slide content, design specs, and speaker notes. Compatible with the Algolia Slide Template 2024.
user-invocable: true
allowed-tools: Read, Grep
argument-hint: "[topic] [audience] [number of slides]"
---

# Algolia presentation creator

Create a branded presentation outline with slide-by-slide content.

## Reference files

- [Voice & tone](../algolia-shared-reference/brand-core/voice-and-tone.md)
- [Messaging framework](../algolia-shared-reference/brand-core/messaging-framework.md)
- [Presentation template](../algolia-shared-reference/content-templates/presentation.md)
- [Colors](../algolia-shared-reference/visual-identity/colors.md)
- [Typography](../algolia-shared-reference/visual-identity/typography.md)
- [Logo usage](../algolia-shared-reference/visual-identity/logo-usage.md)

## Design specs

- **Font**: Sora (Light 300 for titles, Regular 400 for body, Semi-Bold 600 for emphasis)
- **Colors**: Xenon Blue #003DFF, headings #23263B, body #5A5E9A, white backgrounds
- **Logo**: Algolia Full Xenon variant, bottom-right corner

## Slide layouts

| Layout | Use for |
|--------|---------|
| Title slide | Opening — deck title, subtitle, date |
| Agenda | Table of contents |
| Section divider | Break between sections |
| Content + visual | Main content with image/chart placeholder |
| Stats/metrics | Highlight 2-3 key numbers |
| Quote/testimonial | Customer quote |
| Comparison | Before/after or competitive positioning |
| Team | People slides |
| CTA/closing | Final slide with next steps |

## Output format

For each slide output:

```
### Slide N: [Layout type]
**Title:** ...
**Content:** ...
**Visual:** [Description of image/chart/graphic to add]
**Speaker notes:** ...
```

## Rules
- Max 6 words in slide titles
- Max 3-5 bullet points per slide
- One idea per slide
- Tone: confident, visual-first, story-driven
- Use approved stats from the messaging framework
- Never criticize competitors by name

Create a presentation about: $ARGUMENTS
