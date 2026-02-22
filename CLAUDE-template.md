# Claude Project Context — Algolia Search Audit

## Overview
This CLAUDE.md provides project memory for the Algolia Search Audit skill. Copy this to `~/.claude/CLAUDE.md` to give Claude Code context about the audit methodology.

## Algolia Search Audit Skill (v2.7)

### What It Does
Automated search experience audit on prospect websites. Takes a URL, runs browser-based tests via Chrome MCP, captures screenshots, analyzes findings against 10 challenge areas, and produces 6 deliverables.

### Invocation
```
/algolia-search-audit <url>
/algolia-search-audit costco.com "Costco" "Warehouse Retail"
```

### 5-Phase Process
1. **Pre-Audit Research (14 steps)** — Company context, financials, executives, tech stack (BuiltWith), traffic (SimilarWeb), competitors, test queries, strategic angles, hiring signals, investor intelligence, ICP mapping
2. **Browser Testing (20 steps)** — 12 core search tests + 8 Algolia value-prop tests
3. **Analysis** — Severity scoring across 10 areas
4. **Report Generation** — Strategic intelligence + findings + opportunities
5. **Deliverable Generation (6 files)** — Report, landing page HTML, ~30-33 slide deck, content spec, AE brief, signal brief

### 6 Output Files
1. `{company}-search-audit.md` — Full report
2. `{company}-landing-page.html` — Dual-view landing page
3. `{company}-search-audit-deck.md` — McKinsey Pyramid + Cold Open deck (~30-33 slides)
4. `{company}-landing-page.md` — Content spec
5. `{company}-ae-precall-brief.md` — AE pre-call brief (internal)
6. `{company}-strategic-signal-brief.md` — LLM-optimized signal brief

### Key Principles
- **Scratchpad mining**: Each of the 12 scratchpad files is a chapter of research — each deserves dedicated slide(s) with full data tables
- **Source citations**: Every data point hyperlinked to source across all deliverables
- **Presentation quality**: Title slide must have company store/HQ photo + logo + status badge

### Completed Audits
Track your audits here:
| Company | Date | Score | Key Gaps |
|---------|------|-------|----------|
| (your audits here) | | | |

## Fact-Check Skill

### Invocation
```
/algolia-audit-factcheck <audit-directory>
```

Run after completing an audit to validate all claims across 7 dimensions before sharing deliverables.

## Notes
- System is LIVE in production environments — verify before pushing
- BuiltWith `domain-api` may return credit errors — use `free-api` as fallback
- SimilarWeb `country: "us"` may error — use `"ww"` (worldwide) as fallback
- Chrome MCP screenshots are session-bound IDs — landing pages use annotated evidence cards as fallback
