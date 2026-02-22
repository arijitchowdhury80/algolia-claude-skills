---
name: algolia-landing
description: Generate Algolia-branded landing page copy with section-by-section structure, design specs, and CTAs.
user-invocable: true
allowed-tools: Read, Grep
argument-hint: "[topic/product] [audience: developers|marketers|c-suite] [goal: demo|trial|download]"
---

# Algolia landing page generator

Create structured, on-brand landing page copy with design direction.

## Reference files

- [Voice & tone](../algolia-shared-reference/brand-core/voice-and-tone.md)
- [Terminology](../algolia-shared-reference/brand-core/terminology.md)
- [Editorial standards](../algolia-shared-reference/brand-core/editorial-standards.md)
- [Messaging framework](../algolia-shared-reference/brand-core/messaging-framework.md)
- [Landing page template](../algolia-shared-reference/content-templates/landing-page.md)
- [Colors](../algolia-shared-reference/visual-identity/colors.md)
- [Typography](../algolia-shared-reference/visual-identity/typography.md)

## Page sections

1. **Hero** — H1 headline (6-12 words), subheadline (1-2 sentences), primary CTA button, visual direction
2. **Social proof bar** — Customer logos, key stat, analyst recognition
3. **Value props** — 3-4 cards: icon + H3 + 2-3 sentences (outcomes, not features)
4. **Feature deep-dive** — 2-3 sections with H2, screenshot direction, description, bullet capabilities
5. **Customer testimonial** — Named quote with title, company, specific result
6. **Pricing/comparison** (optional) — Tier cards or comparison table
7. **Final CTA** — Repeat primary CTA with urgency or alternative action

## Rules
- Sentence case for all headings
- Action-oriented CTA text: "Start free trial," "Get a demo," "Try it now"
- Use approved stats: "1.75 trillion searches," "18,000+ businesses," "99.999% availability"
- No superlatives without substantiation
- No anthropomorphism — the product doesn't "think" or "understand"
- Every section needs clear benefit-to-visitor framing
- Design specs: Sora font, Xenon Blue (#003DFF) for CTAs, #23263B for headings

## Output format

For each section, provide:
```
## [Section Name]

**Copy:**
[The actual text content]

**Design notes:**
- [Visual direction, layout, color guidance]
```

Create landing page: $ARGUMENTS
