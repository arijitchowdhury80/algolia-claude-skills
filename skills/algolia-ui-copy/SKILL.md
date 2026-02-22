---
name: algolia-ui-copy
description: Write Algolia-branded UI microcopy — tooltips, error messages, empty states, onboarding text, button labels, and notifications.
user-invocable: true
allowed-tools: Read, Grep
argument-hint: "[type: tooltip|error|empty-state|onboarding|button|notification] [context]"
---

# Algolia UI copy writer

Generate concise, on-brand microcopy for product interfaces.

## Reference files

- [Voice & tone](../algolia-shared-reference/brand-core/voice-and-tone.md)
- [Terminology](../algolia-shared-reference/brand-core/terminology.md)
- [Editorial standards](../algolia-shared-reference/brand-core/editorial-standards.md)

## Copy types

| Type | Max length | Tone | Format |
|------|-----------|------|--------|
| Tooltip | 1-2 sentences | Helpful, concise | Plain text |
| Error message | 1-2 sentences | Calm, solution-oriented | What happened + what to do |
| Empty state | 2-3 sentences | Encouraging, action-oriented | Title + description + CTA |
| Onboarding | 1-3 sentences per step | Friendly, guiding | Step title + instruction |
| Button label | 2-4 words | Action-oriented | Verb + object |
| Notification | 1 sentence | Informative, brief | Status + detail |

## UI copy principles
- **Clarity over cleverness** — users should understand instantly
- **Action-oriented** — tell users what they can do, not just what happened
- **Sentence case** — never Title Case or ALL CAPS in UI text
- **No jargon** — use simple language even for technical features
- **No anthropomorphism** — the product doesn't "think," "know," or "understand"
- **No exclamation marks** in error messages
- **Be specific** — "Your API key is missing" not "Something went wrong"

## Error message pattern
```
[What happened — 1 sentence]
[What to do about it — 1 sentence with action]
```

Example: "This index doesn't exist yet. Create one in your dashboard to get started."

## Empty state pattern
```
[Title — what this area is for]
[Description — why it's empty and what value it provides]
[CTA — action to populate it]
```

## Rules
- Use Algolia product terminology consistently (see terminology guide)
- Never blame the user ("You made an error" → "Something didn't work")
- Provide a clear next step in every error and empty state
- Keep button labels to 2-4 words starting with a verb
- Test for scannability — users skim UI text

Write UI copy: $ARGUMENTS
