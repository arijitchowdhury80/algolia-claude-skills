---
name: algolia-blog
description: Generate an Algolia-branded blog post. Follows voice and tone guidelines, editorial standards, and messaging framework.
user-invocable: true
allowed-tools: Read, Grep
argument-hint: "[topic] [audience: developers|business|c-suite] [length: short|medium|long]"
---

# Algolia blog post generator

Write an Algolia-branded blog post following all brand guidelines.

## Reference files

- [Voice & tone](../algolia-shared-reference/brand-core/voice-and-tone.md)
- [Terminology](../algolia-shared-reference/brand-core/terminology.md)
- [Editorial standards](../algolia-shared-reference/brand-core/editorial-standards.md)
- [Messaging framework](../algolia-shared-reference/brand-core/messaging-framework.md)
- [Blog post template](../algolia-shared-reference/content-templates/blog-post.md)

## Blog specifications

**Tone**: Educational, authoritative, engaging
**Structure**: Title (sentence case) > Introduction (hook + thesis) > Body (H2/H3 sections) > Conclusion (CTA)
**Length**: Short (~600 words), Medium (~1,200 words), Long (~2,000 words)

### Rules
- Sentence-case headings (only capitalize first word + proper nouns)
- Oxford comma always
- Lead with value — what does the reader gain?
- Include specific data points (1.75T searches, 18,000+ businesses) where relevant
- No hedging language ("we believe", "we think")
- No buzzwords ("leverage", "synergy", "utilize", "best-in-class")
- Active voice throughout
- Never anthropomorphize technology
- Product names correctly capitalized

### SEO
- Include the target keyword in H1 and first paragraph
- Use related terms in H2s
- Meta description: 150-160 characters

Write a blog post about: $ARGUMENTS
