---
name: algolia-search-audit
description: Run a comprehensive Algolia Search Audit on a prospect website with browser tests and report.
---

# Algolia Search Audit

Run a full search experience audit on a prospect's e-commerce or content website, producing a detailed findings report with screenshots, industry benchmarks, Algolia solution recommendations, an Algolia-branded presentation deck, an AE pre-call brief, and a strategic signal brief. Includes investor intelligence from SEC filings and earnings calls, deep hiring analysis from actual careers pages, and buying committee mapping with named stakeholders. Every deliverable uses full Algolia brand standards and hyperlinked source citations for instant credibility.

## Universal Mandate — Screenshots & Source Citations

These rules apply to ALL phases and ALL 3 deliverables (PDF book, AE brief, signal brief), with NO exceptions.

**Screenshots**: Every finding MUST reference the actual screenshot file from `screenshots/`. In the PDF book, screenshots are embedded via `<img src="screenshots/...">` tags. Chrome MCP screenshot imageIds are session-bound and USELESS after session ends — files MUST exist on disk. Without screenshots, findings are unverifiable claims.

**Source Citations**: Every data point MUST have a clickable hyperlink to its source:
- Financial figures → Yahoo Finance or SEC EDGAR URL
- Traffic stats → SimilarWeb URL
- Technology claims → BuiltWith URL
- Industry benchmarks → Baymard, Forrester, or source study URL
- Competitor data → BuiltWith per competitor + SimilarWeb
- Hiring signals → Careers page URL
- Investor quotes → Earnings transcript, 10-K, 10-Q, or investor presentation URL
- Case studies → Algolia customer page URL

**Citation format by deliverable**:
- **PDF Book** (`search-audit-book.pdf`): Inline `<a class="cite">[N]</a>` numbered references + `<span class="source-tag">` visual badges per section + full bibliography in Appendix F
- **AE brief** (`ae-precall-brief.md`): Inline markdown hyperlinks `[Source](URL)` on every data point
- **Signal brief** (`strategic-signal-brief.md`): `SOURCE: {url}` on every line

**A deliverable without sources is INCOMPLETE. A finding without a screenshot is UNVERIFIABLE. Neither is acceptable.**

**MCP-First Data Collection**: Always prefer MCP server data over WebSearch. Use WebSearch only for narrative context, executive bios, hiring signals, and earnings call transcripts where no structured MCP endpoint exists.

## Input

Accept a website URL as `$ARGUMENTS` (e.g., `autozone.com`, `lacoste.com`). If no URL is provided, ask the user for the prospect's website.

Optionally the user may also provide:
- Company name (if different from domain)
- Industry vertical
- `--phase {phase}` flag to run only a specific part of the audit (see below)
- Multiple phases can be combined: `--phase financials,hiring,intel`

### Phase Flags (Modular Invocation)

By default (no `--phase` flag), the full audit runs end-to-end. Use `--phase` to run individual modules independently.

| Flag | What It Runs | Steps | Output | Tools Used |
|------|-------------|-------|--------|------------|
| `--phase company` | Company context, executives, vertical classification | Step 1 | `01-company-context.md` | WebSearch, Yahoo Finance MCP, BuiltWith MCP (`keywords-api`) |
| `--phase techstack` | BuiltWith technology deep dive (current + removed + added) | Step 2 | `02-tech-stack.md` | BuiltWith MCP (`domain-lookup`, `relationships-api`, `recommendations-api`, `financial-api`, `social-api`, `trust-api`) |
| `--phase traffic` | SimilarWeb traffic, demographics, audience, keywords, ranking, referrals, popular pages | Step 3 | `03-traffic-data.md` | SimilarWeb MCP (11 endpoints) |
| `--phase competitors` | Competitor identification + search provider analysis | Steps 4, 6 | `04-competitors.md` | SimilarWeb MCP (`similar-sites`, `keywords-competitors`), BuiltWith per competitor |
| `--phase financials` | 3-year financial trends, margin zone, ROI estimate | Steps 1 (financial), 9 | `01-company-context.md`, `08-financial-profile.md` | Yahoo Finance MCP (all financial tools), WebSearch |
| `--phase hiring` | Hiring signals + deep careers page analysis (Chrome MCP) | Steps 8, 13 | `07-hiring-signals.md` | WebSearch, Chrome MCP (careers page visit) |
| `--phase intel` | Investor intelligence: 10-K, 10-Q, earnings calls, investor presentations | Step 12 | `11-investor-intelligence.md` | SEC EDGAR MCP, Yahoo Finance MCP, WebSearch, WebFetch |
| `--phase strategic` | Strategic angles, trigger events, negative signals | Steps 7, 10 | `06-strategic-context.md` | WebSearch |
| `--phase queries` | Generate vertical-calibrated test queries | Steps 5, 11 | `05-test-queries.md` | Reads `01-company-context.md` for vertical |
| `--phase research` | **ALL of Phase 1** (steps 1-14) — no browser testing | Steps 1-14 | All scratchpad files (01-12) | All research tools |
| `--phase searchaudit` | **Browser-based search testing + scoring** (Phase 2 + 3) | Steps 2a-2t, Phase 3 | `09-browser-findings.md`, `10-scoring-matrix.md`, `screenshots/` | Chrome MCP |
| `--phase deliverables` | **Generate all 3 output files** (PDF book + AE brief + signal brief) from existing scratchpad data | Phases 4-5 | PDF book + AE brief + signal brief | Reads scratchpad files, Chrome headless for PDF |
| `--phase book` | Generate only the PDF book | Phase 5a | `{company}-search-audit-book.pdf` | Reads scratchpad files, Chrome headless |
| `--phase aebrief` | Generate only the AE pre-call brief | Phase 5b | `{company}-ae-precall-brief.md` | Reads scratchpad files |
| *(no flag)* | **Full audit** — all phases end-to-end | Everything | All scratchpad + PDF book + AE brief + signal brief + screenshots | All tools |

**Combining phases**: Use comma-separated values: `/algolia-search-audit costco.com --phase financials,hiring,intel`

**Common workflows**:
- **Quick financial check**: `--phase financials`
- **Research only (no browser)**: `--phase research`
- **Browser testing only (already have research)**: `--phase searchaudit`
- **Regenerate deliverables (data already collected)**: `--phase deliverables`
- **Regenerate just the book PDF**: `--phase book`
- **Deep intel package**: `--phase financials,intel,hiring,strategic`

### Argument Parsing Rules

1. **Parse `$ARGUMENTS`**: Extract the URL (first non-flag argument) and any `--phase` flag value
2. **If `--phase` is present**: Run ONLY the specified phase(s). Skip all other phases. Still create workspace if it doesn't exist.
3. **If no `--phase`**: Run the full audit (default behavior)
4. **Dependency handling**: If a required scratchpad file is missing, warn the user — do NOT silently skip.
5. **Workspace reuse**: All phases write to the same `{company}-audit-workspace/` directory.
6. **Gate checks**: Only run gates relevant to the phase(s) being executed.

### Phase Dependencies

```
company ──────────┐
techstack ────────┤
traffic ──────────┤
competitors ──────┤── queries (needs vertical from company)
financials ───────┤
hiring ───────────┤── strategic (needs signals from all above)
intel ────────────┘
                   ↓
            searchaudit (needs queries from 'queries' phase)
                   ↓
              scoring (part of searchaudit)
                   ↓
            deliverables (needs scratchpad files + screenshots)
               ├── book (HTML template → Chrome headless PDF)
               ├── aebrief
               └── signalbrief
```

## Execution Mode: Agent Teams

When running the full audit (no `--phase` flag) or `--phase research`, use agent teams for parallel execution. The orchestrator spawns specialized agents per wave.

**Prerequisites**:
- Install `claude-sneakpeek` to unlock Agent Teams tools (TeammateTool, SendMessage, spawnTeam): `npx @realmikekelly/claude-sneakpeek quick --name claudesp`
- Run audits via `claudesp` (not `claude` or VS Code extension)
- Teammates inherit the lead's permissions at spawn time

### Wave 1 — Independent Research (parallel, no dependencies)

| Agent | Steps | Tools | Output |
|-------|-------|-------|--------|
| Agent A | Step 1: Company context + financials | Yahoo Finance MCP, BuiltWith `keywords-api`, WebSearch | `01-company-context.md` |
| Agent B | Step 2: Tech stack deep dive | BuiltWith MCP (6 endpoints) | `02-tech-stack.md` |
| Agent C | Step 3: Traffic & engagement | SimilarWeb MCP (11 endpoints) | `03-traffic-data.md` |
| Agent D | Step 4: Competitor identification | SimilarWeb MCP (2 endpoints) | `04-competitors.md` |

### Wave 2 — Dependent Research (parallel, after Wave 1 completes)

| Agent | Steps | Reads | Output |
|-------|-------|-------|--------|
| Agent E | Steps 5+11: Test queries + vertical matching | `01-company-context.md` | `05-test-queries.md` |
| Agent F | Step 6: Competitor search analysis | `04-competitors.md` | Appends to `04-competitors.md` |
| Agent G | Steps 7+10: Strategic angles + trigger events | All Wave 1 files | `06-strategic-context.md` |
| Agent H | Step 8: Hiring signals | `01-company-context.md` | `07-hiring-signals.md` |
| Agent I | Step 9: Financial synthesis + ROI | `01-company-context.md`, `03-traffic-data.md` | `08-financial-profile.md` |

### Wave 3 — Deep Intelligence (parallel, after Wave 1+2)

| Agent | Steps | Reads | Output |
|-------|-------|-------|--------|
| Agent J | Step 12: Investor intelligence | `01-company-context.md` (for ticker) | `11-investor-intelligence.md` |
| Agent K | Step 13: Deep hiring + buying committee | `07-hiring-signals.md` | Appends to `07-hiring-signals.md` |

### Wave 4 — Synthesis (sequential)

Step 14: ICP-to-Priority Mapping. Reads `11-investor-intelligence.md` + `08-financial-profile.md`. Writes to `12-icp-priority-mapping.md`.

### Phase 2: Sequential

Browser interaction cannot be parallelized — run all 20 steps sequentially in Chrome MCP.

### Phase 5: Deliverable Generation (parallel where possible)

| Agent | Deliverable | Depends On |
|-------|------------|------------|
| Agent L | Report (Phase 4) | All scratchpad files |
| Agent M | Deck (Phase 5b) | Report exists |
| Agent N | Landing page (Phase 5a) | Report exists |
| Agent O | AE brief + Signal brief (Phase 5e+5f) | Report exists |

## Process

### Phase 0: Workspace Setup

Before starting, create the scratchpad workspace:
```
{company}-audit-workspace/
├── 01-company-context.md
├── 02-tech-stack.md
├── 03-traffic-data.md
├── 04-competitors.md
├── 05-test-queries.md
├── 06-strategic-context.md
├── 07-hiring-signals.md
├── 08-financial-profile.md
├── 09-browser-findings.md
├── 10-scoring-matrix.md
├── 11-investor-intelligence.md
├── 12-icp-priority-mapping.md
├── screenshots/
└── _workspace-manifest.md
```
Create `_workspace-manifest.md` with all steps listed as `[ ] pending`. Update each to `[x] done` as completed. This enables resume if context resets.

**CRITICAL: Book Chapter Checklist** — Also add this checklist to `_workspace-manifest.md`. Each chapter MUST be marked done during Phase 5a book assembly:
```markdown
## Book Chapter Completion (Phase 5a)
### Act I: The Verdict
[ ] Ch 1: Bottom Line (KPI dashboard + score meter)
[ ] Ch 2: Company Snapshot (at-a-glance profile + key strategic signal)
[ ] Ch 3: Opportunity (revenue funnel)
[ ] Ch 4: The Ask (timeline + financial card)

### Act II: The Proof
[ ] Ch 5: Scorecard (dual panel)
[ ] Ch 6-12: Findings (one per major gap, 5-8 total)
[ ] Ch 13: In Their Words (strategy vs execution)

### Act III: Why Now
[ ] Ch 14: Tech Stack (stack diagram)
[ ] Ch 15: AI Gap (balance scale)
[ ] Ch 16: Competitors (table + donut chart)
[ ] Ch 17: Hiring (bar chart + callout)
[ ] Ch 18: Leadership (quotes)

### Act IV: The Path
[ ] Ch 19: Architecture (flow diagram)
[ ] Ch 20: Buying Committee (exec cards)
[ ] Ch 21: Pilot Roadmap (timeline + financial)
[ ] Ch 22: Next Steps (closing CTA)

### Appendices
[ ] Appendix A: Scoring Matrix
[ ] Appendix B: Tech Stack Detail
[ ] Appendix C: Traffic & Demographics
[ ] Appendix D: Financial Profile
[ ] Appendix E: Test Queries
[ ] Appendix F: Bibliography
```
**WHY**: Context compaction during book assembly causes chapters to be skipped. This checklist enables verification and resume.

### Phase 1: Pre-Audit Research (14 steps — no browser needed except Step 13)

> **Pattern per step**: Run MCP/API call → Write structured results to scratchpad file → Continue to next step. This prevents context overflow from ~35K tokens of raw Phase 1 data.
>
> **Source URL capture**: For every data point written to a scratchpad file, ALSO capture the source URL AND tag it as FACT, ESTIMATE, or OBSERVED:
> ```
> Revenue: $254.2B (FY2024) [FACT]
>   Source: https://finance.yahoo.com/quote/COST
> Employees: ~2,000 (estimated after 2025 layoffs) [ESTIMATE]
>   Source: https://www.retaildive.com/... (article discusses layoffs but not exact headcount)
> New items: "10,000+ New Items" [OBSERVED]
>   Source: observed on homepage during browser audit
> Monthly visits: 187M [FACT]
>   Source: https://www.similarweb.com/website/costco.com/
> ```
>
> **Tag rules**: An [ESTIMATE] must never be presented as a [FACT] in deliverables. An [OBSERVED] value from the browser must not be inflated (e.g., "10,000+" must never become "30,000+"). Deliverables must preserve these distinctions — use "estimated" or "approximately" qualifiers for [ESTIMATE] values.

1. **Company Context** — Gather comprehensive company intelligence:
   - **Company overview** (WebSearch): What they do, industry, founding year, employee count, store/warehouse count, recent news
   - **SEO keywords** (BuiltWith `keywords-api`): Meta keywords, page titles — reveals brand positioning and SEO focus
   - **Financial data (3-year trends)** via **Yahoo Finance MCP** (public companies):
     - **Ticker resolution**: Use WebSearch `"{company name}" stock ticker symbol NYSE NASDAQ"` first — Yahoo Finance MCP has no search tool
     - `get_stock_info(ticker)` — sector, industry, employee count, market cap, current price, 52-week range
     - `get_financial_statement(ticker, "income_stmt")` — Revenue, Net Income, Operating Income, EBITDA (3-4 fiscal years)
     - `get_financial_statement(ticker, "balance_sheet")` — Total Assets, Total Debt, Cash
     - `get_financial_statement(ticker, "quarterly_income_stmt")` — most recent quarterly data
     - `get_recommendations(ticker, "recommendations")` — analyst consensus
     - `get_recommendations(ticker, "upgrades_downgrades")` — recent analyst rating changes
     - `get_yahoo_finance_news(ticker)` — latest news for trigger event detection
     - `get_historical_stock_prices(ticker, period="1y")` — 1-year price history
     - **Margin Zone**: Calculate from EBITDA margin → 🔴 Red (≤10%) / 🟡 Yellow (10-20%) / 🟢 Green (>20%)
     - **Fallback for private companies**: 6 WebSearches + Chrome MCP visit to IR page
   - **Strategic leadership deep dive** (WebSearch):
     - **Tier 1 (mandatory)**: CEO, CFO, COO
     - **Tier 2 (critical for Algolia story)**: CTO/CIO, CDO, SVP/VP E-Commerce, SVP/VP Technology
     - **Tier 3 (buying committee context)**: VP Engineering, VP Product, Director of Search/Discovery
     - For each: Name, title, tenure, background, education, notable recognitions
   - **Vertical classification**: Match to vertical-query-library.md categories
   - **Confidence**: Unmarked = 2+ sources agree. ⚠️ = single source or sources disagree.
   - → Write to `01-company-context.md`

2. **Technology Stack Deep Dive** — Use BuiltWith MCP comprehensively:
   - `domain-lookup` — Current search provider, e-commerce platform, analytics, personalization, recommendations
   - `relationships-api` — Sister/related sites
   - `recommendations-api` — Technology gaps and recommendations
   - `financial-api` — Revenue estimates, employee count, funding data (cross-reference Yahoo Finance)
   - `social-api` — Social profile URLs (LinkedIn, Twitter, Facebook — useful for executive research)
   - `trust-api` — Domain trust score, domain age (credibility signal)
   - **Parse "removed" technologies** → displacement signals (e.g., "RichRelevance REMOVED" = vacuum for Algolia Recommend)
   - **Parse "added" technologies in last 6 months** → if search competitor added recently, flag as ⚠️ NEGATIVE SIGNAL
   - Match any detected vendor to displacement quotes in `buyer-persona-reference.md` Section 3
   - Fallback: If BuiltWith credits exhausted, use SimilarWeb `get-website-content-technologies-agg`
   - → Write to `02-tech-stack.md`

3. **Traffic & Engagement Deep Dive** — Use **SimilarWeb MCP ONLY** for all traffic metrics. **DO NOT scrape or WebFetch third-party analytics sites** (Semrush, Ahrefs, SEMrush, Moz, etc.) for traffic/engagement data. These sites use different measurement methodologies than SimilarWeb, and mixing sources creates unverifiable discrepancies. All traffic, engagement, demographics, and ranking data MUST come from SimilarWeb MCP endpoints so the fact-checker can reproduce exact results with identical API calls.

   Use SimilarWeb MCP with ALL of these endpoints:
   - `get-websites-traffic-and-engagement` — monthly visits, bounce rate, pages per visit, avg visit duration
   - `get-websites-traffic-sources` — channel breakdown (organic, direct, paid, social, referral, mail)
   - `get-websites-geography-agg` — top countries by traffic share
   - `get-websites-demographics-agg` — age and gender breakdown
   - `get-website-analysis-keywords-agg` — top keywords driving search traffic (branded vs non-branded)
   - `get-websites-audience-interests-agg` — audience interest categories
   - `get-websites-website-rank` — global rank + category rank (market position)
   - `get-websites-referrals-agg` — incoming referral sites (partnership signals)
   - `get-pages-popular-pages-agg` — top pages by traffic share (reveals what users care about)
   - `get-pages-leading-folders-agg` — top URL folders (reveals site architecture: /search/, /product/, /category/)
   - `get-websites-landing-pages-agg` with `traffic_source: "organic"` — top organic landing pages (SEO focus)
   - Use `country: "ww"` if `"us"` errors
   - **web_source STANDARDIZATION (MANDATORY)**: ALL SimilarWeb API calls for a single audit MUST use `web_source: "total"` (desktop + mobile). If "total" errors, fall back to "desktop" but record the fallback and add "(desktop only)" caveat to ALL traffic metrics. NEVER mix desktop and total values in the same scratchpad file. Record the parameter at the top of `03-traffic-data.md`: `WEB_SOURCE: total`
   - → Write to `03-traffic-data.md`

4. **Competitor Identification** — Use SimilarWeb to find top 3-5 competitors:
   - `get-websites-similar-sites-agg` — top similar sites by audience overlap
   - `get-websites-keywords-competitors-agg` — keyword competitors (organic)
   - Cross-reference both lists to select the top 3-5 most relevant competitors
   - → Write to `04-competitors.md`

5. **Generate Test Queries** — Based on the company's vertical from Step 1:
   - Look up the prospect's vertical in `vertical-query-library.md`
   - Pull 10-12 queries from the matching vertical row (broad, specific, NLP, typo, non-product, brand)
   - Add 4-6 company-specific queries (flagship products, house brands, specific product names found on site)
   - Total: 14-18 queries (vertically calibrated)
   - → Write to `05-test-queries.md`

6. **Competitor Search Analysis** — For each of the top 3-5 competitors:
   a. Use BuiltWith `domain-lookup` to detect their search provider
   b. Use SimilarWeb `get-websites-traffic-and-engagement` for each competitor (quick check — monthly visits and bounce rate)
   c. **Quick search spot-check** (optional, time permitting): Use Chrome MCP to visit 1-2 competitor sites and run a single typo query. Screenshot if competitor handles it better.
   d. **GOLDEN ANGLE**: If ANY competitor uses Algolia, flag prominently. This is the strongest sales angle.
   e. Create competitor matrix:
      | Competitor | Search Provider | Monthly Traffic | Bounce Rate | Uses Algolia? |
   - → Append to `04-competitors.md`

7. **Strategic Angle Mining** — Use WebSearch to find business context:
   a. **Expansion signals**: New stores, new markets, new product lines?
   b. **Digital transformation**: E-commerce investment, mobile app, headless commerce migration?
   c. **Competitive pressure**: Competitors gaining share?
   d. **Industry trends**: Macro trends affecting this vertical
   e. **Negative signal check**: WebSearch for `"{company} layoffs 2025 2026"` + `"{company} earnings miss"` + `"{company} hiring freeze"`
   f. Output: 2-3 strategic angles (1-sentence insight + 1-sentence search connection each)
   - → Write to `06-strategic-context.md`

8. **Hiring Signal Detection** — Detect active buying signals via job postings:
   - WebSearch: `"{company} careers search engineer"` + `"{company} jobs site search OR relevance OR algolia OR elasticsearch"`
   - Match found titles against `buyer-persona-reference.md` Section 1 (Tier 1/2/3 taxonomy)
   - **Signal interpretation**:
     - 🔥 Strong: Tier 1 titles (VP eComm, Director Digital) = budget likely allocated
     - 🟡 Moderate: Tier 2 titles (Engineering Manager, Product Manager) = team building
     - ⚡ Technical: Tier 3 titles (Senior Engineer, Architect) = may be building in-house
     - ⚠️ Caution: "Search Engineer" or "Relevance Engineer" = possible build-vs-buy
   - → Write to `07-hiring-signals.md`

9. **Financial Context Synthesis + ROI Estimate** — Synthesize financial data with trend visualization:

   **3-Year Trend Table (required format)**:
   | Metric | FY2023 | FY2024 | FY2025 | 3-Year CAGR | Trend |
   |--------|--------|--------|--------|-------------|-------|
   | Revenue | ${X} | ${Y} | ${Z} | X% | ↗️/↘️/→ |
   | Net Income | ... | ... | ... | ... | ... |
   | Operating Margin | ... | ... | ... | — | ... |
   | EBITDA | ... | ... | ... | ... | ... |
   | E-commerce Revenue | ... | ... | ... | ... | ... |
   | E-commerce % of Total | ... | ... | ... | — | ... |
   | Digital/Tech Capex | ... | ... | ... | ... | ... |

   **Trend Analysis**: Calculate YoY growth rates. Flag divergences (e.g., "Revenue growing 8% but e-commerce growing 22% = digital acceleration"). Flag margin compression.

   **Graph Specification (for deck)**: Multi-line indexed chart: Revenue (Algolia Purple #5468FF), E-commerce (Nebula Blue #003DFF), Net Income (Space Gray #21243D). Annotations at inflection points.

   **ROI estimate formula** (show the math):
   ```
   Revenue Addressable = Total Revenue × Digital Share × Search-Driven Share (15%)
   Conservative (5% improvement) = Revenue Addressable × 0.05
   Moderate (10% improvement) = Revenue Addressable × 0.10
   ```
   - Cite benchmarks: Lacoste +37% search revenue, Decathlon +50% search conversion
   - **Guardrails**: Always show formula + inputs + sources. Label as "directional estimate." Never present as guarantee.
   - → Write to `08-financial-profile.md`

10. **Trigger Event Synthesis** — Cross-reference all signals from Steps 1-9:
    - Top 3 **positive trigger events** (e.g., "Search vendor removed + hiring search engineers + digital sales +20%")
    - Any **⚠️ caution signals** (e.g., "Coveo added 4 months ago", "layoffs announced")
    - → Append to `06-strategic-context.md`

11. **Vertical Matching** — Select best case studies for this prospect:
    - Match prospect vertical to `buyer-persona-reference.md` Section 2
    - Select primary + secondary case study
    - If BuiltWith detected a specific competitor vendor, select matching displacement quote from Section 3
    - → Append to `01-company-context.md`

12. **Investor Intelligence** — Extract the company's stated strategic priorities using their OWN words from SEC filings, earnings calls, investor presentations, and investor day transcripts. This is the most powerful sales intelligence because it is unimpeachable — they said it themselves, on the record, to investors.

    **For public companies** (verified filings via **SEC EDGAR MCP** + **Yahoo Finance MCP**):

    a. **Retrieve Latest 10-K AND 10-Q** — Use SEC EDGAR MCP:
       - `search_filings(ticker, filing_type='10-K')` for annual filing
       - `search_filings(ticker, filing_type='10-Q')` for most recent quarterly filing (often has more current data than 10-K)

    b. **Extract Strategic Narrative (MD&A)** — Use SEC EDGAR MCP:
       - `get_section_text(accession_number, section='MD&A')` from 10-K (Item 7) AND 10-Q (Item 2)
       - Scan for: e-commerce growth targets, "digital transformation," "omnichannel," search, discovery, AI, personalization, technology investment

    c. **Extract Risk Factors** — Use SEC EDGAR MCP:
       - `get_section_text(accession_number, section='Risk Factors')` (Item 1A)
       - Look for: "competition," "technology infrastructure," "cybersecurity," "customer experience," "digital capabilities"

    d. **Earnings Call Transcripts** — The most quotable source. Executives speak candidly.
       - WebSearch: `"{company} Q4 2025 earnings call transcript"` — try last 3 quarters
       - WebFetch on Seeking Alpha, Motley Fool, or company IR page for actual transcript text
       - Yahoo Finance MCP: `get_yahoo_finance_news(ticker)` for earnings coverage
       - **Capture quotes from ANY named speaker** — CEO, CFO, CTO, COO, SVP, VP, or any executive on the call. Do NOT limit to CEO/CFO only.
       - **Cast a WIDE net**: Search LAST 3 QUARTERS of earnings calls. Also search for investor day presentations and analyst day transcripts.

    e. **Investor Presentations & Investor Days** — Primary sources for strategic direction:
       - WebSearch: `"{company} investor day 2025 presentation"` + `"{company} investor presentation 2025 2026"`
       - WebFetch on company IR page or Seeking Alpha for slides/transcripts
       - These often contain detailed technology roadmaps and digital strategy commitments not found in 10-K filings

    f. **Analyst Estimates & Ratings** — Forward-looking context:
       - Yahoo Finance MCP: `get_recommendations(ticker, "recommendations")` for analyst consensus
       - Yahoo Finance MCP: `get_recommendations(ticker, "upgrades_downgrades")` for recent changes

    g. **Multi-Year Financial Trend Analysis** — 3-year trajectory reveals strategic direction:
       - Yahoo Finance MCP: `get_financial_statement(ticker, "income_stmt")` — 3-year trends
       - Yahoo Finance MCP: `get_financial_statement(ticker, "balance_sheet")` — capex, cash, debt
       - Yahoo Finance MCP: `get_financial_statement(ticker, "cashflow")` — free cash flow, capex allocation
       - Yahoo Finance MCP: `get_historical_stock_prices(ticker, period="2y")` — 2-year stock trajectory

    h. **Supplemental WebSearch** (only if above steps return insufficient data):
       - `"{company} CEO keynote conference 2025 2026"` + `"{company} technology roadmap"`

    **For private companies** (fallback):
    - WebSearch: CEO interviews, funding rounds, press releases, conference talks

    **Extraction targets**:
    - 5-8 direct quotes from **any executive** speaking (CEO, CFO, CTO, COO, SVP, VP, or any named speaker) about digital/technology/e-commerce priorities — across MULTIPLE earnings calls and investor presentations
    - Stated e-commerce revenue target or growth goal (forward guidance to Wall Street)
    - Capex allocation: what % goes to digital vs. physical expansion (3-year trend)
    - Risk factors mentioning technology, digital capability, or customer experience gaps
    - Analyst consensus sentiment on digital transformation
    - Any stated timelines for technology modernization or platform migrations
    - Any mention of search, discovery, recommendations, personalization, AI in filings
    - Stated priorities that map to Algolia products (even if not directly about search)

    **Output** → Write to `11-investor-intelligence.md`:
    ```
    ## Investor Intelligence — {Company}

    ### In Their Own Words (Sourced Quotes)
    | # | Speaker | Title | Quote | Source | Date | Source URL | Maps To |
    |---|---------|-------|-------|--------|------|-----------|---------|
    | 1 | {Name} | {Title} | "{exact quote}" | Q4 FY2025 Earnings Call | Feb 2025 | {url} | Algolia NeuralSearch |

    ### Forward Guidance
    - E-commerce revenue target: {stated target or "not disclosed"}
    - Digital investment: {stated capex or "not disclosed"}

    ### Risk Factors Mentioning Digital/Technology
    - {risk factor text, paraphrased, with source}

    ### Strategic Priorities (from filings)
    1. {priority 1 — with source + URL}
    ```

    **Guardrails**:
    - Always cite source + date + URL + speaker name + title for every quote
    - Use "the company stated" not "the company believes"
    - NEVER fabricate quotes — if not found, say "Limited public investor data available"
    - If no investor data found at all, note it and skip section gracefully

13. **Deep Hiring Analysis + Buying Committee Mapping** — Go beyond web search to actually visit the company's careers page.

    **Phase A: Web Search** (from Step 8 data):
    - Additional: `"{company} LinkedIn jobs e-commerce OR digital OR search"`

    **Phase B: Browser Visit** (Chrome MCP):
    - Navigate to company careers page
    - Search for keywords: "search", "relevance", "AI", "machine learning", "e-commerce", "digital", "discovery"
    - Take screenshot of search results
    - Count total roles by category (Engineering, Product, Data, eCommerce, Merchandising)
    - Click into 2-3 most relevant JDs and extract: skills, team, responsibilities, technologies, source URL

    **Phase C: Buying Committee Mapping** — Identify the actual buying committee:

    | Role Type | Description | Typical Titles |
    |-----------|-------------|----------------|
    | **Economic Buyer** | Signs the check, owns budget | VP Digital, VP eCommerce, SVP Retail Technology, CDO |
    | **Technical Buyer** | Evaluates feasibility | Director of Engineering, Head of Platform, Principal Architect |
    | **User Buyer** | Daily user, feels the pain | Director of Merchandising, Head of Search Ops, eCommerce Manager |
    | **Champion** | Internal advocate | Product Manager (Search/Discovery), Search Engineer |

    Research Steps:
    1. LinkedIn Search (WebSearch — 4 queries): `site:linkedin.com "{company}" "VP eCommerce"`, etc.
    2. For each person found: Name, Title, LinkedIn URL, Tenure, Previous company, Buyer role, Priority signal
    3. Prioritization: 🔥 Hot (new in role + ex-Algolia customer), 🟡 Warm (new OR search background), ⚡ Technical (deep tech), 👤 User (daily user)

    **Output** → Append to `07-hiring-signals.md` (includes hiring analysis AND buying committee map with stakeholder table and recommended outreach sequence)

    **Fallback**: If careers page is behind auth, fall back to LinkedIn Jobs + Indeed web searches.

14. **ICP-to-Priority Mapping** (synthesis step, no new API calls) — Cross-reference investor intelligence + financial profile + audit scoring for the most powerful framing: "You said X → We found Y → Algolia does Z"

    **Input files**: `11-investor-intelligence.md`, `08-financial-profile.md`, `10-scoring-matrix.md` (after Phase 3), `01-company-context.md`

    **Process**:
    1. For each stated priority from investor intelligence: find matching Algolia product
    2. For each major audit gap: find supporting investor quote (if available)
    3. Create discovery questions using the company's OWN language

    **Note**: Preliminary mapping after Phase 1. Refined after Phase 3 with specific audit findings.

    **Output** → Write to `12-icp-priority-mapping.md`:
    ```
    ## ICP-to-Priority Mapping — "Speaking Their Language"

    ### Priority-to-Product Map
    | Their Stated Priority | Source | Algolia Solution | Discovery Question |
    |---|---|---|---|
    | "{exact quote from executive}" | Q4 2025 Earnings | NeuralSearch | "You told investors X — we can help with Y" |

    ### Anchor Points for AE
    1. "{Company} told investors {X} — we can accelerate that with {product}"
    ```

### Phase 2: Browser-Based Search Audit (20 steps)

> **SCREENSHOT PERSISTENCE**: Before starting Phase 2, run `mkdir -p screenshots/`. Every screenshot instruction means: (1) Chrome MCP `computer` action `screenshot`, (2) IMMEDIATELY persist to disk in `screenshots/`, (3) VERIFY with `ls -la screenshots/{filename}`.

> **Scratchpad**: Append all observations to `09-browser-findings.md` after each step.

#### Phase 2 Pre-Flight Checklist (MANDATORY)

Before starting any browser tests, verify these prerequisites:

**1. Chrome MCP Configuration Check**
```bash
grep -A3 '"chrome"' ~/.claude/mcp_settings.json
```
Expected output:
```json
"chrome": {
  "command": "npx",
  "args": ["-y", "chrome-devtools-mcp"]
}
```
If Chrome MCP is NOT configured:
- Add the above block to `~/.claude/mcp_settings.json`
- Inform the user they must restart Claude Code for MCP changes to take effect
- **STOP** — do not proceed with browser testing until Chrome MCP is available

**2. Launch Chrome with Remote Debugging**
If Chrome MCP connection fails OR if WAF blocks the browser, instruct the user to run:
```bash
# Kill any existing Chrome instances first
pkill -f "Google Chrome" || true

# Launch Chrome with remote debugging enabled
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir="/tmp/chrome-debug-profile" &
```
Wait 3 seconds for Chrome to start, then verify:
```bash
curl -s http://127.0.0.1:9222/json/version | head -1
```
Expected: JSON response with Chrome version info.

**3. Puppeteer-Core Fallback Setup**
If Chrome MCP is unavailable or unreliable, use puppeteer-core to connect to the running Chrome:
```bash
cd {company}-audit-workspace && npm install puppeteer-core
```
Then use this connection pattern in browser scripts:
```javascript
const puppeteer = require('puppeteer-core');
const browser = await puppeteer.connect({
  browserURL: 'http://127.0.0.1:9222',
  defaultViewport: { width: 1920, height: 1080 }
});
const pages = await browser.pages();
const page = pages[0] || await browser.newPage();
// Use page.goto(), page.type(), page.screenshot() etc.
```
**Critical**: Connect to EXISTING Chrome — do NOT use `puppeteer.launch()` which creates a new headless instance that triggers WAF.

#### Browser Audit Resilience — Anti-Detection Best Practices

1. **Use Chrome MCP** (real Chrome browser with user profile) — NOT headless Puppeteer for audit testing
2. Before starting, resize window to standard desktop: `resize_window` → 1440x900
3. Navigate to homepage first, wait 3-5 seconds before any interaction
4. Type queries character-by-character with human-like timing (use `type` action, not paste)
5. Between test steps, wait 2-3 seconds (natural browsing pace)
6. **If CAPTCHA appears**:
   a. Take a screenshot of the CAPTCHA
   b. Ask the user to solve it manually in the Chrome window
   c. Wait for user confirmation, then continue
   d. Do NOT attempt to bypass or auto-solve CAPTCHAs
7. **If blocked by WAF/Cloudflare challenge**:
   a. Wait 10 seconds and retry navigation
   b. If still blocked, navigate to homepage first, then use site search
   c. If persistently blocked, note limitation in findings and proceed with available data
8. Never use Puppeteer MCP for actual audit testing — it triggers bot detection
9. Puppeteer MCP is acceptable ONLY for screenshot persistence (fallback method)
10. Cookie consent: Decline cookies when prompted (privacy-preserving)

#### WAF Detection & Recovery Protocol

Many e-commerce sites use Akamai, Cloudflare, or Imperva WAF that block automated browsers. Detection signals:
- Page title contains "Access Denied", "Just a moment", "Checking your browser"
- Page body shows CAPTCHA, "ray ID", or challenge interstitial
- Screenshot file size is suspiciously small (<50KB = likely error page, not real content)
- HTTP 403/429 responses

**Recovery Steps (escalating)**:
1. **Retry with delay**: Wait 10 seconds, retry navigation
2. **Homepage-first approach**: Navigate to homepage, wait 5 seconds, THEN navigate to search
3. **Switch to real Chrome**: Kill any headless processes, use Chrome with remote debugging (see Pre-Flight step 2)
4. **User intervention**: If still blocked after 3 attempts, ask user to:
   - Manually navigate to the site in the Chrome window
   - Complete any CAPTCHA/challenge
   - Confirm when ready, then continue automation from that point
5. **Document limitation**: If site remains blocked, note in findings: "WAF blocked automated testing — limited screenshots available"

#### Search Input Selector Resilience

E-commerce sites use various selectors for search inputs. Try these in order until one works (5-second timeout each):

```javascript
const SEARCH_SELECTORS = [
  '#SearchInput',                        // Common SFCC
  'input[type="search"]',                // Semantic HTML5
  'input[name="q"]',                     // Google-style
  'input[name="search"]',                // Generic
  'input[placeholder*="Search" i]',      // Placeholder-based (case-insensitive)
  'input[placeholder*="search" i]',      // Lowercase variant
  '[data-testid="search-input"]',        // React test ID
  '[data-testid*="search" i]',           // Partial test ID
  '.search-input',                       // Class-based
  '.searchInput',                        // CamelCase class
  '#search-input',                       // ID-based
  'input[aria-label*="Search" i]',       // Accessibility
  'header input[type="text"]',           // Header text input fallback
];

async function findSearchInput(page) {
  for (const selector of SEARCH_SELECTORS) {
    try {
      await page.waitForSelector(selector, { timeout: 5000 });
      return selector;
    } catch (e) {
      continue; // Try next selector
    }
  }
  throw new Error('No search input found with any known selector');
}
```

If all selectors fail, take a screenshot of the page and manually inspect the DOM to identify the correct selector.

Open the website in the browser and systematically test:

> **CORE AUDIT (Steps 2a-2l)** — Foundation of every search audit. Execute in full.

#### Step 2a: Initial Observations
- Navigate to the homepage
- Take a screenshot of the homepage with search bar visible
- Note: Is search prominent? Icon or full bar? Position?

#### Step 2b: Empty State Test
- Click on the search bar WITHOUT typing
- Take a screenshot
- Note: Popular searches, trending, recent searches, or nothing?

#### Step 2c: Search-As-You-Type (SAYT) Test
- Type a broad category query letter by letter
- Take a screenshot mid-typing (after 3-4 characters)
- Note: Autocomplete speed, content (products, categories, suggestions), latency

#### Step 2d: Full Search Results Test
- Submit the full query and land on results page
- Take a screenshot
- Note: Result quality, layout, filters/facets, sort options, result count
- Check: At least 4 sort options? Relevant facets with count badges?

#### Step 2e: Typo Tolerance Test
- Search each misspelled query from test list
- Take a screenshot per typo search
- Note: Returns results? "Did you mean..."? Or zero results?

#### Step 2f: Synonym / Colloquial Test
- Search synonym queries
- Note: Does "couch" = "sofa"? Site understands colloquial terms?

#### Step 2g: No Results Test
- Search nonsense query ("asdfghjk")
- Take a screenshot
- Note: Suggestions? Popular products? Just "no results found"?

#### Step 2h: Non-Product Content Test
- Search "return policy", "customer service", "store hours"
- Take a screenshot
- Note: Content/help pages returned? Or only products (or nothing)?

#### Step 2i: Intent Detection Test
- Brand name → redirect to brand page or filter?
- Category name → suggest category?
- Attribute + product ("black chest", "red shoes") → apply filters?

#### Step 2j: Merchandising Consistency Test
- Search a category term, then navigate to same category via menu
- Take screenshots of both views
- Note: Same products? Same order? Different merchandising?

#### Step 2k: Federated Search Check
- During SAYT, note: Products, categories, content pages, brand pages? Or products-only?

#### Step 2l: Mobile Experience
- Resize browser to mobile viewport
- Quick search test
- Note: Mobile search experience quality, responsiveness

> **ALGOLIA VALUE-PROP TESTS (Steps 2m-2t)** — Map to Algolia products for strategic differentiation.

#### Step 2m: Semantic / Natural Language Search (→ Algolia NeuralSearch)
- Test 2-3 NLP queries: conversational, multi-attribute, question-format
- Compare with keyword-equivalent queries
- Take screenshots. Note: Intent understanding or just keyword-match?

#### Step 2n: Dynamic Facets & Filtering (→ Algolia Dynamic Faceting)
- Search 2-3 different categories, observe filter panels
- Take screenshots. Note: Filters change by category context? Or static/generic?

#### Step 2o: Popular & Recent Searches (→ Algolia Query Suggestions)
- Click search bar → popular/trending suggestions?
- Search, navigate away, return → recent searches shown?
- Take screenshots.

#### Step 2p: Dynamic Search Categories (→ Algolia Federated Search + Rules)
- While typing, observe dynamic category suggestions (e.g., "nike" → "Nike Running Shoes")
- Take screenshot if present.

#### Step 2q: Personalization Signals (→ Algolia Personalization)
- Browse a specific category (click 3-4 products), then search a broad term
- Look for: "Recommended for you", personalized carousels, re-ranked results

#### Step 2r: Recommendations / FBT (→ Algolia Recommend)
- Navigate to 2-3 product detail pages
- Take screenshots of recommendation sections
- Note: "Frequently bought together", "Similar items" — relevant or generic?

#### Step 2s: Banners & Merchandising Rules (→ Algolia Rules Engine)
- Search seasonal/campaign terms ("sale", "clearance")
- Search brand name → curated brand experience?
- Take screenshots of promotional content.

#### Step 2t: Analytics Visibility (→ Algolia Analytics)
- Look for: "trending" badges, "bestseller" tags, "most searched" labels
- Note: Visible analytics signals = strength; none = gap

### Screenshot Handling & Persistence

Screenshots are the #1 audit artifact — PROOF that testing was done.

> **FAILURE MODE TO AVOID**: Taking a Chrome MCP screenshot (getting imageId) but never writing to disk.

**Capture Procedure (for EACH screenshot)**:

1. Navigate & interact in Chrome MCP to desired page state
2. Take screenshot using Chrome MCP `computer` tool with `action: "screenshot"` → get imageId
3. **IMMEDIATELY persist to disk** using one of these methods (try in order):

   **Method 1 — Puppeteer MCP fallback**:
   Use `puppeteer_navigate` to same URL, then `puppeteer_screenshot` with `name: "{nn}-{slug}"`. Saves to disk automatically.

   **Method 2 — Chrome MCP download**:
   Use Chrome MCP `javascript_tool` to trigger download via html2canvas or canvas capture. Move from Downloads to `screenshots/` via Bash.

   **Method 3 — Chrome DevTools Protocol**:
   Capture viewport via canvas, convert to data URL, write base64 to disk via Bash.

4. **VERIFY file exists**: `ls -la screenshots/{nn}-{slug}.png`
5. **Log to scratchpad** in `09-browser-findings.md`:
   ```
   ### Step 2x: {Test Name}
   - Query: "{query}"
   - Screenshot: screenshots/{nn}-{slug}.png (VERIFIED ON DISK)
   - Result count: {n}
   - Observation: {what happened}
   ```

**Naming Convention**:
```
screenshots/
├── 01-homepage.png
├── 02-empty-state.png
├── 03-sayt-mid-type.png
├── 04-full-results-{query}.png
├── 05-typo-{query}.png
├── 06-synonym-{query}.png
├── 07-no-results.png
├── 08-non-product-{query}.png
├── 09-intent-{query}.png
├── 10-merchandising.png
├── 11-federated.png
├── 12-mobile-{query}.png
├── 13-nlp-{query}.png
├── 14-dynamic-facets.png
├── 15-popular-searches.png
├── 16-dynamic-categories.png
├── 17-personalization.png
├── 18-recommendations.png
├── 19-banners.png
├── 20-analytics.png
```

### Phase 3: Analyze & Score Findings

> Write the complete scoring matrix to `10-scoring-matrix.md`.

For each of the 10 challenge areas, assign severity:

**Core Challenge Areas (1-6)**:

| Area | Severity Criteria |
|------|------------------|
| **Latency** | HIGH: >500ms or full page reload. MEDIUM: 300-500ms. LOW: <300ms |
| **Typo Tolerance** | HIGH: No typo handling. MEDIUM: Partial. LOW: Good tolerance |
| **Query Suggestions / Empty State** | HIGH: Blank empty state + poor no-results. MEDIUM: One lacking. LOW: Both good |
| **Intent Detection** | HIGH: No category/brand/attribute detection. MEDIUM: Partial. LOW: Good |
| **Merchandising Consistency** | HIGH: Major search/browse differences. MEDIUM: Minor. LOW: Consistent |
| **Content Commerce / Front-End UX** | HIGH: No federated search + poor UX. MEDIUM: Some issues. LOW: Good |

**Algolia Value-Prop Areas (7-10)**:

| Area | Severity Criteria |
|------|------------------|
| **Semantic / NLP Search** | HIGH: Pure keyword match. MEDIUM: Partial NLP. LOW: Good semantic understanding |
| **Dynamic Facets & Personalization** | HIGH: Static filters + no personalization. MEDIUM: Some. LOW: Dynamic + visible |
| **Recommendations & Merchandising** | HIGH: No recs + no banners. MEDIUM: Some. LOW: Relevant recs + active rules |
| **Search Intelligence** | HIGH: No trending/popular/analytics signals. MEDIUM: 1-2 present. LOW: 3+ present |

**Overall Score Calculation Formula**:

Use a weighted average where HIGH-severity areas receive 2x weight, penalizing critical gaps:

```
For each of the 10 areas:
  weight = 2.0 if severity == HIGH
  weight = 1.0 if severity == MEDIUM
  weight = 0.5 if severity == LOW

overall_score = sum(score_i × weight_i) / sum(weight_i)
```

**Example**: Scores [8, 8, 4, 4, 9, 2, 2, 5, 2, 4] with severity [LOW, LOW, HIGH, MEDIUM, LOW, HIGH, HIGH, MEDIUM, HIGH, MEDIUM]:
- Numerator: 8(0.5) + 8(0.5) + 4(2) + 4(1) + 9(0.5) + 2(2) + 2(2) + 5(1) + 2(2) + 4(1) = 45.5
- Denominator: 0.5 + 0.5 + 2 + 1 + 0.5 + 2 + 2 + 1 + 2 + 1 = 12.5
- Score: 45.5 / 12.5 = 3.64 → round to 3.6/10

**Always show the formula, inputs, and calculation in `10-scoring-matrix.md`.** This makes the overall score reproducible and verifiable by the fact-check skill.

### Phase 4: Generate Report

Create `{company-name}-search-audit.md` with the following structure:

```markdown
# {Company Name} — Algolia Search Audit
**Date**: {today's date}
**Website**: {url}
**Prepared by**: Algolia

---

## Executive Summary
{2-3 sentence overview of key findings and biggest opportunities}

## Strategic Intelligence

> **Why Now**: {1-sentence timing thesis}

### Timing Signals
| Signal | Evidence | Source | Implication |
|--------|----------|--------|-------------|

### Trigger Events
| Trigger | Opening Line for AE | Source |

### ⚠️ Caution Signals (shown only when detected)

## In Their Own Words (Investor Intelligence)

> {Quote #1}
> — {Speaker Name}, {Title}, {Source + Date}

**What we found**: {matching audit finding}
**Algolia solution**: {product + expected impact}

> {Quote #2}
> — {Speaker Name}, {Title}, {Source + Date}

**What we found**: {matching audit finding}
**Algolia solution**: {product + expected impact}

### Forward Guidance
### Risk Factors Mentioning Digital/Technology

## Company Context
## Technology Stack Deep Dive
## Competitor Landscape
## Financial Profile
## Strategic Leadership
## Buying Committee (Deal Stakeholders)
## Hiring Signal Analysis
## Revenue Impact Estimate
## ICP-to-Priority Mapping

## Search Audit Findings
### Audit Recap (10-row scoring table)
### Detailed Findings (per gap: tested, happened, screenshot, why it matters + SAIM stat, Algolia solution)

## Opportunities
## Algolia Value-Prop Assessment (7-row product table)
## How Algolia Can Help
## Next Steps
```

### Case Study Verification Gate (MANDATORY — Prevents Metric Fabrication)

Before citing ANY Algolia case study in any deliverable, you MUST:

1. **WebFetch the exact URL** (e.g., `algolia.com/customers/{company}/`)
2. **If 404**: Search `algolia.com/customers/` for the correct URL variant (e.g., `/decathlon-singapore/` not `/decathlon/`, `/gymshark-recommend/` not `/gymshark/`)
3. **Extract the EXACT metric** from the live page — the specific number, what it measures (conversion rate vs revenue vs order rate vs CTR), and which Algolia product was used
4. **Extract the EXACT timeframe** — only if explicitly stated on the page. If no timeframe is mentioned, do NOT add one.
5. **Record in scratchpad** before propagating to deliverables:
   ```
   CASE STUDY: {Company}
   URL: {verified live URL}
   METRIC: {exact metric from page, e.g., "+37% conversion rate improvement"}
   PRODUCT: {exact Algolia product name from page, e.g., "Algolia Recommend"}
   TIMEFRAME: {from page, or "NOT STATED"}
   CONTEXT: {any qualifying context, e.g., "new customers during Black Friday"}
   ```

**FORBIDDEN — these patterns caused 5 of 6 case study errors in the Oriental Trading audit (2026-02-24):**
- Adding timeframes not on the page (e.g., "in 6 months", "in 12 months")
- Changing metric types (e.g., "conversion rate" → "revenue", "order rate" → "CTR")
- Changing product names (e.g., "Algolia Recommend" → "Algolia Personalization")
- Using parent URLs when the case study lives at a variant (e.g., `/gymshark-recommend/` not `/gymshark/`)
- Citing a specific percentage when the source says "double-digit" (fabricated precision)

### Link Verification Gate (MANDATORY — Prevents Dead URL Propagation)

Before finalizing any deliverable, extract ALL URLs and WebFetch each one. If 404/403:
1. Search for the correct URL
2. If found, replace with the correct URL
3. If not found, remove the citation and mark claim as unverifiable

**Why this exists**: In the Oriental Trading audit (2026-02-24), 4 dead URLs made it into the book: 2 Algolia case study pages that had moved, 1 Baymard page that was removed entirely, and 1 expired job listing from 2022.

### Pre-Deliverable Data Refresh (MANDATORY — Prevents Post-Compaction Hallucination)

Before generating EACH deliverable file (Phase 4 and 5a through 5f), you MUST re-read the 5 critical scratchpad files to ensure exact data fidelity. This is NOT optional — context compaction corrupts numerical data in memory. The model will regenerate plausible-looking numbers that are internally consistent (e.g., traffic sources summing to 100%) but factually WRONG.

**Refresh procedure (run before EACH deliverable)**:
1. `Read 03-traffic-data.md` — Capture exact traffic source percentages, demographics (all 6 age brackets)
2. `Read 04-competitors.md` — Capture exact competitor names, bounce rates, traffic volumes, search providers
3. `Read 08-financial-profile.md` — Capture exact revenue, EBITDA, margin zone, ROI figures
4. `Read 10-scoring-matrix.md` — Capture exact scores per area, severity distribution, overall score
5. `Read 11-investor-intelligence.md` — Capture exact quotes with speaker names, titles, and source URLs

**Spot-check verification after writing each deliverable**: After writing each file, grep for 3 values to confirm data fidelity:
- Traffic: grep for the exact Paid Search % from scratchpad 03
- Competitors: grep for the exact first-competitor bounce rate from scratchpad 04
- Financials: grep for the exact revenue figure from scratchpad 08
If ANY spot-check fails, re-read the scratchpad file and correct the deliverable before proceeding.

**Data Table Freeze Rule**: For ANY table containing competitor data (names, traffic, bounce rates, search providers), traffic source breakdowns, demographic distributions, or financial figures — COPY the exact table from the corresponding scratchpad file. Do NOT regenerate tables from memory. Tabular data with parallel columns is especially vulnerable to column-scrambling (values assigned to wrong rows) during context compaction.

**Why this exists**: In the TheRealReal audit (2026-02-23), the content spec was generated after context compaction and contained 12 data errors — traffic sources, demographics, and competitor bounce rates were all regenerated from lossy memory. Competitor bounce rates were scrambled (Fashionphile got 28.8% when it was actually 50.6%). The other deliverables, generated earlier while scratchpad data was in active context, had ZERO errors.

### Phase 5: Generate Deliverables (Brand-Validated)

Phase 5 produces THREE deliverables:
1. **`{company}-search-audit-book.pdf`** — The primary deliverable. A beautiful, print-quality PDF book using the HTML template system.
2. **`{company}-ae-precall-brief.md`** — AE-facing internal brief (NOT for prospect).
3. **`{company}-strategic-signal-brief.md`** — 1-page brief for downstream LLM consumption.

The book REPLACES the old report, deck, landing page, and content spec. One beautiful artifact instead of six scattered files.

#### 5a: Assemble the Book (HTML → PDF)

> **⚠️ CONTEXT COMPACTION WARNING**: Book assembly is the most context-intensive phase. The model's context fills with 12 scratchpad files (~35K tokens) and compaction causes chapters to be silently skipped. The sub-phase structure below with mandatory disk writes after each Act prevents this failure mode.

The book uses a template system at `~/.claude/skills/algolia-search-audit/templates/`:
- `book-template.html` — Master template with 21 chapters + 6 appendix sections, all using `{{PLACEHOLDER}}` variables
- `components.css` — Visual component library (25 components: KPI dashboards, revenue funnels, finding spreads, competitor tables, SVG charts, executive cards, timelines, etc.)

**Step 1: Copy template files to working directory**
```bash
cp ~/.claude/skills/algolia-search-audit/templates/book-template.html ./{company}-book.html
cp ~/.claude/skills/algolia-search-audit/templates/components.css ./components.css
```

**Step 2: Read ALL 12 scratchpad files** (Pre-Deliverable Data Refresh — MANDATORY)
Read every scratchpad file (01 through 12) before populating any chapter. This prevents post-compaction hallucination.

**Step 3: Populate the HTML template IN SUB-PHASES** (CRITICAL — prevents chapter skipping)

Book assembly MUST be done in 6 sub-phases with mandatory disk writes and verification after each. DO NOT attempt to populate the entire book at once.

---

**Sub-Phase 5a-1: Cover + Act I (Chapters 1-4)**

Read scratchpad files: `01-company-context.md`, `03-traffic-data.md`, `08-financial-profile.md`, `10-scoring-matrix.md`

Populate:
- [ ] Cover page (company name, logo, photo, headline)
- [ ] Ch 1: Bottom Line (KPI dashboard with score meter)
- [ ] Ch 2: Company Snapshot / At a Glance (REQUIRED — company profile metrics + key strategic signal callout)
  - Left column: Homepage screenshot + key metrics (Founded, Revenue, Monthly Visits, Business Model, B Corp/certifications)
  - Right column: 3-4 brand/value cards (ownership, business model differentiators, social impact)
  - Bottom: Full-width gradient callout box with KEY STRATEGIC SIGNAL (most actionable insight from research)
- [ ] Ch 3: Opportunity (revenue funnel)
- [ ] Ch 4: The Ask (timeline + financial card)

**MANDATORY**: Save to disk immediately after completing Act I:
```bash
# Verify chapters exist
grep -c 'id="ch-bottom-line"\|id="ch-snapshot"\|id="ch-opportunity"\|id="ch-the-ask"' {company}-book.html
# Expected: 4
```

Update manifest: Mark Act I chapters as `[x] done`

---

**Sub-Phase 5a-2: Act II (Chapters 5-13 — Findings)**

Read scratchpad files: `09-browser-findings.md`, `10-scoring-matrix.md`, `11-investor-intelligence.md`

Populate:
- [ ] Ch 5: Scorecard (dual panel — what's working vs critical gaps)
- [ ] Ch 6-12: Finding pages (one per major gap, 5-8 total) — EACH with:
  - Hero screenshot (5 inches tall)
  - Stat bar with industry benchmark
  - Tested/Expected/Found columns
  - Solution box with Algolia product
- [ ] Ch 13: In Their Words (strategy vs execution pairs)

**MANDATORY**: Save to disk immediately after completing Act II:
```bash
# Verify finding pages exist (should be 5-8 findings + scorecard + "in their words")
grep -c 'class="chapter.*finding\|id="ch-scorecard"\|id="ch-their-words"' {company}-book.html
# Expected: 7-10
```

Update manifest: Mark Act II chapters as `[x] done`

---

**Sub-Phase 5a-3: Act III (Chapters 14-18 — Why Now)**

Read scratchpad files: `02-tech-stack.md`, `04-competitors.md`, `06-strategic-context.md`, `07-hiring-signals.md`, `11-investor-intelligence.md`

Populate:
- [ ] Ch 14: Tech Stack (stack diagram with removed/added)
- [ ] Ch 15: AI Gap (balance scale — deployed vs absent)
- [ ] Ch 16: Competitors (table + donut chart)
- [ ] Ch 17: Hiring (bar chart + callout)
- [ ] Ch 18: Leadership/Strategic Triggers (quotes or trigger cards)

**MANDATORY**: Save to disk immediately after completing Act III:
```bash
# Verify chapters exist
grep -c 'id="ch-tech-stack"\|id="ch-ai-gap"\|id="ch-competitors"\|id="ch-hiring"\|id="ch-leadership"\|id="ch-triggers"' {company}-book.html
# Expected: 4-5
```

Update manifest: Mark Act III chapters as `[x] done`

---

**Sub-Phase 5a-4: Act IV (Chapters 19-22 — The Path)**

Read scratchpad files: `01-company-context.md`, `08-financial-profile.md`, `12-icp-priority-mapping.md`

Populate:
- [ ] Ch 19: Architecture (flow diagram with Algolia)
- [ ] Ch 20: Buying Committee (exec cards)
- [ ] Ch 21: Pilot Roadmap (timeline + financial projection)
- [ ] Ch 22: Next Steps (closing CTA)

**MANDATORY**: Save to disk immediately after completing Act IV:
```bash
# Verify chapters exist
grep -c 'id="ch-architecture"\|id="ch-buying-committee"\|id="ch-pilot"\|id="ch-next-steps"' {company}-book.html
# Expected: 4
```

Update manifest: Mark Act IV chapters as `[x] done`

---

**Sub-Phase 5a-5: Appendices (A-F)**

Read scratchpad files: ALL 12 files

Populate:
- [ ] Appendix A: Full 10-area scoring matrix
- [ ] Appendix B: Complete tech stack from BuiltWith
- [ ] Appendix C: Traffic & demographics from SimilarWeb
- [ ] Appendix D: Financial profile with 3-year trends
- [ ] Appendix E: All test queries with results
- [ ] Appendix F: Full bibliography (grouped by source type)

**MANDATORY**: Save to disk immediately after completing Appendices:
```bash
# Verify appendices exist
grep -c 'id="appendix-scoring"\|id="appendix-techstack"\|id="appendix-traffic"\|id="appendix-financials"\|id="appendix-queries"\|id="appendix-sources"\|id="appendix-bibliography"' {company}-book.html
# Expected: 6
```

Update manifest: Mark all Appendix chapters as `[x] done`

---

**Sub-Phase 5a-6: Final Verification (BLOCKING GATE)**

Before PDF generation, run these verification checks. ALL must pass:

```bash
# 1. Chapter count verification
chapter_count=$(grep -c 'class="chapter"' {company}-book.html)
echo "Chapter count: $chapter_count"
if [ "$chapter_count" -lt 25 ]; then
  echo "⛔ CHAPTER GATE FAILED: Only $chapter_count chapters. Required: 25+"
  echo "Review manifest to identify missing chapters and re-run sub-phases."
  exit 1
fi

# 2. Unpopulated placeholder check
placeholder_count=$(grep -c '{{' {company}-book.html || echo 0)
echo "Unpopulated placeholders: $placeholder_count"
if [ "$placeholder_count" -gt 0 ]; then
  echo "⛔ PLACEHOLDER GATE FAILED: $placeholder_count unpopulated variables remain"
  grep '{{' {company}-book.html | head -10
  exit 1
fi

# 3. Page number sequence verification
echo "Page numbers in sequence:"
grep -o 'page-footer__page">[0-9]*' {company}-book.html | sed 's/page-footer__page">//' | tr '\n' ' '
echo ""

# 4. Screenshot references
screenshot_refs=$(grep -c 'src="screenshots/' {company}-book.html || echo 0)
echo "Screenshot references: $screenshot_refs"
if [ "$screenshot_refs" -lt 5 ]; then
  echo "⚠️ WARNING: Only $screenshot_refs screenshot references. Expected: 5+"
fi
```

**If any check fails**: Do NOT proceed to PDF generation. Fix the issue first.

---

Open `{company}-book.html` and replace every `{{PLACEHOLDER}}` with real data from scratchpad files.

**Chapter-to-Scratchpad Mapping**:

| Chapter | Template Section | Scratchpad Source | Key Placeholders |
|---------|-----------------|-------------------|-----------------|
| Cover | `.cover-page` | `01-company-context.md` | `{{COMPANY_NAME}}`, `{{COMPANY_LOGO_URL}}`, `{{COVER_PHOTO_URL}}`, `{{STATUS_HEADLINE}}`, `{{METRIC_1}}`, `{{METRIC_2}}` |
| All Pages | `.page-header`, `.page-footer` | n/a | `{{COMPANY_LOGO_URL}}`, `{{COMPANY_NAME}}`, `{{PAGE_NUM}}` |
| **ACT I: THE VERDICT** | | | |
| Ch 1: Bottom Line | `#ch-bottom-line` (KPI dashboard) | All files | `{{OVERALL_SCORE}}`, `{{CRITICAL_GAP_LABEL}}`, `{{REVENUE_RISK}}`, `{{THE_ASK_LABEL}}` + descriptions |
| Ch 2: Company Snapshot | `#ch-snapshot` (at-a-glance) | `01-company-context.md`, `08-financial-profile.md` | `{{REVENUE}}`, `{{EMPLOYEES}}`, `{{FOUNDED}}`, `{{INDUSTRY}}`, `{{KEY_SIGNAL}}` (e.g. Listrak partnership) |
| Ch 3: Opportunity | `#ch-opportunity` (revenue funnel) | `08-financial-profile.md` | `{{TOTAL_DIGITAL_REVENUE}}`, `{{SEARCH_ADDRESSABLE}}`, `{{CONSERVATIVE_LIFT_PCT}}`, `{{BENCHMARK_PROOF}}` |
| Ch 4: The Ask | `#ch-the-ask` (timeline + Pilot Success Metrics) | `08-financial-profile.md` | `{{PILOT_TIMELINE_STEPS}}`, `{{PILOT_SUCCESS_METRICS}}` (see below) |
| **ACT II: THE PROOF** | | | |
| Ch 4: Scorecard | `#ch-scorecard` (dual panel) | `10-scoring-matrix.md` | `{{PANEL_POSITIVE_ITEMS}}`, `{{PANEL_CRITICAL_ITEMS}}` |
| Ch 5–11: Findings | `{{FINDINGS_SECTIONS}}` (variable count) | `09-browser-findings.md` | Generate one `.finding` block per gap — see template comment for HTML structure |
| Ch 12: In Their Words | `#ch-their-words` (strategy vs execution) | `11-investor-intelligence.md` + `09-browser-findings.md` | `{{STRATEGY_EXECUTION_PAIRS}}` — pair exec quotes with screenshot evidence |
| **ACT III: WHY NOW** | | | |
| Ch 13: Tech Stack | `#ch-tech-stack` (stack diagram) | `02-tech-stack.md` | `{{STACK_REMOVED_BLOCKS}}`, `{{VACUUM_LABEL}}`, `{{STACK_ADDED_BLOCKS}}` |
| Ch 14: AI Gap | `#ch-ai-gap` (balance scale) | `02-tech-stack.md` + `10-scoring-matrix.md` | `{{AI_DEPLOYED_ITEMS}}`, `{{AI_ABSENT_ITEMS}}` |
| Ch 15: Competitors | `#ch-competitors` (table + donut chart) | `04-competitors.md` | `{{COMPETITOR_TABLE_ROWS}}`, `{{DONUT_PCT}}`, SVG `stroke-dasharray` values |
| Ch 16: Hiring | `#ch-hiring` (bar chart + callout) | `07-hiring-signals.md` | `{{HIRING_BAR_ROWS}}`, `{{HIRING_CALLOUT}}` |
| Ch 17: Leadership | `#ch-leadership` | `11-investor-intelligence.md` | `{{LEADERSHIP_QUOTES}}` — callout--quote boxes with source citations |
| **ACT IV: THE PATH** | | | |
| Ch 18: Architecture | `#ch-architecture` (flow diagram) | `02-tech-stack.md` + `10-scoring-matrix.md` | `{{FLOW_BOXES}}`, `{{ARCHITECTURE_BENEFITS}}` |
| Ch 19: Buying Committee | `#ch-buying-committee` (exec cards) | `01-company-context.md` | `{{EXEC_CARDS}}` — photo + title + focus area per executive |
| Ch 20: Pilot Roadmap | `#ch-pilot` (timeline + financial) | `08-financial-profile.md` | `{{PILOT_TIMELINE_STEPS}}`, `{{PILOT_FINANCIAL_ROWS}}` |
| Ch 21: Next Steps | `#ch-next-steps` (closing CTA) | All files | `{{NEXT_STEPS_ITEMS}}`, `{{CLOSING_QUOTE}}` |
| **APPENDIX** | | | |
| App A: Scoring | `#appendix-scoring` | `10-scoring-matrix.md` | Full 10-area scoring table |
| App B: Tech Stack | `#appendix-techstack` | `02-tech-stack.md` | Complete BuiltWith analysis |
| App C: Traffic | `#appendix-traffic` | `03-traffic-data.md` | Full traffic, demographics, keywords |
| App D: Financials | `#appendix-financials` | `08-financial-profile.md` | 3-year financial tables |
| App E: Test Queries | `#appendix-queries` | `05-test-queries.md` | All queries with results |
| App F: Sources | `#appendix-sources` | All files | Bibliography grouped by category |

**Scratchpad Mining Rule**: Every scratchpad file (01-12) MUST contribute to at least one chapter. Rich data tables, demographics, keyword analysis warrant extra detail. Never compress intelligence into thin summaries.

**Variable-Length Sections**: The `{{FINDINGS_SECTIONS}}` placeholder is replaced with 5-8 finding blocks (one per major gap). Use the HTML template in the comment block within `book-template.html` as the pattern for each finding. Similarly, `{{STRATEGY_EXECUTION_PAIRS}}` gets 2-3 strategy-vs-execution pairs.

**Inline Citation Mandate**: Every data point MUST have an inline citation as it appears. Use `<a href="URL" class="cite">[N]</a>` for numbered references and `<span class="source-tag source-tag--TYPE">Source</span>` for visual source badges. Source tag types: `financial`, `traffic`, `technology`, `industry`, `hiring`, `investor`, `competitor`, `casestudy`. The bibliography at the end collects ALL inline references.

**SVG Chart Population**:
- **Donut chart** (competitors): Calculate `stroke-dasharray` as `(percentage / 100) * 440` for the filled arc, remainder = `440 - filled`.
- **Bar chart** (hiring): Each bar uses `<div class="bar-row">` with inline `width` percentage.
- **Revenue funnel**: Tier labels with actual dollar values from `08-financial-profile.md`.

**Screenshot Embedding**: Every finding spread MUST reference `screenshots/{nn}-{slug}.png` via `<img src="screenshots/...">`. The CSS includes `onerror` fallback styling. If a screenshot file is missing, the finding is INCOMPLETE.

**Color Usage**: Color is used creatively within visual metaphors (e.g., stack diagram columns, balance scale weight, funnel gradient, donut arcs) — NOT as simple red/green/yellow traffic lights. The components.css uses Algolia brand palette: Nebula Blue `#003DFF`, Space Gray `#21243D`, Algolia Purple `#5468FF`, with contextual warm (`#E8513D`) and cool (`#36B37E`) accents within components only.

**Step 4: Brand compliance**
Run `/algolia-brand-check` on the populated HTML. Auto-fix below 8/10.

**Step 5: Convert to PDF**
```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless --disable-gpu --no-sandbox \
  --print-to-pdf="{company}-search-audit-book.pdf" \
  --print-to-pdf-no-header \
  "file://$(pwd)/{company}-book.html"
```

**Step 6: Verify PDF**
```bash
ls -la {company}-search-audit-book.pdf
```
Expected: 500KB-2MB file. If 0 bytes or missing, debug the HTML file in Chrome manually.

**Emotional Continuity**: Cover = intrigue. Act I = "wait, what?" (the verdict). Act II = mounting evidence (screenshot after screenshot). Ch 12 "In Their Own Words" = emotional climax (their CEO's words vs their broken search). Act III = urgency signals converge. Act IV = relief through resolution.

#### 5b: AE Pre-Call Brief
Generate `{company}-ae-precall-brief.md` — AE-facing (NOT for prospect). Every data point hyperlinked.

**Structure**:
1. **Executive Cheat Sheet** (5 bullets): Revenue + margin zone, business model, digital focus, top gap, opportunity + ROI
2. **Financial Profile** with hyperlinked figures
3. **Key Executives** with source links
4. **Recent News & Trigger Events** with source links
5. **Audit Highlights** — top 3 findings with evidence
6. **Discovery Questions** — 6-8 questions from audit findings + margin zone
7. **Stakeholder Targets** — buyer persona mapping
8. **Pilot Strategy** — margin-zone-aware scope, KPIs, budget
9. **Competitive Context** — golden angle if applicable
10. **Speaking Their Language** — discovery questions using company's OWN language from SEC filings/earnings calls, anchored to ICP-to-Priority mapping from Step 14

#### 5c: Strategic Signal Brief
Generate `{company}-strategic-signal-brief.md` — 1-page brief for downstream LLM consumption. Every line is standalone with full context. Sections: 60-Second Story, Timing Signals, In Their Own Words (with Speaker + Title), People, Money, Gaps, Hiring Intelligence, Competitive Landscape, ICP Mapping, The Angle, Sources.

## Output

The audit produces THREE deliverables, all brand-validated:
1. **`{company}-search-audit-book.pdf`** — The primary deliverable. A beautiful, print-quality PDF book (~40-50 pages) combining the full audit report, visual findings with screenshots, strategic intelligence, competitor analysis, and recommendations into a single McKinsey Pyramid + Hollywood narrative. Generated from HTML template → Chrome headless PDF.
2. **`{company}-ae-precall-brief.md`** — AE pre-call brief (internal only, NOT for prospect)
3. **`{company}-strategic-signal-brief.md`** — Strategic signal brief for downstream LLMs

**Intermediate artifact** (kept in working directory): `{company}-book.html` + `components.css` — the source HTML used to generate the PDF. Useful for debugging or manual adjustments.

## Key Reference Data (SAIM - Search Audit Impact Map)

| Issue | Statistic | Algolia Case Study |
|-------|-----------|-------------------|
| No typo tolerance | 1 in 6 queries have typos | Lacoste: 37% increase in search revenue |
| Slow search | 39% leave if too slow; 100ms delay = 1% revenue loss | Under Armour: <20ms latency |
| No federated search | 68% would return to site with good search | Staples: improved content discoverability |
| No personalization | 80% prefer personalized experiences; 10-15% revenue lift | Gymshark: increased conversion |
| Poor relevance | 72% of sites have mediocre/broken relevance | Decathlon: 50% search conversion boost |
| No/bad filters | 43% lack sufficient filtering; filter users convert 2x | Birkenstock: dynamic faceting |
| Missing sort options | 46% missing at least one key sort option | Algolia Sort By Replicas |
| Browse/search inconsistency | Erodes user trust | Algolia unified index |
| No results pages | 12% of searches → no results; 75% leave | Herschel: 80% no-results reduction |
| Out of stock at top | Wastes real estate, frustrates users | Algolia custom ranking |
| Irrelevant recommendations | Recommendations drive 31% of e-commerce revenue | Algolia Recommend ML models |
| Not factoring reviews | 93% say reviews influence purchase | Algolia custom ranking with ratings |

## Execution Checklist Gates (MANDATORY)

### Gate 1: After Phase 1 — Verify before opening browser

**Data Collection (Steps 1-6)**:
- [ ] BuiltWith `domain-lookup` called for prospect → tech categories logged
- [ ] BuiltWith `relationships-api` called → sister sites logged
- [ ] BuiltWith `recommendations-api` called → tech gaps logged
- [ ] BuiltWith `financial-api` called → revenue estimates logged
- [ ] BuiltWith `trust-api` called → trust score logged
- [ ] SimilarWeb traffic called (11 endpoints): traffic-and-engagement, traffic-sources, geography, demographics, keywords, audience-interests, website-rank, referrals, popular-pages, leading-folders, landing-pages
- [ ] SimilarWeb competitors called (2 endpoints): similar-sites, keywords-competitors → top 3-5 identified
- [ ] BuiltWith `domain-lookup` called for EACH competitor → search providers detected
- [ ] SimilarWeb `traffic-and-engagement` called for each competitor

**Enrichment (Steps 7-14)**:
- [ ] Ticker resolved via WebSearch (or noted as private company)
- [ ] Financial data via Yahoo Finance MCP (8+ tools) → 3-year trends, margin zone classified
- [ ] Key executives identified (Tier 1 + Tier 2 + Tier 3 where findable) with backgrounds
- [ ] Vertical classified, test queries generated (14-18 vertically calibrated)
- [ ] Hiring signals checked, strategic angles documented, trigger events synthesized
- [ ] ROI estimate calculated with formula + sources
- [ ] Vertical case studies selected
- [ ] Competitor matrix populated with search providers
- [ ] Investor intelligence collected: SEC EDGAR for 10-K + 10-Q (MD&A, Risk Factors), last 3 quarters of earnings calls, investor presentations → 5-8 executive quotes with speaker names + titles
- [ ] Deep hiring via Chrome MCP: careers page visited, role counts, JD evidence with URLs
- [ ] Buying committee mapped: stakeholder table with names, titles, roles, priorities
- [ ] ICP-to-Priority mapping created (preliminary)
- [ ] Source URLs captured in ALL scratchpad files (01-12)

### Gate 2: After Phase 2 — Verify before scoring

- [ ] All 12 core steps executed (2a-2l)
- [ ] All 8 Algolia value-prop steps executed (2m-2t)
- [ ] **HARD GATE — BLOCKING**: Run `ls screenshots/ | wc -l`.
  - If result < 10: **STOP THE AUDIT. Do NOT proceed to Phase 3.**
  - Print: "⛔ SCREENSHOT GATE FAILED: Only {N} screenshots on disk. Required: 10+."
  - Re-attempt screenshot capture for any missing files.
  - Re-run the count. If STILL < 10, ask the user for guidance before proceeding.
  - This gate exists because Chrome MCP imageIds are SESSION-BOUND and become USELESS after session ends. If screenshots are not on disk NOW, they will NEVER be on disk.
- [ ] **Zero-byte check**: `find screenshots/ -empty | wc -l` must return 0. Delete and re-capture any empty files.
- [ ] **Disk path verification**: Each entry in `09-browser-findings.md` must include `Screenshot: screenshots/{nn}-{slug}.png (VERIFIED ON DISK)`. Entries with Chrome MCP imageIds like `ss_XXXXXXX` instead of file paths indicate persistence failure — fix immediately.
- [ ] **WAF/Error Page Detection** (CRITICAL): Run this check to detect if screenshots are error pages vs real content:
  ```bash
  echo "=== Screenshot Quality Check ==="
  for f in screenshots/*.png; do
    size=$(stat -f%z "$f" 2>/dev/null || stat -c%s "$f" 2>/dev/null)
    if [ "$size" -lt 50000 ]; then
      echo "⚠️  WARNING: $f is only ${size} bytes — likely error page or blank"
    elif [ "$size" -lt 100000 ]; then
      echo "🟡 REVIEW: $f is ${size} bytes — may be sparse content"
    else
      echo "✅ OK: $f is ${size} bytes"
    fi
  done
  ```
  **Pass criteria**:
  - At least 10 screenshots > 100KB each (real content with product images)
  - No screenshots < 50KB (these are WAF "Access Denied" or error pages)
  - If multiple screenshots are flagged as potential error pages:
    1. Open one in a viewer to visually confirm
    2. If confirmed as error page, re-run browser tests with WAF Recovery Protocol
    3. If site is persistently blocked, document limitation and proceed with available data

### Gate 3: After Phase 3 — Verify before writing report

- [ ] All 10 areas scored with evidence and screenshot references
- [ ] Overall score calculated with severity counts

### Gate 4: After Phase 4 — Verify before generating deliverables

Report MUST contain ALL sections: Executive Summary, Strategic Intelligence, In Their Own Words (with speaker names + titles), Company Context, Technology Stack, Competitor Landscape, Financial Profile, Strategic Leadership, Buying Committee, Hiring Analysis, Revenue Impact, ICP Mapping, Audit Recap, Detailed Findings, Opportunities, Value-Prop Assessment, How Algolia Helps, Next Steps. Source URLs throughout.

### Gate 4.5: MANDATORY Fact Verification (BLOCKING — prevents hallucinated data)

> **⛔ THIS GATE IS NON-NEGOTIABLE. DO NOT PROCEED TO PHASE 5 WITHOUT COMPLETING ALL CHECKS.**
>
> **Root cause**: Uncommon Goods audit (2026-02-24) delivered $179M revenue when actual was $227M (27% error), and used 2017 employee data for a 2026 report. This gate prevents such failures.

**4.5.1 Revenue Data Verification**:
```bash
# Re-fetch revenue from primary source and compare to scratchpad
# If discrepancy > 5%, STOP and fix scratchpad before proceeding
```
- [ ] Revenue figure verified against primary source (ecdb.com, SEC filing, or company IR)
- [ ] Revenue year matches current/prior fiscal year (not older)
- [ ] If private company: source explicitly named, confidence marked as MEDIUM or LOW
- [ ] Revenue cross-referenced against 2nd source if available (SimilarWeb, PitchBook, Crunchbase)

**4.5.2 Source Freshness Validation**:
```
For each data point in scratchpad files, verify:
- Financial data: Source must be < 12 months old
- Employee count: Source must be < 12 months old
- Traffic data: Source must be < 3 months old (SimilarWeb refreshes monthly)
- Tech stack: Source must be < 6 months old
```
- [ ] All financial sources dated within 12 months
- [ ] All employee/headcount sources dated within 12 months
- [ ] No sources older than 2 years used for ANY current-state claim
- [ ] **If source is blog post, press release, or article**: Check publication date. Reject if > 12 months for financial/employee data.

**4.5.3 Cross-Reference Validation**:
```
Key metrics MUST be verified against 2+ independent sources:
- Revenue: ecdb.com + (SimilarWeb revenue estimate OR PitchBook OR Crunchbase)
- Employee count: LinkedIn + (PitchBook OR Crunchbase OR ZoomInfo)
- Traffic: SimilarWeb + Semrush (if available)
```
- [ ] Revenue cross-referenced (if only 1 source: mark as LOW confidence in deliverables)
- [ ] Employee count cross-referenced OR removed from deliverables
- [ ] Any metric with > 20% discrepancy between sources: flag in deliverable with confidence warning

**4.5.4 Primary Source Re-Fetch**:
Before generating book, RE-FETCH these sources to verify data hasn't changed:
```bash
# Use WebFetch to re-check primary sources
# Compare fetched values to scratchpad values
# If mismatch: UPDATE scratchpad, then proceed
```
- [ ] ecdb.com (or equivalent) re-fetched for revenue
- [ ] B Corp page re-fetched for certification claims
- [ ] LinkedIn/PitchBook re-fetched for employee count (if used)
- [ ] All fetched values match scratchpad (or scratchpad updated)

**4.5.5 Unverifiable Data Handling**:
If a data point CANNOT be verified against a primary source:
1. **Remove it** from deliverables entirely, OR
2. **Mark it explicitly** as `[UNVERIFIED - USE WITH CAUTION]` in the deliverable
3. **Never present unverified data as fact**

- [ ] All unverifiable claims either removed or marked
- [ ] No stale sources (> 12 months) used for current-state financial claims
- [ ] Employee count either verified OR removed (never guessed)

**Blocking Condition**: If ANY of 4.5.1-4.5.5 fails, DO NOT proceed to Phase 5. Fix the data first.

### Gate 5: After Phase 5 — Verify before completion

> **⛔ BLOCKING GATE**: ALL checks below must pass before the audit is considered complete. Do NOT skip any verification.

**5.1 Chapter Count Verification (CRITICAL — prevents incomplete book)**:
```bash
chapter_count=$(grep -c 'class="chapter"' {company}-book.html)
echo "Chapter count: $chapter_count"
if [ "$chapter_count" -lt 25 ]; then
  echo "⛔ CHAPTER GATE FAILED: Only $chapter_count chapters. Required: 25+"
  echo "Go back to Phase 5a and complete missing sub-phases."
  exit 1
fi
```
- [ ] Chapter count ≥ 25 (21 main chapters + 6 appendices, some may share pages)

**5.2 PDF Page Count Verification (CRITICAL — catches incomplete generation)**:
```bash
page_count=$(mdls -name kMDItemNumberOfPages {company}-search-audit-book.pdf 2>/dev/null | awk '{print $3}')
echo "PDF page count: $page_count"
if [ "$page_count" -lt 28 ]; then
  echo "⛔ PAGE COUNT GATE FAILED: Only $page_count pages. Required: 28+"
  echo "Expected: 28-35 pages for a complete audit."
  echo "Review HTML for missing chapters before regenerating PDF."
  exit 1
fi
```
- [ ] PDF page count ≥ 28 pages (typical range: 28-35 for complete audit)

**5.3 Manifest Chapter Checklist Verification**:
```bash
incomplete=$(grep -c '\[ \]' _workspace-manifest.md | grep -i "ch \|appendix" || echo 0)
echo "Incomplete chapters in manifest: $incomplete"
if [ "$incomplete" -gt 0 ]; then
  echo "⛔ MANIFEST GATE FAILED: $incomplete chapters still marked incomplete"
  grep '\[ \]' _workspace-manifest.md | grep -i "ch \|appendix"
  exit 1
fi
```
- [ ] All chapters marked `[x] done` in manifest

**5.4 File existence**: All 3 deliverables exist + intermediate HTML.
- [ ] `{company}-search-audit-book.pdf` exists
- [ ] `{company}-ae-precall-brief.md` exists
- [ ] `{company}-strategic-signal-brief.md` exists
- [ ] `{company}-book.html` exists (intermediate artifact)

**5.5 PDF file size validation**:
- [ ] `ls -la {company}-search-audit-book.pdf` → file size 500KB-5MB
- [ ] If < 500KB, likely missing images/content
- [ ] If 0 bytes or missing, debug HTML in Chrome manually before proceeding

**5.6 Screenshot validation**:
- [ ] `ls screenshots/ | wc -l` → minimum 10
- [ ] Book HTML has `<img src="screenshots/"` tags for every finding
- [ ] `grep -c 'src="screenshots/' {company}-book.html` → minimum 5 screenshot references

**5.7 Source citation validation**:
- [ ] `grep -c 'class="cite"' {company}-book.html` → minimum 15 inline citations
- [ ] `grep -c 'source-tag' {company}-book.html` → minimum 8 source badges
- [ ] `grep -c '](http' {company}-ae-precall-brief.md` → minimum 15 hyperlinks
- [ ] Bibliography section in appendix has entries for ALL source categories

**Final validation script (run ALL checks)**:
```bash
echo "========== GATE 5 VALIDATION =========="

# 5.1 Chapter count
chapter_count=$(grep -c 'class="chapter"' {company}-book.html)
echo "1. Chapters: $chapter_count (required: 25+)"
[ "$chapter_count" -ge 25 ] && echo "   ✅ PASS" || echo "   ⛔ FAIL"

# 5.2 PDF page count
page_count=$(mdls -name kMDItemNumberOfPages {company}-search-audit-book.pdf 2>/dev/null | awk '{print $3}')
echo "2. PDF pages: $page_count (required: 28+)"
[ "$page_count" -ge 28 ] && echo "   ✅ PASS" || echo "   ⛔ FAIL"

# 5.3 PDF file size
pdf_size=$(stat -f%z {company}-search-audit-book.pdf 2>/dev/null || stat -c%s {company}-search-audit-book.pdf 2>/dev/null)
pdf_size_mb=$(echo "scale=2; $pdf_size / 1048576" | bc)
echo "3. PDF size: ${pdf_size_mb}MB (required: 0.5-5MB)"
[ "$pdf_size" -ge 500000 ] && echo "   ✅ PASS" || echo "   ⛔ FAIL"

# 5.4 Screenshots
screenshot_count=$(ls screenshots/ 2>/dev/null | wc -l | tr -d ' ')
echo "4. Screenshots: $screenshot_count (required: 10+)"
[ "$screenshot_count" -ge 10 ] && echo "   ✅ PASS" || echo "   ⛔ FAIL"

# 5.5 Screenshot references in HTML
screenshot_refs=$(grep -c 'src="screenshots/' {company}-book.html 2>/dev/null || echo 0)
echo "5. Screenshot refs: $screenshot_refs (required: 5+)"
[ "$screenshot_refs" -ge 5 ] && echo "   ✅ PASS" || echo "   ⛔ FAIL"

# 5.6 Inline citations
cite_count=$(grep -c 'class="cite"' {company}-book.html 2>/dev/null || echo 0)
echo "6. Inline cites: $cite_count (required: 15+)"
[ "$cite_count" -ge 15 ] && echo "   ✅ PASS" || echo "   ⚠️ WARNING"

# 5.7 AE brief links
ae_links=$(grep -c '](http' {company}-ae-precall-brief.md 2>/dev/null || echo 0)
echo "7. AE brief links: $ae_links (required: 15+)"
[ "$ae_links" -ge 15 ] && echo "   ✅ PASS" || echo "   ⚠️ WARNING"

# 5.8 Zero-byte files check
zero_byte=$(find screenshots/ -empty 2>/dev/null | wc -l | tr -d ' ')
echo "8. Zero-byte files: $zero_byte (required: 0)"
[ "$zero_byte" -eq 0 ] && echo "   ✅ PASS" || echo "   ⛔ FAIL"

echo "========================================"
```

**If checks 1, 2, or 3 FAIL**: Do NOT mark audit as complete. Fix the issues first.

## Notes

- Be objective — note both strengths and weaknesses
- Focus on issues Algolia can solve
- Use the prospect's actual product names and categories in examples
- If the site already uses Algolia, focus on optimization opportunities
- Always generate all three deliverables (PDF book + AE brief + signal brief) — they are a complete package
- The 12 scratchpad files are chapters of research intelligence. Each file MUST contribute to at least one book chapter. Never compress multi-dimensional data into thin one-line summaries.
- Cover page MUST have company store/HQ photo + Algolia branding + status headline
- Every standalone insight in the signal brief must survive context dropping by downstream LLMs
- Never compress Phase 1 data into single lines — tech stack, traffic, and competitor landscape deserve full sections with tables
- **Book visual quality**: The PDF book must match NotebookLM-quality visuals. Use the 25 CSS components (KPI dashboards, revenue funnels, finding spreads, SVG charts, executive cards, balance scales, flow diagrams, etc.) creatively. Color usage within visual metaphors — NOT simple red/green/yellow traffic lights.
- **Inline citations everywhere**: Every data point gets an inline `<a class="cite">[N]</a>` as it appears. Source badges (`<span class="source-tag">`) on every data section. Full bibliography collected at the end in Appendix F.
- **Template file integrity**: The `book-template.html` and `components.css` files in `~/.claude/skills/algolia-search-audit/templates/` are the canonical source. Always copy fresh copies to the working directory — never modify the templates in the skill directory.
- **Post-compaction data integrity**: After any context compaction mid-audit, treat ALL numerical data in memory as UNVERIFIED. Always re-read scratchpad files before using any data point. The most dangerous hallucination pattern is plausible regeneration — where the model creates internally consistent but factually wrong numbers (e.g., traffic sources that sum to 100% but with wrong individual values).
- **Competitor table scrambling**: LLMs are especially bad at preserving column-row associations in competitor tables after context compaction. The model remembers "4 competitors had bounce rates in the 28-51% range" but assigns values to the wrong company names. ALWAYS copy competitor tables from scratchpad 04, never regenerate.
- **Browser observations are exact**: When the browser shows "10,000+ New Items", record exactly "10,000+" — do not round up, generalize, or inflate to "30,000+". [OBSERVED] values are verbatim.

## Visual Standards (v2.8 — Enhanced Visuals)

The PDF book must match NotebookLM-quality visuals. The `components.css` library includes 35 component types. This section documents the 7 visual standards that must be applied to every audit.

### 1. Score Meter (Speedometer Style)

The overall score (e.g., 4.0/10) MUST be displayed as a **speedometer-style meter** with red/yellow/green zones and a rotating needle.

**Component**: `.score-meter`

**Implementation** (CRITICAL — use this exact SVG):
```html
<div class="score-meter" style="text-align: center;">
  <svg viewBox="0 0 200 140" style="width: 280px; height: auto;">
    <!-- Background arc zones -->
    <path d="M 20 100 A 80 80 0 0 1 100 20" fill="none" stroke="#DC2626" stroke-width="16" stroke-linecap="round"/>
    <path d="M 100 20 A 80 80 0 0 1 140 34" fill="none" stroke="#F59E0B" stroke-width="16"/>
    <path d="M 140 34 A 80 80 0 0 1 180 100" fill="none" stroke="#10B981" stroke-width="16" stroke-linecap="round"/>

    <!-- Needle — ROTATION FORMULA: -90 + (180 × score/10) -->
    <g transform="rotate({{NEEDLE_ROTATION}} 100 100)">
      <line x1="100" y1="100" x2="100" y2="30" stroke="#21243D" stroke-width="4" stroke-linecap="round"/>
      <circle cx="100" cy="100" r="8" fill="#21243D"/>
    </g>

    <!-- Score value -->
    <text x="100" y="88" text-anchor="middle" font-size="32" font-weight="900" fill="#DC2626">{{SCORE}}</text>
    <text x="100" y="108" text-anchor="middle" font-size="12" font-weight="600" fill="#6B7280">out of 10</text>

    <!-- Zone labels -->
    <text x="35" y="125" font-size="10" fill="#DC2626" font-weight="600">Critical</text>
    <text x="90" y="135" font-size="10" fill="#F59E0B" font-weight="600">Needs Work</text>
    <text x="155" y="125" font-size="10" fill="#10B981" font-weight="600">Good</text>
  </svg>
</div>
```

**Needle Rotation Calculation** (CRITICAL):
```
rotation = -90 + (180 × score / 10)

Examples:
- Score 0.0 → rotate(-90)  = points LEFT (red zone)
- Score 4.0 → rotate(-18)  = points to red/yellow border
- Score 5.0 → rotate(0)    = points UP (center)
- Score 7.0 → rotate(36)   = points to yellow/green border
- Score 10.0 → rotate(90)  = points RIGHT (green zone)
```

**Color by score**:
- Score ≤4: `fill="#DC2626"` (red text)
- Score 5-6: `fill="#F59E0B"` (amber text)
- Score ≥7: `fill="#10B981"` (green text)

### 2. Severity Heatmap Table

Appendix A scoring table MUST use color-coded cells where HIGH = red, MED = amber, LOW = green. Readable at a glance without reading a word.

**Component**: `.severity-heatmap`

**Cell classes**:
- `.severity--high`: Red gradient background
- `.severity--medium`: Amber gradient background
- `.severity--low`: Green gradient background
- `.score-cell--N` (N=1-10): Score-specific color intensity

**Severity distribution cards**: Visual blocks showing HIGH/MED/LOW counts with colored backgrounds.

### 3. Tapered Revenue Funnel

The revenue waterfall MUST be a proper **tapered SVG funnel**, not CSS rectangles. The funnel visually narrows from $7B → $2.45B → $367M → $18.4M.

**Component**: `.funnel-svg` or `.funnel-css`

**SVG approach** (preferred — use 3 tiers to prevent text clipping):
```html
<!-- CRITICAL: Bottom tier MUST be ≥100px wide to fit "$X.XM/year" text -->
<svg viewBox="0 0 500 320">
  <polygon points="40,10 460,10 400,90 100,90" fill="#c7d2fe"/>           <!-- Tier 1: ~300px wide -->
  <polygon points="100,100 400,100 340,180 160,180" fill="#a5b4fc"/>     <!-- Tier 2: ~180px wide -->
  <polygon points="160,190 340,190 305,280 195,280" fill="#818cf8"/>     <!-- Tier 3: 110px bottom -->
  <!-- Bottom tier points: 305-195 = 110px wide — DO NOT MAKE NARROWER -->
</svg>
```
**Anti-pattern** (causes text clipping — DO NOT USE):
```html
<!-- BAD: 4 tiers with 40px bottom — text will clip -->
<polygon points="150,240 250,240 220,300 180,300"/>  <!-- 40px too narrow! -->
```

**CSS trapezoid approach** (fallback): Uses `clip-path: polygon()` for tapered tiers.

### 3a. Cover Page Logo Positioning (CRITICAL)

The cover page MUST have both logos positioned correctly:
- **Algolia logo**: Bottom-left corner (absolute positioning)
- **Company logo**: Top-right corner (absolute positioning)

```css
.cover-page__logo--algolia {
  position: absolute;
  bottom: 40px;
  left: 40px;
  height: 32px;
  z-index: 10;
}

.cover-page__logo--company {
  position: absolute;
  top: 40px;
  right: 40px;
  height: 40px;
  max-width: 180px;
  z-index: 10;
}
```

**Anti-pattern**: Do NOT place both logos in a flex row or rely on CSS classes without explicit absolute positioning. Logos can disappear behind background images if z-index is not set.

### 3b. Pilot Success Metrics (The Ask Page)

Ch 4 (The Ask) MUST include a "Pilot Success Metrics" table showing KPIs, not just a timeline. This shows what success looks like.

**Required KPIs**:
| Metric | Target |
|--------|--------|
| Search Conversion Rate | +10-15% |
| Zero-Results Rate | Reduce by 30-50% |
| Time-to-First-Click | Reduce by 20% |
| NLP Query Success | Measure "gift for mom" type queries |
| Federated Content | Help/policy content findable |

**Layout**: Two-column on The Ask page:
- **Left**: Pilot timeline (4-6 week steps: catalog indexing, InstantSearch, test queries, A/B test)
- **Right**: Pilot Success Metrics table with specific improvement targets

**Callout boxes at bottom**:
1. D2C/vertical expertise callout (Huckberry, Gymshark, Big W references)
2. Expected ROI callout ($X.XM/year with payback period)

### 4. Real Data Charts

Traffic sources, demographics, and competitor comparisons MUST use actual SVG charts, not tables.

**Components**:
- `.donut-multi`: Multi-segment donut chart for traffic sources (organic, direct, paid, referral, social, email)
- `.demographics-chart`: Age/gender pie chart with legend
- `.bar-chart-h`: Horizontal bar chart for competitor traffic comparison

**Donut segment calculation**:
- Circumference = 2 × π × 40 = 251.33
- Each segment: `stroke-dasharray = (percentage/100 × 251.33) (251.33 - that value)`
- `stroke-dashoffset` = cumulative length of previous segments (negative)

**Legend**: Always include `.donut-legend` or `.demographics-chart__legend` with color swatches.

### 5. Annotated Screenshots

Every finding screenshot MUST have visual callouts pointing to the specific issue — not just text adjacent to an image.

**Components**:
- `.annotation-circle`: Red circle highlighting area of concern (sizes: --sm, --md, --lg, --xl)
- `.annotation-callout`: Labeled callout box with directional pointer (--left, --right, --top, --bottom)
- `.annotation-number`: Numbered badge for multiple issues
- `.annotation-arrow`: SVG arrow pointing to element (uses `marker-end="url(#arrowhead)"`)

**Example**:
```html
<div class="annotated-screenshot">
  <img src="screenshots/05-typo.png" alt="Typo test">
  <div class="annotation-circle annotation-circle--lg"
       style="top: 45%; left: 30%; transform: translate(-50%, -50%);"></div>
  <div class="annotation-callout annotation-callout--left"
       style="top: 45%; right: 10px;">
    1 RESULT
  </div>
</div>
```

### 6. Gap Diagrams and Radar Charts

The "Strategy vs Execution" story MUST be visualized, not just described in text.

**Components**:
- `.gap-diagram`: Two-column layout (expected vs actual) connected by broken bridge
- `.radar-chart`: Multi-axis radar comparing expected vs actual performance

**Gap diagram structure**:
```html
<div class="gap-diagram">
  <div class="gap-diagram__column gap-diagram__column--expected">
    <!-- What they told investors -->
  </div>
  <div class="gap-diagram__bridge">
    <div class="gap-diagram__bridge-line"></div>
    <div class="gap-diagram__bridge-icon">✕</div>
  </div>
  <div class="gap-diagram__column gap-diagram__column--actual">
    <!-- What the audit found -->
  </div>
</div>
```

**Radar chart**: 5-axis radar with `.radar-chart__polygon--expected` (green) overlaying `.radar-chart__polygon--actual` (red).

### 7. Enhanced Flow Diagrams with Visual Hierarchy

Flow diagrams MUST differentiate between data flows, comparisons, and timelines — not all use the same flat boxes.

**Components**:
- `.flow-enhanced--pipeline`: Data flow with gradient connectors and directional arrows
- `.flow-enhanced--comparison`: Side-by-side with `.flow-enhanced__vs-badge`
- `.flow-enhanced--timeline`: Vertical timeline with `.flow-enhanced__node` milestones

**Box types**:
- `.flow-enhanced__box--source`: Light gray, source data
- `.flow-enhanced__box--algolia`: Blue-purple gradient, Algolia processing
- `.flow-enhanced__box--destination`: Green gradient, buyer experience
- `.flow-enhanced__box--highlight`: Blue border glow for emphasis

### SVG Icon Library

All icons MUST be consistent SVG designs, not emoji or Unicode characters.

**Component**: `.icon` with size modifiers (`--sm`, `--md`, `--lg`, `--xl`) and color modifiers (`--primary`, `--white`, `--critical`, `--positive`, `--gray`).

**Required icons** (defined in template comments):
- Search, Settings/gear, Dollar/revenue, Chart/analytics, Users/people
- Alert/warning, Check, X/close, Target/bullseye, Lightning/speed

### Visual Standards Checklist (Gate 5 Addition)

Before finalizing the PDF, verify:

**Page Layout & Branding:**
- [ ] Cover page has dual logos (Algolia + company) centered at top
- [ ] Cover page has company storefront/HQ photo as background
- [ ] Cover page has `© Algolia Confidential` footer
- [ ] Every chapter has `.page-header` with Algolia logo (left) + company logo (right)
- [ ] Every chapter has `.page-footer` with `© Algolia Confidential` (left) + page number (right)

**Findings Layout (70/30):**
- [ ] Findings use `.finding__body--70-30` grid (7fr 3fr)
- [ ] Left column: large `.annotated-screenshot--large` (takes 70% width)
- [ ] Right column: `.finding__analysis--compact` with problem box, impact stat, solution
- [ ] At least 5 screenshots have `.annotation-circle` or `.annotation-callout`

**Charts & Visualizations:**
- [ ] Score gauge uses radial arc with gradient (not just number)
- [ ] Appendix A uses `.severity-heatmap` with color-coded cells
- [ ] Revenue funnel uses tapered SVG (not CSS rectangles)
- [ ] Traffic sources use `.donut-multi` chart (not table)
- [ ] Demographics use pie/donut chart (not table)
- [ ] Competitor comparison uses `.bar-chart-h` (not table only)
- [ ] "In Their Words" chapter has gap diagram or radar chart
- [ ] Architecture flow uses `.flow-enhanced--pipeline` with directional arrows
- [ ] All icons are SVG (no emoji/Unicode in body content)

## MCP Server Integration (Required Tools)

The audit MUST use these MCP servers. Always prefer MCP data over WebSearch.

### 1. BuiltWith MCP (Phase 1 steps 1, 2, 6)
| Endpoint | Usage |
|----------|-------|
| `domain-lookup` | Prospect + each competitor: search provider, e-commerce platform, analytics, personalization, removed/added tech |
| `relationships-api` | Sister/related sites |
| `recommendations-api` | Technology gap analysis |
| `financial-api` | Revenue estimates, employee count, funding (cross-reference Yahoo Finance) |
| `social-api` | Social profile URLs (LinkedIn, Twitter, Facebook) |
| `trust-api` | Domain trust score, domain age |
| `keywords-api` | Meta keywords, page titles (SEO focus) |
| Fallback: SimilarWeb `get-website-content-technologies-agg` | If BuiltWith credits exhausted |

### 2. SimilarWeb MCP (Phase 1 steps 3, 4, 6)
| Endpoint | Usage |
|----------|-------|
| `get-websites-traffic-and-engagement` | Visits, bounce, engagement (prospect + each competitor) |
| `get-websites-traffic-sources` | Channel breakdown |
| `get-websites-geography-agg` | Top countries |
| `get-websites-demographics-agg` | Age/gender |
| `get-website-analysis-keywords-agg` | Top keywords (branded vs non-branded) |
| `get-websites-audience-interests-agg` | Audience interests |
| `get-websites-website-rank` | Global rank + category rank |
| `get-websites-referrals-agg` | Incoming referral sites |
| `get-pages-popular-pages-agg` | Top pages by traffic share |
| `get-pages-leading-folders-agg` | Top URL folders (site architecture) |
| `get-websites-landing-pages-agg` | Top organic/paid landing pages |
| `get-websites-similar-sites-agg` | Competitor identification |
| `get-websites-keywords-competitors-agg` | Keyword competitors |
| `get-website-content-technologies-agg` | Fallback for BuiltWith |
| Use `country: "ww"` if `"us"` errors | |

### 3. Yahoo Finance MCP (Phase 1 steps 1, 9, 12)
| Tool | Usage |
|------|-------|
| `get_stock_info(ticker)` | Company overview, market cap, employee count |
| `get_financial_statement(ticker, "income_stmt")` | 3-year revenue, net income, EBITDA |
| `get_financial_statement(ticker, "quarterly_income_stmt")` | Most recent quarterly trajectory |
| `get_financial_statement(ticker, "balance_sheet")` | Cash, debt, total assets |
| `get_financial_statement(ticker, "cashflow")` | Free cash flow, capex allocation |
| `get_recommendations(ticker, "recommendations")` | Analyst consensus |
| `get_recommendations(ticker, "upgrades_downgrades")` | Recent rating changes |
| `get_yahoo_finance_news(ticker)` | Latest news, earnings reactions |
| `get_historical_stock_prices(ticker, period="2y")` | 2-year price trajectory |
| `get_holder_info(ticker, "institutional_holders")` | Top institutional investors |
| **Ticker resolution**: WebSearch first — Yahoo Finance MCP has no search tool | |
| **Fallback**: Private company → WebSearch for all financial data | |

### 4. SEC EDGAR MCP (Phase 1 step 12)
| Tool | Usage |
|------|-------|
| `search_filings(ticker, '10-K')` | Find annual filing accession number |
| `search_filings(ticker, '10-Q')` | Find quarterly filing accession number |
| `get_section_text(accession, 'MD&A')` | Item 7 (10-K) / Item 2 (10-Q): digital strategy, e-commerce priorities |
| `get_section_text(accession, 'Risk Factors')` | Item 1A: technology gaps, competition, cybersecurity |
| `get_section_text(accession, 'Business Description')` | Item 1: business overview |
| **Source URLs**: Point to `sec.gov` filing URLs | |
| **Fallback**: Private company or MCP unavailable → WebSearch + WebFetch | |

### 5. Chrome MCP (Phase 1 step 13 + Phase 2)
All browser-based testing. Use real Chrome browser profile — NOT headless.
- Phase 1 Step 13: Visit careers page for deep hiring analysis
- Phase 2: All 20 audit test steps
- Every screenshot persisted to disk immediately
- Follow Browser Audit Resilience guidelines for anti-detection

### 6. WebSearch + WebFetch (Phase 1 various steps)
Used ONLY where no structured MCP endpoint exists:
- Company overview narrative (founding story, business model)
- Executive research (names, titles, backgrounds)
- Hiring signals (job postings, careers page URL discovery)
- Strategic angles (news, expansion, competitive pressure)
- Earnings call transcripts (Seeking Alpha, Motley Fool, IR pages)
- Investor presentations and investor day transcripts
- Ticker resolution
- Industry context and vertical trends
- Negative signal checks

**Ticker Resolution Rule**: At audit start, resolve ticker via WebSearch. Use for ALL Yahoo Finance + SEC EDGAR calls. If no ticker found (private), note in manifest and fall back to WebSearch.

All tools used automatically — no user prompting needed. If any tool is unavailable, note the gap and proceed.

## Default Output Workflow

After completing Phase 3 (Analyze & Score):
1. **Refine Step 14**: Re-read `10-scoring-matrix.md` and update ICP-to-Priority Mapping with audit findings mapped to investor quotes.
2. **Phase 4**: Write report as intermediate working document. Hyperlink every data point. (Run Pre-Deliverable Data Refresh before writing.)
3. **Phase 5a**: Assemble the book — the MAIN deliverable.
   - Copy template files from `~/.claude/skills/algolia-search-audit/templates/`
   - Run Pre-Deliverable Data Refresh (read ALL 12 scratchpad files)
   - Populate every `{{PLACEHOLDER}}` in the HTML with real data
   - Generate variable-count finding sections (one per gap)
   - Generate strategy-execution pairs for "In Their Own Words"
   - Run `/algolia-brand-check` on the HTML — auto-fix below 8/10
   - Convert to PDF via Chrome headless `--print-to-pdf`
   - Verify PDF file size (expected 500KB-2MB)
4. **Phase 5b**: Write AE brief with "Speaking Their Language" section. (Run Pre-Deliverable Data Refresh before writing.)
5. **Phase 5c**: Write signal brief with all standalone insights and source URLs. (Run Pre-Deliverable Data Refresh before writing.)

**Ordering rationale**: The book (5a) MUST be generated first while all 12 scratchpad files are in active context. It is the most data-intensive deliverable — populating 21 chapters + 6 appendices with exact figures. The AE brief and signal brief are shorter and less vulnerable to data drift. The TheRealReal audit proved that deliverables generated after context compaction contain data errors — the book MUST be assembled while scratchpad data is fresh.

All files written to same working directory. Every deliverable uses the same data, findings, screenshots, and SAIM stats. The Pre-Deliverable Data Refresh MUST run before each deliverable regardless of order.

## Lessons Learned from Past Audits

### Tapestry/Coach Audit (2026-02-23) — WAF Blocking & Chrome Recovery

**Problem**: Coach.com uses Akamai WAF which blocked all automated browser attempts. Initial Playwright tests showed "Access Denied" pages. Chrome MCP was not configured in user's MCP settings.

**Symptoms observed**:
- Screenshots were ~30KB (error pages) instead of >100KB (real content)
- Page titles contained "Access Denied"
- Multiple retry attempts failed with same result

**Resolution sequence**:
1. Verified Chrome MCP was missing from `~/.claude/mcp_settings.json`
2. Added Chrome MCP configuration, user restarted Claude Code
3. Chrome MCP still failed (possibly WAF detecting automation signatures)
4. Launched real Chrome with `--remote-debugging-port=9222`
5. Installed puppeteer-core in workspace: `npm install puppeteer-core`
6. Connected to existing Chrome via `puppeteer.connect({ browserURL: 'http://127.0.0.1:9222' })`
7. Used human-like typing delays (50-150ms between keystrokes)
8. Successfully captured 15 valid screenshots (all >100KB)

**Key learnings added to skill**:
- Phase 2 Pre-Flight Checklist (verify Chrome MCP + remote debugging setup)
- WAF Detection & Recovery Protocol
- Search Input Selector Resilience (fallback chain)
- Screenshot Quality Check in Gate 2 (file size validation)

### TheRealReal Audit (2026-02-23) — Post-Compaction Data Hallucination

**Problem**: Content spec was generated after context compaction and contained 12 data errors. Traffic sources, demographics, and competitor bounce rates were all regenerated from lossy memory.

**Symptoms observed**:
- Traffic source percentages were internally consistent (summed to 100%) but factually wrong
- Competitor bounce rates were scrambled (values assigned to wrong companies)
- Other deliverables generated earlier had zero errors

**Resolution**: Added Pre-Deliverable Data Refresh mandate and Data Table Freeze Rule.

### Uncommon Goods Audit (2026-02-23) — Incomplete Book Generation (CRITICAL FAILURE)

**Problem**: Book PDF was generated with only 21 pages instead of expected 30+ pages. Approximately 10 chapters were silently skipped during book assembly, including Tech Stack, AI Gap, Strategic Triggers, Architecture Flow, Pilot Roadmap, and Appendices C-F.

**Root causes identified**:
1. **Context window exhaustion**: By Phase 5a (book assembly), context was nearly full from reading 12 scratchpad files (~35K tokens). Context compaction caused the model to lose track of which chapters had been added vs. which still needed adding.
2. **No chapter-level verification gates**: Skill had Phase-level gates but nothing that verified all 21+ chapters existed in HTML before PDF generation.
3. **No incremental disk writes**: Book assembly tried to populate entire HTML at once. When context compressed mid-way, remaining chapters were forgotten.
4. **No manifest checklist for chapters**: Workspace manifest tracked research steps but NOT book chapter completion.

**Symptoms observed**:
- PDF was 21 pages instead of 30+ (missing ~10 chapters)
- User caught the issue — model did NOT detect it
- Page numbers were out of sequence (jumped from 19 to 15)
- Multiple Acts entirely missing (Act III mostly absent, Act IV appendices missing)

**Resolution (skill updates made)**:
1. **Added Book Chapter Checklist to manifest** (Phase 0): All 21 chapters + 6 appendices must be tracked with `[ ]`/`[x]` checkboxes
2. **Split Phase 5a into 6 sub-phases**:
   - 5a-1: Cover + Act I (chapters 1-3) → save → verify
   - 5a-2: Act II (chapters 4-12) → save → verify
   - 5a-3: Act III (chapters 13-17) → save → verify
   - 5a-4: Act IV (chapters 18-21) → save → verify
   - 5a-5: Appendices A-F → save → verify
   - 5a-6: Final verification gate (BLOCKING)
3. **Added Gate 5 chapter count verification**: `grep -c 'class="chapter"'` must return ≥25
4. **Added Gate 5 PDF page count verification**: `mdls -name kMDItemNumberOfPages` must return ≥28
5. **Added blocking gates**: Audit cannot be marked complete if chapter/page checks fail

**Key lesson**: Context compaction is the #1 enemy of long multi-phase tasks. Any task that fills context MUST have incremental disk writes with verification after each sub-phase. Never trust that "I'll remember to do X later" — by the time "later" arrives, context may have compressed and X is forgotten.

### Costco Audit (2026-02-21) — Richest Intelligence Mining

**Achievement**: Most comprehensive audit to date — 12 scratchpad files, 9 CEO/CFO quotes, 5 SEC 10-K risk factors, ~78-101 hiring roles analyzed, 33-slide deck.

**Key learnings**:
- Scratchpad mining rule: Every file = dedicated slide(s)
- Investor intelligence breadth: Capture quotes from ANY named executive, not just CEO/CFO
- ICP-to-Priority mapping creates the strongest sales angles

### Tapestry/Coach Audit (2026-02-23) — Book Editorial Standards v2

**Achievement**: Refined PDF book with proper page structure, header/footer positioning, and hero screenshot layout.

**Page Structure (CRITICAL)**:
```css
.chapter {
  width: 8.5in;
  height: 11in;
  padding: 0.5in 0.6in 0.7in 0.6in;
  box-sizing: border-box;
  position: relative;
  page-break-after: always;
  overflow: hidden;
}
```

**12 Editorial Standards (v2)**:
1. **Fixed page dimensions**: Each `.chapter` is exactly 8.5in × 11in (letter size)
2. **Header ABSOLUTE TOP**: `position: absolute; top: 0.4in;` — Company logo top-right
3. **Footer ABSOLUTE BOTTOM**: `position: absolute; bottom: 0.35in;` — Algolia mark + "© Algolia Confidential" + page number
4. **Headers/footers on ALL pages**: Including finding pages, appendix, everything
5. **Finding: Screenshot as HERO**: `.tef-screenshot { height: 5in; }` — 55% of usable page
6. **Finding: Full-width stat bar**: `.tef-stat { width: 100%; }` — stretches entire width
7. **Finding: Full-width solution**: `.tef-solution { width: 100%; }` — stretches entire width
8. **SVG text visibility**: NEVER use `fill="#5A5E9A"` (too light). USE `fill="#4B5563"` or `fill="#21243D"`
9. **SVG text size**: Minimum 11px for labels, 13px for important text, always `font-weight="600"+`
10. **Gauge legend expanded**: `viewBox="0 0 240 220"`, legend at `cy="200"` with `font-size="15"`
11. **Section breaks**: Binder-style with gradient background, white text, Chapter I/II/III/IV
12. **Cover page**: Company photo + dual logos (Algolia + Company)

**PDF Generation Command**:
```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new \
  --disable-gpu \
  --no-pdf-header-footer \
  --print-to-pdf-no-header \
  --print-to-pdf="output.pdf" \
  "http://localhost:8788/book.html"
```

**Critical flags**:
- `--no-pdf-header-footer`: Removes Chrome's default localhost URL footer
- `--print-to-pdf-no-header`: Additional header suppression
- Must serve via localhost HTTP server, NOT `file://` URLs

**Template files**: `book-template.html` and `components.css` contain all standards.
