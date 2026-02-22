---
name: algolia-search-audit
description: Run a comprehensive Algolia Search Audit on a prospect website. Takes a URL, performs browser-based search tests, captures screenshots, analyzes findings, and produces a detailed audit report with gaps, industry stats, and Algolia solutions. Use when preparing for a prospect meeting or sales engagement.
---

# Algolia Search Audit (v2.7)

Run a full search experience audit on a prospect's e-commerce or content website, producing a detailed findings report with screenshots, industry benchmarks, Algolia solution recommendations, an AE pre-call brief, and a strategic signal brief — all with full source citations. Includes investor intelligence from SEC filings/earnings calls and deep hiring analysis from actual careers pages.

> **v2.7 Core Principle — "Each finding is a chapter"**: The 12 scratchpad files are a BOOK of research intelligence. Every file is a chapter deserving dedicated slide(s) with full data tables, not thin one-line summaries. When in doubt, give it its own slide. The deck should be ~30-33 slides, not ~24.

## Input

Accept a website URL as `$ARGUMENTS` (e.g., `autozone.com`, `lacoste.com`). If no URL is provided, ask the user for the prospect's website.

Optionally the user may also provide:
- Company name (if different from domain)
- Industry vertical
- Specific areas of focus

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

### Phase 1: Pre-Audit Research (14 steps — no browser needed except Step 13)

> **Pattern per step**: Run API/search → Write structured results to scratchpad file → Continue to next step. This prevents context overflow from ~35K tokens of raw Phase 1 data.
>
> **IMPORTANT: Source URL capture** — For every data point written to a scratchpad file, ALSO capture the source URL. This enables auto-generated hyperlinks in all Phase 4/5 deliverables. Example format in scratchpad:
> ```
> Revenue: $254.2B (FY2024)
>   Source: https://investor.costco.com/annual-reports
> Monthly visits: 187M
>   Source: https://similarweb.com/website/costco.com
> ```

1. **Company Context** (EXPANDED) — Use web search for:
   - Company overview: what they do, industry, founding year, employee count, store/warehouse count
   - Recent news: digital transformation, e-commerce initiatives, leadership changes
   - **Financial data**: Revenue, net income, operating margin (2 WebSearches: "{company} revenue 2025" + "{company} annual report 2025")
   - **Key executives**: CEO, CFO, CTO/CIO, VP eCommerce (WebSearch: "{company} leadership team")
   - **Vertical classification**: Match to vertical-query-library.md categories (Auto Parts, Warehouse/Bulk, Fashion, Luxury/Resale, Home Improvement, Grocery, Electronics, Furniture, Sports/Outdoor, B2B/Industrial)
   - **Margin Zone**: Calculate from EBITDA margin → 🔴 Red (≤10%) / 🟡 Yellow (10-20%) / 🟢 Green (>20%)
   - **Confidence**: Unmarked = 2+ sources agree. ⚠️ = single source or sources disagree.
   - → Write to `01-company-context.md`

2. **Technology Stack Deep Dive** (ENHANCED) — Use BuiltWith (`domain-lookup` tool) to identify:
   - Current search provider (Algolia, Elasticsearch, Coveo, Bloomreach, Klevu, Searchspring, Solr, etc.)
   - E-commerce platform (Shopify, Magento, Salesforce Commerce Cloud, BigCommerce, custom, etc.)
   - Any relevant integrations (analytics, personalization, recommendations)
   - Also call BuiltWith `relationships-api` to discover sister/related sites
   - Also call BuiltWith `recommendations-api` to identify technology gaps and recommendations
   - **Parse "removed" technologies** → displacement signals (e.g., "RichRelevance REMOVED" = vacuum for Algolia Recommend)
   - **Parse "added" technologies in last 6 months** → if search competitor added recently, flag as ⚠️ NEGATIVE SIGNAL
   - Match any detected vendor to displacement quotes in `buyer-persona-reference.md` Section 3
   - Fallback: If BuiltWith credits exhausted, use SimilarWeb `get-website-content-technologies-agg`
   - → Write to `02-tech-stack.md`

3. **Traffic & Engagement Deep Dive** — Use SimilarWeb with ALL of these endpoints:
   - `get-websites-traffic-and-engagement` — monthly visits, bounce rate, pages per visit, avg visit duration
   - `get-websites-traffic-sources` — channel breakdown (organic, direct, paid, social, referral, mail)
   - `get-websites-geography-agg` — top countries by traffic share
   - `get-websites-demographics-agg` — age and gender breakdown
   - `get-website-analysis-keywords-agg` — top keywords driving search traffic (branded vs non-branded)
   - `get-websites-audience-interests-agg` — audience interest categories
   - Use `country: "ww"` if `"us"` errors
   - → Write to `03-traffic-data.md`

4. **Competitor Identification** — Use SimilarWeb to find top 3-5 competitors:
   - `get-websites-similar-sites-agg` — top similar sites by audience overlap
   - `get-websites-keywords-competitors-agg` — keyword competitors (organic)
   - Cross-reference both lists to select the top 3-5 most relevant competitors
   - → Write to `04-competitors.md`

5. **Generate Test Queries** (ENHANCED — vertical library) — Based on the company's vertical from Step 1:
   - Look up the prospect's vertical in `vertical-query-library.md`
   - Pull 10-12 queries from the matching vertical row (broad, specific, NLP, typo, non-product, brand)
   - Add 4-6 company-specific queries (flagship products, house brands, specific product names found on site)
   - Total: 14-18 queries (same range as v2.3 but vertically calibrated)
   - These REPLACE generic query generation — do not generate generic queries separately
   - → Write to `05-test-queries.md`

6. **Competitor Search Analysis** — For each of the top 3-5 competitors identified in step 4:
   a. Use BuiltWith `domain-lookup` to detect their search provider (Algolia, Elasticsearch, Coveo, Bloomreach, etc.)
   b. Use SimilarWeb `get-websites-traffic-and-engagement` for each competitor (quick check — monthly visits and bounce rate only).
   c. **Quick search spot-check** (optional, time permitting): Use Chrome MCP to visit 1-2 competitor sites and run a single typo query. Take a screenshot if the competitor handles it better — creates a powerful comparison slide.
   d. **GOLDEN ANGLE**: If ANY competitor uses Algolia, flag this prominently. This is the strongest sales angle: "Your competitor X already uses Algolia, demonstrating that modern AI-powered search is a competitive requirement in this vertical."
   e. **Output**: Create a competitor matrix:
      | Competitor | Search Provider | Monthly Traffic | Bounce Rate | Uses Algolia? |
      Store this matrix for use in the report, landing page, and deck.
   - → Append to `04-competitors.md`

7. **Strategic Angle Mining** (EXPANDED) — Use web search to find business context:
   a. **Expansion signals**: New stores, new markets, new product lines? Expansion = more SKUs = search becomes more critical.
   b. **Digital transformation**: E-commerce investment, mobile app, headless commerce migration?
   c. **Competitive pressure**: Competitors gaining share? Company lost ground?
   d. **Industry trends**: Macro trends affecting this vertical
   e. **NEGATIVE signal check**: WebSearch for "{company} layoffs 2025 2026" + "{company} earnings miss" + "{company} hiring freeze"
   f. **Output**: 2-3 strategic angles (1-sentence insight + 1-sentence search connection each)
   - → Write to `06-strategic-context.md`

8. **Hiring Signal Detection** (NEW) — Detect active buying signals via job postings:
   - WebSearch: "{company} careers search engineer" + "{company} jobs site search OR relevance OR algolia OR elasticsearch"
   - Match found titles against `buyer-persona-reference.md` Section 1 (Tier 1/2/3 taxonomy)
   - **Signal interpretation**:
     - 🔥 Strong: Tier 1 titles (VP eComm, Director Digital) = budget likely allocated
     - 🟡 Moderate: Tier 2 titles (Engineering Manager, Product Manager) = team building
     - ⚡ Technical: Tier 3 titles (Senior Engineer, Architect) = may be building in-house
     - ⚠️ Caution: "Search Engineer" or "Relevance Engineer" = possible build-vs-buy
   - No matches found = note as potential hiring freeze or stable team
   - → Write to `07-hiring-signals.md`

9. **Financial Context Synthesis + ROI Estimate** (NEW) — Synthesize financial data:
   - From Step 1 financial data: margin zone → sales motion implication
   - **ROI estimate formula** (show the math):
     ```
     Revenue Addressable = Total Revenue × Digital Share × Search-Driven Share (15%)
     Conservative (5% improvement) = Revenue Addressable × 0.05
     Moderate (10% improvement) = Revenue Addressable × 0.10
     ```
   - Use real revenue from Step 1, digital share from SimilarWeb/web search
   - Cite benchmarks: Lacoste +37% search revenue, Decathlon +50% search conversion
   - **Guardrails**: Always show formula + inputs + sources. Label as "directional estimate." Never present as guarantee.
   - → Write to `08-financial-profile.md`

10. **Trigger Event Synthesis** (NEW) — Cross-reference all signals from Steps 1-9:
    - Identify top 3 **positive trigger events** (e.g., "Search vendor removed + hiring search engineers + digital sales +20%")
    - Identify any **⚠️ caution signals** (e.g., "Coveo added 4 months ago", "layoffs announced", "earnings miss")
    - These become the lead narrative in the AE Brief
    - → Append to `06-strategic-context.md`

11. **Vertical Matching** (NEW) — Select best case studies for this prospect:
    - Match prospect vertical to `buyer-persona-reference.md` Section 2 (Industry-to-Case-Study Mapping)
    - Select primary + secondary case study for report citations
    - If BuiltWith detected a specific competitor vendor, select matching displacement quote from Section 3
    - → Append to `01-company-context.md`

12. **Investor Intelligence** (NEW — 10-K / Earnings Call Analysis) — Extract the company's stated strategic priorities using the prospect's OWN words from SEC filings and earnings calls. This is the most powerful sales intelligence because it's unimpeachable — they said it themselves, on the record, to investors.

    **For public companies** (prioritize in this order):
    a. **Earnings call transcripts** — Most quotable. CEO/CFO speak candidly.
       - WebSearch: `"{company} Q4 2025 earnings call transcript"` OR `"{company} latest earnings call digital strategy"`
       - WebSearch: `"{company} investor day 2025 e-commerce"`
    b. **10-K Annual Report (MD&A section)** — Formal, on-the-record strategic priorities.
       - WebSearch: `"{company} 10-K 2025 management discussion analysis digital"`
       - WebSearch: `"{company} annual report 2025 technology investment"`
    c. **Analyst reports / earnings summaries** — Digested, highlight key themes.
       - WebFetch on best result from Seeking Alpha, Macrotrends, Yahoo Finance, or company IR page

    **For private companies** (fallback):
    - WebSearch: `"{company} CEO interview digital strategy 2025 2026"`
    - WebSearch: `"{company} funding series valuation 2025"` (Crunchbase)
    - Use press releases, CEO interviews, conference talks

    **Extraction targets**:
    - 3-5 direct quotes from CEO/CFO about digital/technology/e-commerce priorities
    - Stated e-commerce revenue target or growth goal (forward guidance)
    - Capex allocation: what % goes to digital vs. physical expansion
    - Risk factors mentioning technology, digital capability, or customer experience gaps
    - Any mention of search, discovery, recommendations, personalization, AI in filings
    - Stated priorities that map to Algolia products (even if not directly about search)

    **Output** → Write to `11-investor-intelligence.md`:
    ```
    ## Investor Intelligence — {Company}

    ### In Their Own Words (Sourced Quotes)
    | # | Quote | Source | Date | Source URL | Maps To |
    |---|-------|--------|------|-----------|---------|
    | 1 | "{exact quote}" | Q4 FY2025 Earnings Call | Feb 2025 | {url} | Algolia NeuralSearch |

    ### Forward Guidance
    - E-commerce revenue target: {stated target or "not disclosed"}
    - Digital investment: {stated capex or "not disclosed"}

    ### Risk Factors Mentioning Digital/Technology
    - {risk factor text, paraphrased, with source}

    ### Strategic Priorities (from filings)
    1. {priority 1 — with source + URL}
    ```

    **Guardrails**:
    - Always cite source + date + URL for every quote
    - Use "the company stated" not "the company believes" — we're reporting, not interpreting
    - NEVER fabricate quotes — if not found, say "Limited public investor data available"
    - If no investor data found at all, note it and skip section gracefully — never block the audit

13. **Deep Hiring Analysis** (ENHANCED — replaces shallow Step 8) — Go beyond web search to actually visit the company's careers page.

    **Phase A: Web Search** (keep existing from Step 8):
    - WebSearch: `"{company} careers search engineer"` + `"{company} jobs site search OR relevance OR algolia OR elasticsearch"`
    - WebSearch: `"{company} LinkedIn jobs e-commerce OR digital OR search"`

    **Phase B: Browser Visit** (NEW — Chrome MCP):
    - Navigate to company careers page (typically `{company}.com/careers` or `careers.{company}.com`)
    - Search the careers page for keywords: "search", "relevance", "AI", "machine learning", "e-commerce", "digital", "discovery", "recommendations", "personalization"
    - Take screenshot of search results
    - Count total roles found by category:
      - Engineering (search, relevance, ML, AI, platform)
      - Product (digital product, search product, discovery)
      - Data (data science, analytics, ML engineering)
      - eCommerce (digital commerce, online merchandising)
      - Merchandising (search merchandising, content, catalog)
    - Click into 2-3 most relevant job descriptions and extract:
      - Required skills (Algolia, Elasticsearch, Solr, search relevance, NLP, etc.)
      - Team they'd join (tells us about org structure)
      - Key responsibilities (tells us about current vs. planned capabilities)
      - Any mention of specific technologies or vendors
      - Source URL for each job posting

    **Output** → Write to `07-hiring-signals.md` (overwrite shallow version):
    ```
    ## Hiring Signal Analysis — {Company}

    ### Role Count by Category
    | Category | Open Roles | Notable Titles |
    |----------|-----------|----------------|
    | Engineering | {count} | {titles} |
    | Product | {count} | {titles} |
    | Data/ML | {count} | {titles} |
    | eCommerce | {count} | {titles} |
    | Merchandising | {count} | {titles} |
    | **Total relevant** | **{count}** | |

    ### Job Description Evidence
    **Role: {title}** (posted {date})
    - Source: {URL to job posting}
    - Required: {skills mentioning search/AI/relevance}
    - Team: {team name}
    - Key quote from JD: "{relevant excerpt}"

    ### Signal Interpretation
    - **Signal strength**: {🔥 Strong / 🟡 Moderate / ⚡ Technical / ⚠️ Caution / ❄️ No Signal}
    - **Build-vs-buy risk**: {Low/Medium/High} — based on: {JD language, team structure, tech mentions}
    - **Timing signal**: {e.g., "3 new search roles posted in last 30 days = active buying cycle"}

    ### Implications for Algolia Pitch
    - {e.g., "They're hiring 2 Search Engineers — position Algolia as 'build better with fewer hires'"}
    ```

    **Fallback**: If careers page is behind auth or not navigable, fall back to LinkedIn Jobs + Indeed web searches. Note limitation in output.

14. **ICP-to-Priority Mapping** (NEW — Synthesis step, no new API calls) — Cross-reference investor intelligence + financial profile + audit scoring to create the most powerful sales framing: "You said X → We found Y → Algolia does Z"

    **Input files** (read from scratchpad):
    - `11-investor-intelligence.md` (Step 12 output)
    - `08-financial-profile.md` (Step 9 output)
    - `10-scoring-matrix.md` (Phase 3 output — read after Phase 3 completes)
    - `01-company-context.md` (Step 1 output)

    **Process**:
    1. For each stated priority from investor intelligence: find matching audit finding or Algolia product
    2. For each major audit gap: find supporting investor quote (if available)
    3. Create discovery questions that use the company's OWN language

    **Note**: This step produces a preliminary mapping after Phase 1 using investor data + financial profile. It is **refined after Phase 3** when audit scoring is available, to add specific findings. Write the initial mapping now, then append audit-matched findings after Phase 3.

    **Output** → Append to `06-strategic-context.md`:
    ```
    ## ICP-to-Priority Mapping — "Speaking Their Language"

    ### Priority-to-Product Map
    | Their Stated Priority | Source | Algolia Solution | Discovery Question |
    |---|---|---|---|
    | "{exact quote from CEO}" | Q4 2025 Earnings | NeuralSearch | "You told investors X — we can help with Y" |

    ### Anchor Points for AE
    1. "{Company} told investors {X} — we can accelerate that with {product}"
    2. "{Company}'s 10-K identifies {risk} — our audit confirms: {finding}"
    ```

    **If no investor data available** (Step 12 came back empty): Skip this step. The synthesis can still be done with financial profile + strategic context, but without the "In Their Own Words" framing.

### Phase 2: Browser-Based Search Audit (20 steps)

> **Scratchpad**: Append all browser observations (queries, result counts, screenshots, timing) to `09-browser-findings.md` after each step. Write structured entries, not prose.

Open the website in the browser and systematically test:

> **CORE AUDIT (Steps 2a-2l)** — These 12 steps are the foundation of every search audit. They MUST be executed in full.

#### Step 2a: Initial Observations
- Navigate to the homepage
- Take a screenshot of the homepage with search bar visible
- Note: Is search prominent? Is it a search icon or full bar? Where is it positioned?

#### Step 2b: Empty State Test
- Click on the search bar WITHOUT typing anything
- Take a screenshot of what appears (empty state / popular searches / trending / nothing)
- Note: Does it show suggestions, popular searches, recent searches, or nothing?

#### Step 2c: Search-As-You-Type (SAYT) Test
- Start typing a broad category query letter by letter
- Take a screenshot mid-typing (after 3-4 characters)
- Note: Does autocomplete appear? How fast? What does it show (products, categories, suggestions)?
- Note the latency — is it instant, slight delay, or slow?

#### Step 2d: Full Search Results Test
- Submit the full category query and land on search results page
- Take a screenshot of the results page
- Note: Result quality, layout, filters/facets available, sort options, result count
- Check: Are there at least 4 sort options (Relevance, Price Low-High, Price High-Low, Newest/Rating)?
- Check: Are facets/filters relevant to the category? Do they show count badges?

#### Step 2e: Typo Tolerance Test
- Search each misspelled query from the test list
- Take a screenshot of each typo search result
- Note: Does it return results? Does it show "did you mean..."? Or zero results?

#### Step 2f: Synonym / Colloquial Test
- Search synonym queries
- Note: Does "couch" return same results as "sofa"? Does the site understand colloquial terms?

#### Step 2g: No Results Test
- Search the nonsense query ("asdfghjk")
- Take a screenshot of the no-results page
- Note: What does the page show? Suggestions? Popular products? Just "no results found"?

#### Step 2h: Non-Product Content Test
- Search "return policy", "customer service", "store hours"
- Take a screenshot
- Note: Does it return content/help pages or only product results (or nothing)?

#### Step 2i: Intent Detection Test
- Search a brand name — does it redirect to brand page or filter by brand?
- Search a category name — does it suggest the category?
- Search an attribute + product ("black chest", "red shoes") — does it apply filters?

#### Step 2j: Merchandising Consistency Test
- Search a category term (e.g., "bunk beds")
- Then navigate to that same category via the site's navigation menu
- Take screenshots of both views
- Note: Are the products the same? Same order? Different merchandising?

#### Step 2k: Federated Search Check
- During search-as-you-type, note whether results include:
  - Products
  - Categories/collections
  - Content pages (blog posts, help articles)
  - Brand pages
- Or is it products-only?

#### Step 2l: Mobile Experience (optional)
- Resize browser to mobile viewport
- Repeat a quick search test
- Note: Is mobile search experience good? Responsive?

> **ALGOLIA VALUE-PROP TESTS (Steps 2m-2t)** — These 8 additional steps test capabilities that map directly to Algolia products. They uncover deeper strategic differentiation points.

#### Step 2m: Semantic / Natural Language Search (→ Algolia NeuralSearch)
- Test 2-3 natural language queries: conversational ("comfortable running shoes under $100"), multi-attribute ("red leather bag with zipper"), question-format ("what oil does a 2020 camry take?")
- Compare results with a keyword-equivalent query for each
- Take a screenshot showing both query results side-by-side
- Note: Does the search understand intent or just keyword-match? Do results make semantic sense?

#### Step 2n: Dynamic Facets & Filtering (→ Algolia Dynamic Faceting)
- Search 2-3 different categories and observe the available filters
- Take screenshots showing the filter panel for each category
- Note: Do the filters change based on category context? (e.g., "shoes" shows Size/Color/Brand; "laptops" shows RAM/Screen Size/Processor) Or are filters static/generic across all queries?

#### Step 2o: Popular & Recent Searches (→ Algolia Query Suggestions)
- Click the search bar without typing — does it show "Popular searches", "Trending", or curated suggestions?
- Perform a search, navigate away, then return to search — does it show "Recent searches"?
- Take a screenshot of both states
- Note: Both present = strength; one = gap; neither = significant gap

#### Step 2p: Dynamic Search Categories (→ Algolia Federated Search + Rules)
- While typing or after results load, observe if the experience shows dynamic category suggestions based on popular searches by other users
- Example: typing "nike" shows "Nike Running Shoes", "Nike Air Max" as navigable category links
- Take a screenshot if present
- Note: Present = strength; absent = opportunity for federated search with category rules

#### Step 2q: Personalization Signals (→ Algolia Personalization)
- Observable test: Browse a specific category (click through 3-4 products), then search a broad term
- Look for: "Recommended for you", "Based on your browsing", personalized carousels, results that seem re-ranked based on browse behavior
- Note: Observable signals = strength; no signals = gap. Note that "not observable" does not equal "not present", but Algolia makes personalization visible.

#### Step 2r: Recommendations / Frequently Bought Together (→ Algolia Recommend)
- Navigate to 2-3 product detail pages
- Take screenshots showing the recommendation sections
- Note: Are there "Frequently bought together", "Customers also viewed", "Similar items" sections? Are recommendations relevant or generic/random?

#### Step 2s: Banners & Merchandising Rules (→ Algolia Rules Engine)
- Search for a seasonal or campaign term (e.g., "sale", "clearance", "valentine")
- Search for a brand name — observe if there's a curated brand landing experience
- Take screenshots of any promotional banners, redirects, or boosted products
- Note: Promotional banners/redirects = strength; no merchandising = opportunity for Algolia Rules engine

#### Step 2t: Analytics Visibility (→ Algolia Analytics)
- Look for observable analytics signals: "trending" badges, "bestseller" tags, "most searched" labels, "popular right now" indicators
- Does search appear to learn from aggregate behavior (e.g., popular products ranked higher)?
- Note: Visible analytics signals = strength; no signals = gap (opportunity for Algolia Analytics + Insights)

### Phase 3: Analyze & Score Findings

> **Scratchpad**: Write the complete scoring matrix to `10-scoring-matrix.md` with scores, evidence, and severity for all 10 areas.

For each of the 10 challenge areas, assign a severity:

> **CORE CHALLENGE AREAS (1-6)** — Original 6 areas, always scored:

| Area | Severity Criteria |
|------|------------------|
| **Latency** | HIGH: >500ms or full page reload. MEDIUM: 300-500ms. LOW: <300ms |
| **Typo Tolerance** | HIGH: No typo handling at all. MEDIUM: Partial (works on some). LOW: Good tolerance |
| **Query Suggestions / Empty State** | HIGH: Blank empty state + poor no-results. MEDIUM: One of the two is lacking. LOW: Both handled well |
| **Intent Detection** | HIGH: No category/brand/attribute detection. MEDIUM: Partial. LOW: Good detection |
| **Merchandising Consistency** | HIGH: Major differences between search and browse. MEDIUM: Minor differences. LOW: Consistent |
| **Content Commerce / Front-End UX** | HIGH: No federated search + poor UX. MEDIUM: Some issues. LOW: Good overall |

> **ALGOLIA VALUE-PROP AREAS (7-10)** — Additional areas from steps 2m-2t:

| Area | Severity Criteria |
|------|------------------|
| **Semantic / NLP Search** | HIGH: No NLP understanding, pure keyword match. MEDIUM: Partial (handles some NLP queries). LOW: Good semantic understanding |
| **Dynamic Facets & Personalization** | HIGH: Static filters + no personalization signals. MEDIUM: Some dynamic filtering OR some personalization. LOW: Dynamic facets + visible personalization |
| **Recommendations & Merchandising** | HIGH: No recs + no banners/rules. MEDIUM: Some recs OR some merchandising. LOW: Relevant recs + active merchandising rules |
| **Search Intelligence** | HIGH: None of popular/recent/trending/analytics signals. MEDIUM: 1-2 present. LOW: 3+ signals present |

### Phase 4: Generate Report

Create a comprehensive markdown report in a new file `{company-name}-search-audit.md` in the current working directory.

## Output

The audit produces SIX deliverables, all brand-validated:
1. **`{company}-search-audit.md`** — Full audit report with Strategic Intelligence section elevated after exec summary, competitor landscape, financial profile, trigger events, and ROI estimate (Phase 4)
2. **`{company}-landing-page.html`** — Dual-view landing page following `/algolia-landing` patterns (Phase 5a)
3. **`{company}-search-audit-deck.md`** — **~30-33 slide** McKinsey Pyramid + Cold Open presentation deck. Each scratchpad file gets dedicated slide(s). Title slide with company store photo + logo. 4 Acts with emotional hooks. Source footnotes + Sources appendix. Following `/algolia-deck` patterns (Phase 5b)
4. **`{company}-landing-page.md`** — Landing page content specification (Phase 5c)
5. **`{company}-ae-precall-brief.md`** — AE-facing pre-call brief (NOT for prospect): exec cheat sheet, margin zone, financials, executives, discovery questions, stakeholder targets, hiring signals, trigger events, pilot strategy, ROI estimate (Phase 5e)
6. **`{company}-strategic-signal-brief.md`** — 1-page strategic signal brief designed for downstream LLM consumption (NotebookLM, Gamma, etc.). Every line is a standalone insight with full context. Contains: 60-second story, timing signals, people, money, gaps, angle, pilot strategy (Phase 5f)

All deliverables are validated against `/algolia-brand-check` before finalization (Phase 5d). The AE brief (5e) and signal brief (5f) are generated after brand check since they're internal-only.

### Audit Report Structure

The report must follow this structure:

```markdown
# {Company Name} — Algolia Search Audit
**Date**: {today's date}
**Website**: {url}
**Prepared by**: Algolia

---

## Executive Summary
{2-3 sentence overview of key findings and biggest opportunities}

## Strategic Intelligence

> **Why Now**: {1-sentence timing thesis — e.g., "Three converging signals create an urgent window for Algolia: vendor displacement, accelerating digital sales, and massive catalog expansion."}

### Timing Signals
| Signal | Evidence | Source | Implication |
|--------|----------|--------|-------------|
| {e.g., "Vendor displacement"} | {e.g., "RichRelevance REMOVED from tech stack"} | {BuiltWith, Feb 2026} | {e.g., "Vacuum for Algolia Recommend"} |
| {e.g., "Digital acceleration"} | {e.g., "E-commerce +20.5% YoY"} | {10-K FY2025} | {e.g., "Search quality now revenue-critical"} |
| {e.g., "Catalog expansion"} | {e.g., "28 new warehouses in FY2026"} | {Annual Report} | {e.g., "More SKUs = search relevance harder"} |

### Trigger Events
| Trigger | Opening Line for AE | Source |
|---------|-------------------|--------|
| {trigger 1} | "{conversation starter}" | {source + URL} |
| {trigger 2} | "{conversation starter}" | {source + URL} |
| {trigger 3} | "{conversation starter}" | {source + URL} |

### ⚠️ Caution Signals (shown only when detected)
- {e.g., "Coveo detected as ADDED 4 months ago — prospect may have recently committed"} — Source: {URL}

## In Their Own Words (Investor Intelligence)

> {CEO/CFO quote #1 about digital priority}
> — {Name}, {Title}, {Source + Date}

**What we found**: {matching audit finding}
**Algolia solution**: {product + expected impact}

> {CEO/CFO quote #2 about e-commerce investment}
> — {Name}, {Title}, {Source + Date}

**What we found**: {matching audit finding}
**Algolia solution**: {product + expected impact}

### Forward Guidance
- E-commerce revenue target: {stated target or "not disclosed"} — Source: {URL}
- Digital investment: {stated capex or "not disclosed"} — Source: {URL}

### Risk Factors Mentioning Digital/Technology
- {risk factor text from 10-K, paraphrased} — Source: {URL}

*If no investor data available (private company or limited public data), this section notes "Limited public investor data available" and is omitted.*

## Company Context
- **Industry**: {industry}
- **Monthly Traffic**: {from SimilarWeb}
- **Bounce Rate**: {from SimilarWeb}
- **Pages/Visit**: {from SimilarWeb}
- **Avg. Visit Duration**: {from SimilarWeb}
- **Top Traffic Sources**: {channel breakdown from SimilarWeb — e.g., Direct (42%), Organic (36%), Paid (13%), Social (5%)}
- **Top Geographies**: {from SimilarWeb — e.g., US 78%, Canada 8%, UK 3%}
- **Demographics**: {from SimilarWeb — gender split + peak age groups}

## Technology Stack Deep Dive

> **Source**: BuiltWith `domain-lookup` + `relationships-api` + `recommendations-api`, supplemented by SimilarWeb `get-website-content-technologies-agg`

| Category | Technology | Status | Notes |
|----------|-----------|--------|-------|
| **Search** | {search provider or "None detected"} | {Live/Removed/Unknown} | {e.g., "Oracle Endeca previously used, now removed"} |
| **E-commerce Platform** | {Shopify/Magento/SFCC/Custom/etc.} | Live | |
| **CDN** | {Akamai/Cloudflare/Fastly/etc.} | Live | |
| **Analytics** | {GA/Adobe Analytics/Omniture/etc.} | Live | |
| **Personalization** | {Certona/Dynamic Yield/etc. or "None detected"} | {Live/Removed} | |
| **Recommendations** | {RichRelevance/Nosto/etc. or "None detected"} | {Live/Removed} | {e.g., "RichRelevance REMOVED — vacuum for Algolia Recommend"} |
| **CMS** | {ContentStack/Contentful/WordPress/etc.} | Live | |
| **Payments** | {Stripe/PayPal/Affirm/etc.} | Live | |
| **Bot Detection** | {Cloudflare Bot Mgmt/HUMAN/etc.} | Live | |
| **Other Notable** | {any other relevant tech — reviews platform, A/B testing, etc.} | Live | |

**Related Sites (BuiltWith Relationships)**: {list of sister/related sites if found, or "None detected"}
**Technology Gaps (BuiltWith Recommendations)**: {list of recommended technologies if returned, or "N/A"}

### Search Provider Analysis
- **Current provider**: {detailed analysis — what was detected, what was removed, what's the status}
- **Previous providers**: {any dead/removed tech from BuiltWith history}
- **Implication**: {what this means for the Algolia sales angle — e.g., "No search vendor = greenfield opportunity" or "Removed rec engine = vacuum for Algolia Recommend"}

## Competitor Landscape
| Competitor | Search Provider | Monthly Traffic | Bounce Rate | Uses Algolia? |
|-----------|----------------|-----------------|-------------|---------------|
| {competitor1} | {provider} | {visits} | {rate} | {Yes/No} |
| {competitor2} | {provider} | {visits} | {rate} | {Yes/No} |
| {competitor3} | {provider} | {visits} | {rate} | {Yes/No} |

### Key Insight
{If a competitor uses Algolia: "{Competitor} already uses Algolia, demonstrating that modern AI-powered search is a competitive requirement in this vertical."}
{If no competitor uses Algolia: "None of the top competitors have invested in modern search — {company} has an opportunity to leapfrog the competition."}

## Financial Profile
| Metric | Value | Source |
|--------|-------|--------|
| Revenue | {e.g., $242.3B FY2023} | {10-K / web search} |
| Net Income | {e.g., $6.3B} | {10-K / web search} |
| Operating Margin | {e.g., ~3.3%} | {10-K / web search} |
| EBITDA Margin | {e.g., ~4-5% estimated} | {derived} |
| Public/Private | {e.g., Public (NASDAQ: COST)} | — |

**Margin Zone**: {🔴 Red (≤10% EBITDA) / 🟡 Yellow (10-20%) / 🟢 Green (>20%)}
**Sales motion implication**: {e.g., "Red zone = thin margins. Prioritize fast ROI, tight pilot scope (<$100K), clear KPIs tied to revenue lift or conversion improvement."}

Confidence: Unmarked = 2+ sources agree. ⚠️ = single source or sources disagree.

## Key Executives
| Name | Title | Since |
|------|-------|-------|
| {name} | {title} | {date or "—"} |

Source: Public filings, company website, recent news.

## Hiring Signal Analysis

### Role Count by Category
| Category | Open Roles | Notable Titles | Source URL |
|----------|-----------|----------------|-----------|
| Engineering | {count} | {titles} | {careers page URL} |
| Product | {count} | {titles} | {careers page URL} |
| Data/ML | {count} | {titles} | {careers page URL} |
| eCommerce | {count} | {titles} | {careers page URL} |
| Merchandising | {count} | {titles} | {careers page URL} |
| **Total relevant** | **{count}** | | |

### Job Description Evidence
**Role: {title}** (posted {date}) — [View posting]({URL})
- Required: {skills mentioning search/AI/relevance}
- Team: {team name}
- Key quote from JD: "{relevant excerpt}"

### Signal Interpretation
- **Signal strength**: {🔥 Strong / 🟡 Moderate / ⚡ Technical / ⚠️ Caution / ❄️ No Signal}
- **Build-vs-buy risk**: {Low/Medium/High} — based on: {JD language, team structure, tech mentions}
- **Timing signal**: {e.g., "3 new search roles posted in last 30 days = active buying cycle"}

### Implications for Algolia Pitch
- {e.g., "They're hiring 2 Search Engineers — position Algolia as 'build better with fewer hires'"}

## Revenue Impact Estimate

Revenue Addressable by Search = Total Revenue × Digital Share × Search-Driven Share
Estimated Impact = Revenue Addressable × Improvement Benchmark

{Company}:
  Total Revenue: ${X}B (from Financial Profile)
  Digital Share: ~{X}% (from SimilarWeb / web search)
  Search-Driven Share: ~15% (industry benchmark)
  Revenue Addressable: ${calc}

  Conservative (5% improvement): ~${X}/year
  Moderate (10% improvement): ~${X}/year

  Benchmarks: Lacoste +37% search revenue, Decathlon +50% search conversion

*Estimate based on public data and published Algolia benchmarks. Individual results vary. Directional estimates for conversation purposes only.*

## ICP-to-Priority Mapping — "Speaking Their Language"

*This section maps the company's OWN stated priorities to specific Algolia solutions, creating the most powerful sales framing.*

### Priority-to-Product Map
| Their Stated Priority | What We Found | Algolia Solution | Discovery Question |
|---|---|---|---|
| "{CEO quote from 10-K/earnings}" (Source: {date}) | {matching audit finding with evidence} | {Algolia product + expected impact} | "{You told investors X — when we tested Y, we found Z. How is the team addressing this?}" |

### Anchor Points for AE
1. "{Company} told investors {X} — we can help accelerate that with {Algolia product}"
2. "{Company}'s 10-K identifies {risk} — our audit confirms this: {finding}"
3. "{CFO} said {quote about efficiency} — Algolia delivers {metric} improvement at {pilot cost}"

*If no investor data is available, this section uses strategic context and financial profile to create mapping without "In Their Own Words" framing.*

## Search Audit Findings

### Audit Recap
| Challenge Area | Finding | Severity |
|---------------|---------|----------|
| Latency | {finding} | {HIGH/MEDIUM/LOW} |
| Typo Tolerance | {finding} | {HIGH/MEDIUM/LOW} |
| Query Suggestions / Empty State | {finding} | {HIGH/MEDIUM/LOW} |
| Intent Detection | {finding} | {HIGH/MEDIUM/LOW} |
| Merchandising Consistency | {finding} | {HIGH/MEDIUM/LOW} |
| Content Commerce / Front-End UX | {finding} | {HIGH/MEDIUM/LOW} |
| Semantic / NLP Search | {finding} | {HIGH/MEDIUM/LOW} |
| Dynamic Facets & Personalization | {finding} | {HIGH/MEDIUM/LOW} |
| Recommendations & Merchandising | {finding} | {HIGH/MEDIUM/LOW} |
| Search Intelligence | {finding} | {HIGH/MEDIUM/LOW} |

### Detailed Findings

#### Gap #1: {Title}
**What we tested**: {description}
**What happened**: {observation with specific queries used}
**Screenshot**: {reference to screenshot}
**Why it matters**: {industry stat from SAIM}. **Algolia proof point**: {vertically-matched case study with named customer and specific metric from buyer-persona-reference.md}
**Algolia solution**: {how Algolia fixes this}

{Repeat for each gap found — typically 5-10 gaps}

## Opportunities

### Speed
{Current state vs Algolia's <20ms. SAIM: 39% of shoppers leave if search is slow.}

### Typo Tolerance
{Current state vs Algolia's built-in tolerance. SAIM: 1 in 6 queries have typos.}

### Facets + Filters
{Current state vs dynamic faceting. SAIM: Filter users convert 2x.}

### Federated Search (Product & Content)
{Current state vs federated approach. SAIM: 68% value good search.}

### No Results Page
{Current state vs best practice. SAIM: 75% leave after no results.}

### Smart Relevance
{Current state vs custom ranking. SAIM: 72% have mediocre relevance.}

## Algolia Value-Prop Assessment

| Algolia Product | Current State | Opportunity |
|----------------|---------------|-------------|
| NeuralSearch | {NLP test results from step 2m} | {gap or strength} |
| Dynamic Faceting | {filter test results from step 2n} | {gap or strength} |
| Query Suggestions | {popular/recent from step 2o} | {gap or strength} |
| Personalization | {signals from step 2q} | {gap or strength} |
| Recommend | {FBT/recs from step 2r} | {gap or strength} |
| Rules Engine | {banners/merchandising from step 2s} | {gap or strength} |
| Analytics | {trending/bestseller from step 2t} | {gap or strength} |

## How Algolia Can Help
- **API-first, composable architecture**: Works with any front-end
- **Sub-20ms latency**: Fastest search in the industry
- **AI-powered relevance**: Dynamic Re-Ranking, NeuralSearch, Personalization
- **Merchandising Studio**: Visual rules, banners, pinning, boosting
- **Algolia Recommend**: Frequently Bought Together, Related Products, Trending
- **Implementation Roadmap**: Crawl → Walk → Run → Fly

## Next Steps
1. Share findings with {company} team
2. Define POC scope focused on highest-severity gaps
3. Technical evaluation with Algolia SE
4. Timeline: Typical POC is 2-4 weeks

---
*Report generated using Algolia Search Audit v2.6 methodology. All data points sourced and hyperlinked.*
```

## Phase 5: Generate Deliverables (Brand-Validated)

After the audit report is complete, generate additional deliverables from the audit data. These are produced alongside the markdown report and use the same findings, screenshots, and data.

### 5a: Landing Page — Dual-View HTML (DEFAULT)

Before generating the landing page, read the `/algolia-landing` skill (at `~/.claude/skills/algolia-landing/SKILL.md`) to absorb the section structure, brand colors, font stacks, CTA button specs, and responsive breakpoints. The search audit landing page follows the same architectural patterns with audit-specific content.

**Brand Requirements**: Follow the Brand Requirements section from `/algolia-landing` for all color values, font stacks, CTA button dimensions, responsive breakpoints, and logo placement rules.

Generate a self-contained HTML file `{company-name}-landing-page.html` with Algolia branding (Sora font, Xenon Blue #003DFF, heading text #23263B, body text #5A5E9A, Algolia Purple #5468FF). The landing page MUST include a **tabbed dual-view interface** with two views:

#### Tab 1: Executive Summary (default active tab)
An abridged, high-impact view for busy stakeholders:
- Hero section with headline, key stat, and CTA
- Metrics bar (monthly visits, gaps found, strengths confirmed, annual revenue)
- Findings summary cards (one card per gap with severity badge, short description, Algolia solution one-liner)
- Before/After comparison (current state vs. with Algolia — bullet lists)
- Industry stats bar (4 key SAIM benchmarks)
- Strengths section (numbered list of what's working well)
- How Algolia helps (solution cards mapped to gaps)
- Customer proof (3 case studies with stats: Lacoste, Herschel, Decathlon or relevant)
- Final CTA

#### Tab 2: Deep Dive (full audit detail)
The comprehensive view with all test evidence, strategic context, and opportunities:
- **Company context section**: Industry, revenue, store count, monthly visits, traffic source breakdown (visual bars), technology stack (shown as pills/tags), current search provider status
- **Strategic context section**: Business-level insights mined in Phase 1 — company expansion plans, competitor search capabilities, industry trends that amplify the importance of search. Format as 2-3 callout cards with icon, headline, and 2-sentence explanation. Example: "AutoZone is adding 200+ stores/year — search becomes the digital thread connecting online browsing to in-store inventory discovery."
- **Competitor search landscape**: Which competitors use Algolia or other modern search providers (detected via BuiltWith in Phase 1). Show as a comparison table: | Competitor | Search Provider | Key Advantage |. If a competitor uses Algolia, highlight with a callout: "Competitor X already uses Algolia — their search experience demonstrates what is achievable."
- **Algolia value-prop assessment**: Summary of findings from steps 2m-2t mapped to Algolia products (NeuralSearch, Dynamic Faceting, Query Suggestions, Personalization, Recommend, Rules Engine, Analytics). Show as a table with current state and opportunity.
- **Audit methodology section**: How we tested (20 steps), 10 challenge areas, number of test queries used
- **Detailed gap analysis** — one expandable card per gap, each containing:
  - **What we tested**: The specific query or scenario
  - **What happened**: Detailed observation with exact numbers (result counts, facet differences)
  - **Screenshot placeholder**: Gray box with screenshot reference ID (e.g., "Screenshot: ss_7963jp55t — 'return policy' search results") — sized at 16:9 aspect ratio with the reference ID visible
  - **Why it matters**: SAIM industry stat with source attribution
  - **Algolia solution**: Specific Algolia capability that solves this, with brief technical explanation
- **Scoring table**: Full 10-area challenge matrix with severity color coding (HIGH=red, MEDIUM=amber, LOW=green)
- **Expanded strengths**: Each strength with supporting detail from the audit
- **Opportunities section**: ALL opportunities identified (typically 8-12), each with current state, target state, SAIM stat, and Algolia capability
- **Technical fit section**: How Algolia integrates with the company's existing tech stack
- **Next steps timeline**: Visual timeline (Weeks 1-2: Scoping → Weeks 3-6: POC → Week 7: Results Review)

#### Tab UI Requirements
- Sticky tab switcher below the navigation bar
- Tabs labeled "Executive Summary" and "Deep Dive"
- URL hash support (#executive and #deep-dive) for direct linking
- Hero section, Metrics Bar, CTA section, and Footer are SHARED between both views (always visible)
- Smooth transition between views (CSS only, no external JS libraries)
- Responsive design — single column on mobile, tabs stack as full-width buttons

### 5b: Presentation Deck (Markdown for Google Slides)

Before generating the deck, read the `/algolia-deck` skill (at `~/.claude/skills/algolia-deck/SKILL.md`) to absorb the slide layout types, brand requirements, speaker notes format, and compliance rules.

Generate a markdown file `{company-name}-search-audit-deck.md` using the **McKinsey Pyramid + Hollywood Cold Open** structure. The deck leads with the conclusion (Slide 2 = the entire story in 30 seconds), then builds evidence across 4 acts with emotional hooks between every slide. Source footnotes on every data slide. Sources appendix at end.

> **STORYTELLING PRINCIPLE**: This deck is directed like a movie. The Cold Open gives the whole picture immediately (McKinsey Pyramid — answer first, then supporting evidence). Each act builds emotional momentum. "In Their Own Words" comes AFTER the gaps — that's the gut-punch moment when the audience realizes their own leadership acknowledged the problem. Every slide ends with a hook that pulls the audience into the next slide. The deck must work as both a live presentation AND a standalone leave-behind document.

**Deck Structure — McKinsey Pyramid + Hollywood Cold Open (~30-33 slides)**:

> **v2.7 SCRATCHPAD MINING RULE**: Every scratchpad file (01-12) MUST produce at least one dedicated slide. If the scratchpad contains rich data tables, demographics, keyword analysis, or tech displacement signals, it warrants 2-3 slides. Never compress multi-dimensional intelligence into thin one-line summaries. Each finding is a chapter.

| # | Slide | Layout | Content | Scratchpad Source | Hook → Next |
|---|-------|--------|---------|-------------------|-------------|
| 1 | **Title** | Title Slide | **Company store/HQ exterior photo** (golden hour, prominent signage) with dark gradient overlay + company logo + "Search experience audit" + date + Algolia logo + **Status badge** (e.g., "Critical Recommendation Vacuum Detected") | — | — |
| 2 | **The Bottom Line** | Data/Chart | The entire story in 4 bullets: (1) We found X critical gaps costing $Y, (2) Your CEO told investors "{quote}" — we found the opposite, (3) Your competitor already uses [Algolia/modern search], (4) A 30-day pilot can prove $Z impact. McKinsey "answer first" slide. | All files | *"Let us show you what we found."* |
| | **ACT 1: THE COMPANY** | Section Divider | *Understanding who you are* | | |
| 3 | **Company snapshot** | Data/Chart | **Full financial table** (revenue, net income, digitally enabled revenue, warehouse/store count, employee count) + **enriched executive table** with backgrounds (career history, education, recognition, relevance to deal). Not just names — full context. Source footnotes for each. | `01-company-context.md` | *"With this scale, search quality directly impacts revenue."* |
| 3a | **Digital traffic deep dive** | Data/Chart | **Complete traffic analysis**: monthly visits, unique visitors, bounce rate (vs competitors), pages/visit, avg duration + **traffic source breakdown** with strategic signals (e.g., "60.3% direct = members with wallets open") + **geographic concentration**. Compare bounce rate to competitors. | `03-traffic-data.md` | *"But who are these visitors?"* |
| 3b | **Audience DNA** | Data/Chart | **Demographics**: gender split, age distribution with generational insights (e.g., "24.3% age 25-34 — grew up with Google and ChatGPT") + **audience overlap table** (Amazon 48.1%, Walmart 12.9% etc.) + **keyword intent patterns** (navigational %, typo volume, non-product intents). | `03-traffic-data.md` | *"Now let's look at the technology powering their experience."* |
| 4 | **Tech stack upheaval** | Two-Column | **Left: REMOVED technologies** (rec engines, CMS, personalization) with dates. **Right: ADDED technologies** (monitoring, schema, etc.) with dates. **Center: "The gap in the middle"** — search vendor unidentifiable, recs removed, no on-site personalization. "No competing search vendor detected" = green light. | `02-tech-stack.md` | *"This technology displacement creates a vacuum. Let's see who's filling it."* |
| 5 | **Competitive landscape** | Two-Column | **Full BuiltWith-verified matrix**: competitor search providers, dead rec engine counts, bounce rate comparisons, keyword overlap %, retail media revenue comparison. If competitor uses Algolia → golden angle callout. | `04-competitors.md` | *"Your competitors have their own gaps. Here's how your search actually performs."* |
| | **ACT 2: THE EVIDENCE** | Section Divider | *What we found when we tested* | | |
| 6 | **Audit overview** | Data/Chart | 10-area scoring matrix with color-coded severity (🔴 Critical / 🟡 Needs Work / 🟢 Strong). Overall score prominently displayed. Methodology note: X test queries across Y challenge areas. | `10-scoring-matrix.md` | *"Let's walk through the biggest gaps."* |
| 7–N | **Gap slides** (1 per gap) | Image+Text | **One slide per gap found** (typically 5-7 gaps). Each slide has: (1) Storytelling title (not just "Typo Tolerance"), (2) Screenshot with annotation, (3) What we tested + what happened (specific query → specific result with product names + prices), (4) SAIM industry stat, (5) Algolia case study proof point, (6) Strategic nugget connecting to business context. Source footnotes. | `09-browser-findings.md` | Each gap hooks to next |
| N+1 | **What's working well** | Content | 3-4 strengths with ✅ checkmarks. Genuine acknowledgment — builds credibility. | `10-scoring-matrix.md` | *"But here's what makes these gaps especially urgent right now."* |
| | **ACT 3: THE URGENCY** | Section Divider | *Why this matters now — in their own words* | | |
| N+2 | **In their own words** | Content | CEO/CFO quotes from earnings calls / 10-K filings → each mapped to a specific gap from Act 2. Format: "{Quote}" — {Name}, {Title}, {Filing} → *We found: {specific gap}*. Emotional gut-punch. 2-4 quotes max. Source URLs. | `11-investor-intelligence.md` + `12-icp-priority-mapping.md` | *"And their own filings identify the risk."* |
| N+2a | **SEC 10-K risk factors** | Content | **Each technology risk factor from 10-K mapped to a specific audit finding**. Format: Risk Factor → What We Found → Implication. Creates unimpeachable urgency: their own legal filings identify the gap we proved. | `11-investor-intelligence.md` | *"Your own leadership said this matters. And they're hiring for it."* |
| N+3 | **Hiring & investment signals** | Two-Column | **Full multi-source methodology** listed. **Detailed role table** with salary ranges, IT hub locations. **JD evidence quotes** as "smoking gun". Build-vs-buy comparison table (investing-in vs not-investing-in). | `07-hiring-signals.md` | *"The signals point one direction. Let's connect the dots."* |
| N+4 | **Strategic intelligence** | Content | Timing signals table: Signal → Evidence → Implication. Trigger events. Timing window assessment. Source footnotes. | `06-strategic-context.md` | *"The timing is now. Here's what this means in business terms."* |
| | **ACT 4: THE RESOLUTION** | Section Divider | *Connecting insights to action* | | |
| N+5 | **Connecting the dots** | Data/Chart | ICP-to-Priority mapping: "You said X → We found Y → Algolia does Z". 4-6 rows. Investor intelligence + audit evidence + product capability synthesis. | `12-icp-priority-mapping.md` | *"And the financial impact?"* |
| N+6 | **Executive profiles** | Content | **Full profile tables per executive**: Background, Education, Recognition, Current situation, Key insight, Frame, Lead-with. Leadership dynamics table (who's new, who's expanding scope, who retired). | `01-company-context.md` + `11-investor-intelligence.md` | *"Now let's quantify the opportunity."* |
| N+7 | **The business case** | Data/Chart | ROI with shown math. Margin-zone-aware framing. Conservative estimate. Source: traffic data + benchmarks. | `08-financial-profile.md` | *"Here's how we get started."* |
| N+8 | **Pilot strategy** | Content | Margin-aware scope: 30-day A/B pilot. KPIs. Budget framing per margin zone. | `08-financial-profile.md` | *"Let's schedule the technical deep dive."* |
| N+9 | **Next steps + CTA** | CTA | Clear timeline. Contact info. Calendar link. | — | — |
| | **APPENDIX** | Section Divider | *Supporting materials* | | |
| A1 | **Sources** | Content | All URLs grouped by category. Hyperlinked. | All files | — |
| A2 | **Full tech stack** | Data/Chart | Complete BuiltWith analysis with "Since" dates, all removed/added tech, related properties. | `02-tech-stack.md` | — |
| A3 | **Algolia value-prop assessment** | Data/Chart | 7-row product mapping. | `10-scoring-matrix.md` | — |
| A4 | **Full test query matrix** | Content | All test queries with category, result, and score. | `05-test-queries.md` + `09-browser-findings.md` | — |
| A5 | **Full traffic source data** | Data/Chart | Complete keyword table, channel breakdown, audience overlap table with affinity scores. | `03-traffic-data.md` | — |

> **SLIDE COUNT NOTE (v2.7)**: The deck will be **~30 slides with 5 gaps, ~33 with 7 gaps**. The variable is Act 2 gap slides (one per gap found). Never compress multiple gaps into one slide — each gap deserves its own evidence + screenshot + hook. Never compress scratchpad intelligence into thin summaries — each scratchpad file is a chapter deserving full depth.
>
> **PRESENTATION STANDARDS**: Title slide MUST have company store/HQ exterior photo with dark gradient overlay + company logo + status badge. This anchors the digital audit to the physical business reality. Previous versions had this — never lose it across sessions.
>
> **DEPTH REQUIREMENTS PER SLIDE**:
> - Company Snapshot: Full financial TABLE (not just bullets), enriched exec table with backgrounds
> - Traffic Deep Dive: Bounce rate COMPARED to competitors, traffic source signals (not just percentages)
> - Audience DNA: Generational insights, audience overlap with strategic implications
> - Tech Stack: Two-column REMOVED vs ADDED with dates, "the gap in the middle" highlighted
> - Competitors: Dead rec engine counts, keyword overlap %, retail media revenue comparison
> - Hiring: Salary ranges, IT hub locations, JD quote evidence, multi-source methodology
> - Executives: Full profile tables, not just name/title/date
> - SEC 10-K: Each risk factor mapped to specific audit finding (not paraphrased generically)

**Slide Format Requirements** — Each slide must include:
- **Layout**: Title Slide / Content / Data/Chart / Two-Column / Image+Text / CTA / Section Divider
- **Background**: Nebula Blue #003DFF for title/section dividers/CTA; White for content/evidence slides
- **Title**: Sentence case, max 6 words — every title should intrigue, not just label
- **Body**: Max 4 bullets per slide — ruthless editing, no filler
- **Visual Notes**: Screenshot references, layout instructions, color guidance
- **Speaker Notes**: 2-4 sentences per slide including the emotional hook and strategic connection
- **Source Footnotes**: Every data point gets a superscript footnote → source URL at slide bottom

**Speaker Notes Guidance**: Every slide's speaker notes must include:
1. The key point to land (what the audience should remember)
2. The strategic connection (why this matters for THIS company specifically)
3. The transition hook (exact words to say when moving to the next slide)
4. For gap slides: "Given that {company} is {strategic context}, this gap is particularly costly because {specific business impact}..."

**Emotional Continuity Rules**:
- Slide 2 (The Bottom Line) creates the "wait, what?" moment — audience wants to see the evidence
- Act 2 gap slides build mounting concern — each gap compounds the previous
- The transition from Act 2 → Act 3 is the pivot: "Here's what makes this urgent"
- "In Their Own Words" (slide N+2) is the emotional climax — their own leaders' words mapped to our evidence
- Act 4 provides relief through resolution — "here's how to fix it"

Brand compliance: Sentence case throughout, no periods on single-line bullets, Algolia Purple #5468FF for accents, no competitor names in customer-facing context (use "legacy solutions"), approved stats only (17,000+ customers, 1.75T searches).

### 5c: Landing Page Markdown Content Spec

Also generate `{company-name}-landing-page.md` — a markdown content specification that documents all copy, section structure, CTAs, A/B test recommendations, and heatmap focus areas for the landing page. This serves as the content brief that the HTML implements.

### 5e: AE Pre-Call Brief (5th deliverable — NOT for prospect)

Generate `{company}-ae-precall-brief.md` — a concise AE-facing preparation document. This is NOT shared with the prospect. It arms the AE for the meeting.

**Structure**:

1. **Executive Cheat Sheet** (5 scannable bullets):
   - Revenue + margin zone (🔴/🟡/🟢)
   - Business model + key metric (e.g., "membership-based warehouse club, 900+ locations")
   - Digital focus / transformation status
   - Top search gap (from audit — one sentence)
   - Opportunity in one sentence + ROI estimate

2. **Financial Profile** — Revenue, EBITDA margin, margin zone classification, sales motion implication (from scratchpad `08-financial-profile.md`)

3. **Key Executives** — Names, titles, effective dates (from scratchpad `01-company-context.md`)

4. **Recent News & Trigger Events** — Top 3 positive triggers + any ⚠️ caution signals (from scratchpad `06-strategic-context.md`)

5. **Audit Highlights** — Top 3 findings from the search audit with specific evidence (query + result count + severity)

6. **Discovery Questions** — 6-8 questions derived from audit findings + margin zone. Examples:
   - "We noticed [specific tech] was recently removed — what's the plan for [capability]?"
   - "[NLP query] returned [wrong result] — how are you handling natural language queries today?"
   - "With [expansion metric], how is the growing catalog affecting search quality?"
   - "What's the cost of doing nothing on search quality as digital sales grow [X]% annually?"

7. **Stakeholder Targets** — Per buyer-persona-reference.md Section 5:
   | Role | Why They Care |
   |------|-------------|
   | VP of eCommerce | Owns digital revenue; search is primary conversion lever |
   | Head of Digital Product | Owns search UX; directly feels pain of gaps found |
   | Merchandising Lead | Wants brand landing, promotional search rules |
   | IT / Search Engineering Lead | Evaluates technical fit; API-first architecture |
   | Finance Sponsor | Needs ROI justification; margin zone guidance helps |

8. **Pilot Strategy** — Based on margin zone:
   - **Scope**: 30-day A/B pilot focused on highest-impact gap
   - **KPIs**: Tied to specific metrics (AOV, conversion, click-through)
   - **Budget framing**: Red Zone = <$100K with clear 30-day measurables; Yellow = standard POC; Green = larger scope OK

9. **Competitive Context** — Which competitors use what search + golden angle if applicable

10. **Speaking Their Language** (NEW — v2.6) — Discovery questions reframed using the company's OWN language from SEC filings/earnings calls:
    - For each ICP-to-Priority mapping from Step 14: create a conversational discovery question
    - Example: "You told investors digital member experience is a priority — when we tested search, complex queries returned insurance plans instead of TVs. How is the team addressing this?"
    - These are the highest-leverage questions because they anchor to the company's OWN stated goals

### 5d: Brand Compliance Validation

After generating all deliverables, run the `/algolia-brand-check` validation process (as defined in `~/.claude/skills/algolia-brand-check/SKILL.md`) against:

1. The landing page HTML content (content type: "landing page", audience: "business decision-makers")
2. The presentation deck content (content type: "deck", audience: "prospect")

Check all 7 dimensions:
- Voice & Tone — confident, clear, technically credible
- Terminology — correct product names (Algolia Search, Algolia Recommend, etc.)
- Editorial Standards — AP Style, Oxford comma, sentence case headings
- Messaging Accuracy — only approved stats (17,000+ customers, 1.75T searches)
- Visual Compliance — correct hex values (#003DFF, #23263B, #5468FF), font references
- Anthropomorphism — Algolia "enables" not "thinks"
- Competitor Mentions — no competitor names in customer-facing materials (use "legacy solutions")

If any dimension scores below 8, apply fixes inline before writing the final files. The brand check results are not written as a separate file — they inform automatic corrections.

### 5f: Strategic Signal Brief (6th deliverable — for downstream LLM consumption)

Generate `{company}-strategic-signal-brief.md` — a 1-page strategic signal brief designed specifically for downstream LLM consumption (NotebookLM, Gamma, etc.). Every line must be a **standalone insight with full context** — LLMs drop context from the middle, so signal density matters more than narrative flow.

**Structure**:

```markdown
# {Company} — Strategic Signal Brief
*Generated: {date} | Algolia Search Audit v2.6*

## The 60-Second Story
{3-4 sentences: who they are, biggest search gap, why now, what Algolia offers. Each sentence standalone.}

## Timing Signals
- SIGNAL: {signal}. EVIDENCE: {specific data}. SOURCE: {url}. IMPLICATION: {what it means for Algolia}.
{Repeat for each signal — typically 3-5}

## In Their Own Words
- QUOTE: "{exact CEO/CFO quote}". SOURCE: {filing + date + url}. MAPS TO: {Algolia product}. FINDING: {what our audit found}.
{Repeat for each quote — typically 2-4}

## People
- {Name}, {Title} (since {date}). RELEVANCE: {why this person matters for the deal}. SOURCE: {url}.

## Money
- Revenue: ${X}. Margin: {X}% ({zone}). Digital share: ~{X}%. SOURCE: {url}.
- Revenue addressable by search: ${calc}. Conservative 5% improvement: ~${X}/year.
- Pilot budget: <${X} based on {margin zone reasoning}.

## Gaps (ranked by severity)
1. GAP: {title}. SEVERITY: {HIGH/MEDIUM/LOW}. EVIDENCE: {query} → {result}. SAIM: {stat}. ALGOLIA: {product}. CASE STUDY: {customer + metric}.
{Repeat for each gap — all gaps, not just top 3}

## Hiring Intelligence
- TOTAL RELEVANT ROLES: {count}. CATEGORIES: {breakdown}. SOURCE: {careers page url}.
- BUILD-VS-BUY RISK: {level}. EVIDENCE: {JD keywords/language}.

## Competitive Landscape
- {Competitor}: uses {search provider}. Traffic: {visits}. SOURCE: {builtwith url}.
{If golden angle}: GOLDEN ANGLE: {competitor} uses Algolia.

## ICP Mapping
- THEIR PRIORITY: "{quote}". OUR FINDING: {audit evidence}. ALGOLIA SOLUTION: {product}. DISCOVERY QUESTION: "{question}".

## The Angle
{2-3 sentences: recommended approach, pilot strategy, who to target}

## Sources
{All URLs used, grouped by category: Financial, Tech Stack, Traffic, Hiring, Investor}
```

**Key design principle**: Every bullet is self-contained. A downstream LLM can extract any single line and it makes sense without surrounding context. This prevents the "context dropping" problem observed with NotebookLM v1-v2.

## Key Reference Data (SAIM - Search Audit Impact Map)

Use these statistics when writing "Why It Matters" sections:

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

> **CRITICAL**: Before proceeding to each next phase, verify ALL checklist items. If any item is missing, go back and complete it. Do NOT skip items. These gates prevent data loss in deliverables.

### Gate 1: After Phase 1 (Pre-Audit Research) — Verify before opening browser

**Data Collection (Steps 1-6)**:
- [ ] **BuiltWith `domain-lookup`** called for prospect → tech categories logged + removed/added tech parsed
- [ ] **BuiltWith `relationships-api`** called → sister/related sites logged (or "none found")
- [ ] **BuiltWith `recommendations-api`** called → tech gap recommendations logged (or "N/A")
- [ ] **SimilarWeb traffic** called (6 endpoints): traffic-and-engagement, traffic-sources, geography, demographics, keywords, audience-interests
- [ ] **SimilarWeb competitors** called (2 endpoints): similar-sites, keywords-competitors → top 3-5 competitors identified
- [ ] **BuiltWith `domain-lookup`** called for EACH competitor → search provider detected per competitor
- [ ] **SimilarWeb traffic** called for each competitor (at minimum: traffic-and-engagement)

**v2.4 Enrichment (Steps 7-11)**:
- [ ] **Financial data** collected → revenue, margin, EBITDA → margin zone classified (🔴/🟡/🟢)
- [ ] **Key executives** identified → at least CEO + CFO or CTO (note if roles aren't publicly listed)
- [ ] **Vertical classified** → matched to vertical-query-library.md
- [ ] **Test queries** generated from vertical library (14-18 queries, vertically calibrated)
- [ ] **Hiring signals** checked → buyer-persona titles searched on career pages
- [ ] **Strategic angles** documented (2-3) + negative signals checked
- [ ] **Trigger events** synthesized → top 3 positive + any ⚠️ caution signals
- [ ] **ROI estimate** calculated → formula with shown math
- [ ] **Vertical case studies** selected → primary + secondary from buyer-persona-reference.md
- [ ] **Competitor matrix** populated:
  | Competitor | Search Provider | Monthly Traffic | Bounce Rate | Uses Algolia? |

**v2.6 Enrichment (Steps 12-14)**:
- [ ] **Investor Intelligence** collected → 10-K/earnings quotes with source URLs (or "Limited data" noted for private companies)
- [ ] **Deep Hiring** executed → careers page visited via Chrome MCP, role counts by category, JD evidence with URLs
- [ ] **ICP-to-Priority Mapping** created (preliminary — refined after Phase 3 scoring)
- [ ] **Source URLs captured** in all scratchpad files (01-11)

**All scratchpad files written (01 through 11). Workspace manifest updated.**

### Gate 2: After Phase 2 (Browser Testing) — Verify before scoring

- [ ] All 12 core steps executed (2a-2l): homepage, empty state, SAYT, full results, typo, synonyms, no results, non-product, intent, merchandising, federated, mobile
- [ ] All 8 Algolia value-prop steps executed (2m-2t): NLP, dynamic facets, popular searches, dynamic categories, personalization, recommendations/FBT, banners/merchandising, analytics
- [ ] Screenshots captured and persisted for each step
- [ ] Specific queries and result counts logged (not just "good" or "bad" — actual numbers)

### Gate 3: After Phase 3 (Scoring) — Verify before writing report

- [ ] All 10 areas scored (not just 6): Latency, Typo Tolerance, Query Suggestions, Intent Detection, Merchandising, Content Commerce, **Semantic/NLP, Dynamic Facets & Personalization, Recommendations & Merchandising, Search Intelligence**
- [ ] Each score has supporting evidence (query tested, result count, screenshot reference)
- [ ] Overall score calculated with severity counts (HIGH/MEDIUM/LOW)

### Gate 4: After Phase 4 (Report) — Verify before generating deliverables

The report MUST contain ALL of these sections (check each):
- [ ] Executive Summary (with overall score, key finding, strategic context)
- [ ] **Strategic Intelligence** (timing signals table, trigger events with opening lines, caution signals)
- [ ] **In Their Own Words** (CEO/CFO quotes mapped to findings — or "Limited data" note for private companies)
- [ ] Company Context (industry, traffic, demographics, traffic sources, geographies)
- [ ] **Technology Stack Deep Dive** (full BuiltWith table with categories, relationships, recommendations, search provider analysis)
- [ ] Competitor Landscape (matrix table with search providers)
- [ ] **Financial Profile** (revenue, margins, margin zone, sales motion implication)
- [ ] **Key Executives** (name, title, since — at least CEO + CFO/CTO)
- [ ] **Hiring Signal Analysis** (role count by category, JD evidence, signal interpretation, build-vs-buy risk)
- [ ] **Revenue Impact Estimate** (formula with shown math, benchmarks)
- [ ] **ICP-to-Priority Mapping** (priority-to-product table, anchor points for AE)
- [ ] Audit Recap (10-row scoring table)
- [ ] Detailed Findings (5-10 individual gap writeups with queries, results, screenshots, SAIM stats, **vertical-matched Algolia proof points**)
- [ ] Opportunities (6 subsections with SAIM stats)
- [ ] Algolia Value-Prop Assessment (7-row table mapping products to test results)
- [ ] How Algolia Can Help
- [ ] Next Steps
- [ ] Methodology
- [ ] **Source URLs** present throughout report (hyperlinked on every data point)

**If any section is missing or has placeholder data, fix it before proceeding.**

### Gate 5: After Phase 5 (Deliverables) — Verify before completion

- [ ] All 6 files exist: `{company}-search-audit.md`, `{company}-landing-page.html`, `{company}-search-audit-deck.md`, `{company}-landing-page.md`, `{company}-ae-precall-brief.md`, `{company}-strategic-signal-brief.md`
- [ ] Landing page HTML includes tech stack in Company Context section (shown as pills/tags)
- [ ] Landing page Deep Dive tab includes technology context + strategic intelligence + investor quotes
- [ ] Brand check completed (or auto-fix applied) on landing page + deck
- [ ] AE brief contains: exec cheat sheet, margin zone, financials, discovery questions, stakeholder targets, pilot strategy, **"Speaking Their Language" section with investor-anchored questions**
- [ ] Signal brief contains: all standalone insights with source URLs, In Their Own Words quotes, hiring intelligence, ICP mapping
- [ ] **Source citations present** across all deliverables: inline hyperlinks (report, AE brief), footnotes (deck), source badges (landing page), source URLs (signal brief)
- [ ] Scratchpad workspace cleaned up (optional — leave for debugging if needed)

## Important Notes

- Take clear, well-timed screenshots at each test step — these are crucial for the report, landing page, AND deck
- Be objective in findings — note both strengths and weaknesses
- Focus on issues that Algolia can solve
- The report should be actionable and specific, not generic
- Use the prospect's actual product names and categories in examples
- If the site already uses Algolia, note that and focus on optimization opportunities instead
- **Always generate all six deliverables** (report, landing page HTML, deck, landing page MD, AE pre-call brief, strategic signal brief) — they are a complete package
- **Source every data point** — every number, quote, and claim must have a hyperlinked source URL. This creates credibility, trust, and authority. Sources survive forwarding.
- The landing page HTML MUST always include the dual-view tabbed interface (Executive Summary + Deep Dive) — this is the default, not optional
- **v2.7 — "Each finding is a chapter"**: The 12 scratchpad files are a BOOK of golden research intelligence. When generating the deck, READ ALL 12 FILES FIRST, then ensure every file has at least one dedicated slide with full data tables, comparison columns, and strategic insights. Never compress traffic data, demographics, tech stack displacement, hiring JD evidence, or investor quotes into thin one-line summaries. If data is rich enough for 2-3 slides, give it 2-3 slides.
- **v2.7 — Presentation quality standards**: Title slide MUST have company store/HQ photo + logo + status badge. This standard was established in v2.2 and must never deteriorate across sessions. Verify title slide quality, scratchpad mining depth, and total slide count (~30-33) on every deck generation.
- **v2.7 — Scratchpad → Slide depth examples** (from Costco audit):
  - Traffic data → TWO slides: Digital Traffic Deep Dive (bounce rate vs competitors, traffic source signals) + Audience DNA (demographics, audience overlap with Amazon 48.1%, keyword intent patterns)
  - Tech stack → ONE slide: Tech Stack Upheaval (two-column REMOVED vs ADDED with dates, "the gap in the middle")
  - Hiring signals → ONE enriched slide: Multi-source methodology, salary ranges ($188K-$240K), IT hub locations, JD "smoking gun" quotes, build-vs-buy comparison table
  - Investor intelligence → TWO slides: In Their Own Words (CEO/CFO quotes mapped to gaps) + SEC 10-K Risk Factors (each risk mapped to specific finding)
  - Executives → ONE enriched slide: Full profile tables with Background, Education, Recognition, Current situation, Key insight, Frame, Lead-with
- The presentation deck is designed for Google Slides — each slide's Visual Notes describe layout, and Speaker Notes provide talking points
- **Never compress Phase 1 data into single lines** — the Technology Stack Deep Dive, Traffic Deep Dive, and Competitor Landscape deserve full sections with tables, not single bullet points

### Screenshot Handling & Persistence

Screenshots are captured via Chrome MCP during Phase 2. **Every screenshot MUST be immediately persisted to disk** after capture:

1. After each `computer` tool `screenshot` action, immediately save the screenshot to `screenshots/{nn}-{query-slug}.jpg` in the working directory
2. Use the Chrome MCP `upload_image` tool or download mechanism to persist the image
3. Naming convention: `01-homepage.jpg`, `02-empty-state.jpg`, `03-sayt-mid-type.jpg`, `04-full-results-shoes.jpg`, `05-typo-brak-pads.jpg`, `13-nlp-comfortable-shoes.jpg`, etc.
4. Screenshot persistence happens IMMEDIATELY after capture — Chrome MCP screenshot IDs are session-bound and cannot be retrieved later

The landing page uses **rich annotated evidence cards** alongside the persisted images:
- Each evidence card includes a **browser URL bar mockup** showing the exact URL tested
- A **visual evidence panel** displaying the query, result count (color-coded: green for good, red for bad, amber for warning), and key observation
- A **caption** summarizing the finding with an emoji indicator (✅ for strengths, ⚠️ for gaps)
- An `<img>` tag pointing to `screenshots/{nn}-{query-slug}.jpg` — the persisted screenshots display automatically
- The `onerror` handler gracefully hides missing images so evidence cards serve as fallback

### MCP Server Integration (Required Tools)

The audit MUST use these MCP servers:

1. **Web Search** (Phase 1 steps 1, 7, 8, 9, 12): Company context, financials, executives, news, competitors, industry trends, expansion signals, hiring signals, strategic angles, negative signals, **investor intelligence (10-K, earnings calls, forward guidance)**
   - **WebFetch** (Phase 1 step 12): Fetch earnings call transcripts, 10-K summaries, or company IR pages for detailed extraction
2. **BuiltWith MCP** (Phase 1 steps 2, 6):
   - `domain-lookup` or `free-api` for prospect tech stack — search provider, e-commerce platform, analytics, personalization
   - `relationships-api` for sister/related sites
   - `recommendations-api` for technology gap analysis
   - Also used for EACH competitor in step 6 to detect their search provider
   - Fallback: SimilarWeb `get-website-content-technologies-agg`
3. **SimilarWeb MCP** (Phase 1 steps 3-4):
   - `get-websites-traffic-and-engagement` — visits, bounce, engagement
   - `get-websites-traffic-sources` — channel breakdown
   - `get-websites-geography-agg` — top countries
   - `get-websites-demographics-agg` — age/gender
   - `get-website-analysis-keywords-agg` — top keywords (brand vs non-brand)
   - `get-websites-audience-interests-agg` — audience interests
   - `get-websites-similar-sites-agg` — competitor identification
   - `get-websites-keywords-competitors-agg` — keyword competitors
   Use `country: "ww"` if `"us"` errors
4. **Chrome MCP** (Phase 1 step 13 + Phase 2 + optional Phase 1 step 6c): All browser-based testing — navigate, interact, take screenshots. **Phase 1 Step 13**: Visit company careers page for deep hiring analysis. Optional competitor spot-checks. **Every screenshot must be immediately persisted to disk.**

All tools are used automatically — no user prompting needed. If any tool is unavailable, note the gap in the report and proceed with available data.

### Default Output Workflow

After completing Phase 3 (Analyze & Score):
1. **Refine Step 14**: Re-read `10-scoring-matrix.md` and update the ICP-to-Priority Mapping in `06-strategic-context.md` with specific audit findings mapped to investor quotes.
2. **Phase 4**: Write `{company}-search-audit.md` — the full audit report with Strategic Intelligence, In Their Own Words, competitor landscape, financial profile, deep hiring analysis, ICP-to-priority mapping, trigger events, and ROI estimate. Read scratchpad files selectively. **Hyperlink every data point to its source URL.**
3. **Phase 5a**: Write `{company}-landing-page.html` — dual-view landing page following `/algolia-landing` patterns, with annotated evidence cards, strategic intelligence, investor quotes, competitor intelligence, and Algolia value-prop assessment. Include source badges.
4. **Phase 5b**: Write `{company}-search-audit-deck.md` — **~30-33 slide** McKinsey Pyramid + Cold Open deck. **Read ALL scratchpad files (01-12) before writing** — each file must produce at least one dedicated slide with full depth. Title slide with company store photo + logo + status badge. Source footnotes per slide. Sources appendix. Follow `/algolia-deck` patterns.
5. **Phase 5c**: Write `{company}-landing-page.md` — content specification
6. **Phase 5d**: Run `/algolia-brand-check` on landing page and deck — auto-fix any issues below 8/10
7. **Phase 5e**: Write `{company}-ae-precall-brief.md` — AE pre-call brief with "Speaking Their Language" section (generated after brand check since it's AE-internal only)
8. **Phase 5f**: Write `{company}-strategic-signal-brief.md` — strategic signal brief with all standalone insights, source URLs, In Their Own Words quotes, hiring intelligence, ICP mapping (generated last since it's the most structured derivative)

All files are written to the same working directory. Every deliverable uses the same data, findings, screenshots, and SAIM stats — they are different presentations of the same audit. The AE brief and signal brief draw from the full enrichment data (financials, executives, hiring signals, trigger events, investor intelligence).
