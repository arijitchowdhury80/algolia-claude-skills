# NotebookLM Slide Deck Prompt

## Which Files to Upload as Sources (4 files only)

| # | File | Why |
|---|------|-----|
| 1 | `{company}-search-audit-deck.md` | **PRIMARY** — Contains the full ~30-33 slide story arc with Act structure |
| 2 | `{company}-strategic-signal-brief.md` | Dense signal-per-line format designed for LLM consumption |
| 3 | `{company}-search-audit.md` | Full report with source citations and deep analysis |
| 4 | `{company}-landing-page.html` | Visual structure reference for data presentation |

**DO NOT upload**: Scratchpad files (01-12), content spec, or AE brief. Their content is already in the deliverables — uploading both creates RAG retrieval confusion where NotebookLM pulls random overlapping chunks instead of following the deck's narrative structure.

---

## Prompt to Paste into NotebookLM Slide Deck Description

Copy everything below the line and paste it into NotebookLM's "Describe your deck" field:

---

Create a 30-33 slide executive presentation following a McKinsey Pyramid + Hollywood Cold Open structure. The deck MUST follow this exact 4-Act arc:

SLIDE 1: Title slide — company store/HQ photo background, dark gradient overlay, company logo, audit status badge, key stat (visits/month), opportunity dollar amount.

SLIDE 2: "The Bottom Line" — Answer-first. The entire story in 30 seconds: score, what's broken, what it costs, what we're asking for. This is the McKinsey pyramid — conclusion FIRST.

ACT 1 — THE COMPANY (Slides 3-8): Who they are, what's happening to them. Company snapshot with full financial table (revenue, net income, digital revenue, locations, employees). Digital Traffic Deep Dive (visits, bounce rate, traffic sources with signals). Audience DNA (demographics, audience overlap, keyword intent patterns). Tech Stack Upheaval (removed vs added technologies, the gap where search should be). Competitor Landscape with BuiltWith-verified search providers. Strategic Intelligence (trigger events, leadership transitions, timing signals).

ACT 2 — THE EVIDENCE (Slides 9-16): What we found. Audit Overview scorecard with category scores. Then ONE slide per critical gap found (typically 4-7 gaps), each with: the problem stated clearly, a real test query example showing what happened vs what should happen, and the business impact quantified. Every gap slide must hook to the next with a transition line.

ACT 3 — THE URGENCY (Slides 17-22): Why now. "In Their Own Words" — CEO/CFO quotes from earnings calls and SEC filings mapped directly to audit findings (place AFTER gaps for emotional impact). SEC 10-K Risk Factors mapped to specific findings. Hiring and Investment Signals with role counts, JD evidence, salary ranges, and build-vs-buy analysis. Executive Profiles with backgrounds and meeting framing. ICP-to-Priority Mapping ("You said X → We found Y → Algolia does Z").

ACT 4 — THE RESOLUTION (Slides 23-28): How Algolia fixes it. Product-to-pain mapping showing which Algolia capability addresses which gap. Technical architecture fit diagram. Business case with full ROI math (addressable revenue, conversion lift, opportunity size). 30-day pilot plan with KPIs, milestones, and timeline. Clear CTA with specific next steps and named stakeholders.

APPENDIX (Slides 29-33): Sources with hyperlinks. Full test query matrix with all queries, categories, results, and scores. Full traffic source data with keyword table and channel breakdown.

STORYTELLING RULES: Use section divider slides between Acts with the Act name. Every content slide must have a transition hook to the next slide. Build emotional tension through Acts 1-3, release in Act 4. The deck is a STORY — each slide is a scene, each Act is a chapter. The final slide must feel like a satisfying conclusion with clear momentum toward action, not an abrupt ending.

DEPTH RULES: Company Snapshot must include full financial tables with enriched executive profiles. Competitor slides must include BuiltWith-verified search providers and dead technology counts. Hiring slides must include multi-source methodology, salary ranges, and JD quote evidence. Never compress multi-dimensional data into thin one-line summaries — give rich data its own dedicated slide.
