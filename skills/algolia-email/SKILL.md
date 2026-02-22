---
name: algolia-email
description: Write Algolia-branded email copy for marketing, sales outreach, product announcements, or event invitations.
user-invocable: true
allowed-tools: Read, Grep
argument-hint: "[type: newsletter|product-announcement|event-invite|cold-outreach|nurture] [topic]"
---

# Algolia email copy writer

Generate on-brand email copy for any Algolia email type.

## Reference files

- [Voice & tone](../algolia-shared-reference/brand-core/voice-and-tone.md)
- [Terminology](../algolia-shared-reference/brand-core/terminology.md)
- [Editorial standards](../algolia-shared-reference/brand-core/editorial-standards.md)
- [Messaging framework](../algolia-shared-reference/brand-core/messaging-framework.md)
- [Email templates](../algolia-shared-reference/content-templates/email-templates.md)

## Email types

| Type | Subject line | Body length | CTA |
|------|-------------|-------------|-----|
| Newsletter | 40-60 chars, sentence case, no period | Feature story + 2-3 secondary cards | Read more / Learn more |
| Product announcement | "[Product]: [Key Benefit]" | What's new (3-4 bullets) + Why it matters | Try it now / Watch demo |
| Event invitation | "Join us: [Event] — [Date]" | Details + 3 value bullets | Register now |
| Cold outreach | Personalized, under 50 chars | 3-5 sentences max, one clear ask | Reply / Book a call |
| Nurture | Benefit-focused | 1-2 paragraphs, value-first | Download / Read / Watch |

## Rules
- Subject lines: sentence case, no clickbait, no ALL CAPS
- Preview text: 80-100 characters, complements subject
- Body: conversational but professional, short paragraphs
- One primary CTA per email — make it clear and action-oriented
- Use approved stats from the messaging framework
- Never use "we" as the first word of a sentence
- Never anthropomorphize the product (no "Algolia thinks/knows/understands")
- Include Algolia logo (Xenon variant on white) in header

## Output format

```
SUBJECT: [subject line]
PREVIEW TEXT: [preview text]

---

[Full email body in markdown]

---

CTA: [button text] → [link destination description]
```

Write email copy: $ARGUMENTS
