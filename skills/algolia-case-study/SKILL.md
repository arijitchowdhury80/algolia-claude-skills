---
name: algolia-case-study
description: Create an Algolia-branded customer case study with the standard structure, approved company descriptions, and quantified results.
user-invocable: true
allowed-tools: Read, Grep
argument-hint: "[customer name] [industry] [key result]"
---

# Algolia case study creator

Generate structured customer case studies following the Algolia template.

## Reference files

- [Voice & tone](../algolia-shared-reference/brand-core/voice-and-tone.md)
- [Terminology](../algolia-shared-reference/brand-core/terminology.md)
- [Editorial standards](../algolia-shared-reference/brand-core/editorial-standards.md)
- [Messaging framework](../algolia-shared-reference/brand-core/messaging-framework.md)
- [Case study template](../algolia-shared-reference/content-templates/case-study.md)
- [Approved descriptions](../algolia-shared-reference/examples/approved-descriptions.md)

## Structure

1. **Title**: "How [Customer] achieved [Result] with Algolia" — sentence case
2. **Customer snapshot**: Company, Industry, Use case, Algolia products, Key results
3. **Challenge**: 2-3 paragraphs on the problem before Algolia
4. **Solution**: 2-3 paragraphs on Algolia implementation, specific products used
5. **Results**: Quantified outcomes with specific metrics, before/after comparison
6. **Customer quote**: Direct attributed quote from a named person with title
7. **Algolia description insert**: Use standard or security-focused version from template
8. **CTA**: "See how Algolia can help your business" or similar

## Rules
- Always include quantified results (%, x improvement, time saved)
- Use the customer's real name and industry context
- Include the standard Algolia company description insert
- Sentence case for all headings
- No unsubstantiated claims — every metric must be sourced or marked [placeholder]
- Never disparage the customer's previous solution by name
- Keep quotes authentic-sounding, not marketing-speak
- Products must use correct Algolia product names (see terminology)

Create case study: $ARGUMENTS
