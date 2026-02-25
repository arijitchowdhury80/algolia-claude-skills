# Algolia Skills for Claude Code

15 slash commands for the Algolia sales and marketing team — **13 brand content skills**, an **automated search audit** skill, and an **audit fact-check** skill. Every content skill references official Algolia brand guidelines. The search audit skill runs live browser-based tests on prospect websites and produces 7 deliverables per audit (including a print-ready PDF book).

---

## Quick Start (Claude Code CLI — Terminal)

```bash
# 1. Install Claude Code if you don't have it
npm install -g @anthropic-ai/claude-code

# 2. Clone and install skills
git clone https://github.com/arijitchowdhury80/algolia-claude-skills.git
cd algolia-claude-skills/
chmod +x install.sh
./install.sh

# 3. Done! Open Claude Code in any directory:
claude
# Type /algolia- to see all 15 commands
```

The 13 brand skills work immediately. For the search audit + fact-check skills, you'll also need to [set up 4 MCP servers](#mcp-server-setup-for-search-audit).

---

## Installation by Environment

### A. Claude Code CLI (Terminal)

Works on macOS, Linux, and WSL. This is the primary way to use the skills.

```bash
# 1. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 2. Clone the repo
git clone https://github.com/arijitchowdhury80/algolia-claude-skills.git
cd algolia-claude-skills/

# 3. Run the installer — copies all skills to ~/.claude/skills/
chmod +x install.sh
./install.sh

# 4. Set up MCP servers for search audit (see section below)

# 5. (Optional) Copy project memory template for best results
cp CLAUDE-template.md ~/.claude/CLAUDE.md

# 6. Verify — open any terminal and run:
claude
# Then type: /algolia-search-audit
# You should see it in the slash command autocomplete
```

### B. VS Code (with Claude Code Extension)

VS Code uses the **same** `~/.claude/skills/` directory as the CLI. Install once, works in both.

```bash
# 1. Install the Claude Code extension in VS Code
#    → Extensions sidebar (Cmd+Shift+X)
#    → Search "Claude Code" by Anthropic
#    → Click Install

# 2. Clone and install skills (same as CLI)
git clone https://github.com/arijitchowdhury80/algolia-claude-skills.git
cd algolia-claude-skills/
chmod +x install.sh
./install.sh

# 3. Set up MCP servers (same commands as CLI — see section below)

# 4. Open VS Code → Claude Code panel → type /algolia-search-audit
```

**That's it** — VS Code reads from `~/.claude/skills/` and `~/.claude.json` just like the terminal CLI.

### C. Google Antigravity (Cloud IDE)

Antigravity uses the **same SKILL.md format** — the only difference is the directory path. No conversion needed.

```bash
# 1. Clone the repo in your Antigravity workspace
git clone https://github.com/arijitchowdhury80/algolia-claude-skills.git

# 2. Choose ONE of these install options:

# Option A — Workspace scope (this project only):
mkdir -p .agent/skills/
cp -R algolia-claude-skills/skills/algolia-* .agent/skills/

# Option B — Global scope (all your Antigravity projects):
mkdir -p ~/.gemini/antigravity/skills/
cp -R algolia-claude-skills/skills/algolia-* ~/.gemini/antigravity/skills/

# 3. Set up MCP servers through Antigravity's IDE settings
#    (same API keys/URLs as CLI — see MCP section below for the values)
```

### D. Another Machine / Different Account

Same steps as above — just clone, install, and add your own API keys:

```bash
# On the new machine:
git clone https://github.com/arijitchowdhury80/algolia-claude-skills.git
cd algolia-claude-skills/
chmod +x install.sh
./install.sh

# Add MCP servers with YOUR API keys (see next section)
# Optionally copy project memory:
cp CLAUDE-template.md ~/.claude/CLAUDE.md
```

### Quick Reference: Skill Locations by Environment

| Environment | Skills directory | MCP config | Install method |
|-------------|-----------------|------------|----------------|
| **Claude Code CLI** | `~/.claude/skills/` | `~/.claude.json` | `./install.sh` |
| **VS Code** | `~/.claude/skills/` | `~/.claude.json` | `./install.sh` |
| **Antigravity (workspace)** | `.agent/skills/` | IDE settings | `cp -R` |
| **Antigravity (global)** | `~/.gemini/antigravity/skills/` | IDE settings | `cp -R` |
| **Cursor / Windsurf** | `~/.claude/skills/` (if using Claude Code backend) | `~/.claude.json` | `./install.sh` |

---

## MCP Server Setup (for Search Audit)

The 13 brand content skills work immediately with zero setup. The search audit and fact-check skills need 4 MCP servers connected. Here's exactly how to set them up.

### Step 1: Get Your API Keys

You need API keys for three services:

| Service | Where to get the key | Cost |
|---------|---------------------|------|
| **SimilarWeb** | [similarweb.com](https://www.similarweb.com/) → Account Settings → API (or ask your Algolia team lead for the shared key) | Paid API |
| **BuiltWith** | [api.builtwith.com](https://api.builtwith.com/) → Sign up → API Keys | Free tier available |
| **Yahoo Finance** | No API key needed — uses the `yahoo-finance-mcp` npm package | Free |

Chrome MCP doesn't need an API key — just a browser extension.

### Step 2: Install Chrome MCP (Browser Automation)

Chrome MCP lets Claude control a Chrome browser to run live search tests and capture screenshots.

```bash
# 1. Install the Chrome extension:
#    → Go to Chrome Web Store
#    → Search "Claude in Chrome" (by Anthropic)
#    → Click "Add to Chrome"
#    → Pin the extension to your toolbar
#    Direct link: https://chromewebstore.google.com/detail/claude-in-chrome/

# 2. Add it to Claude Code (--scope user makes it available in ALL projects):
claude mcp add --transport sse --scope user \
  "Chrome" http://127.0.0.1:21405/mcp/sse

# 3. Verify — make sure Chrome is open with the extension active, then:
claude
# Type: "Take a screenshot of this browser tab"
```

### Step 3: Install SimilarWeb MCP (Traffic Data)

SimilarWeb provides traffic, demographics, keywords, competitor data, and audience insights.

```bash
# Add SimilarWeb MCP — replace YOUR_KEY with your actual API key:
claude mcp add --transport sse --scope user \
  --header "Authorization: Bearer YOUR_SIMILARWEB_API_KEY" \
  similarweb-mcp https://mcp.similarweb.com/sse

# Verify:
claude
# Type: "Get traffic data for amazon.com"
```

### Step 4: Install BuiltWith MCP (Tech Stack Detection)

BuiltWith detects search providers, e-commerce platforms, analytics, and other technologies.

```bash
# Add BuiltWith MCP — replace YOUR_KEY with your actual API key:
claude mcp add --transport sse --scope user \
  --header "Authorization: Bearer YOUR_BUILTWITH_API_KEY" \
  builtwith https://mcp.builtwith.com/sse

# Verify:
claude
# Type: "What technologies does shopify.com use?"
```

### Step 5: Install Yahoo Finance MCP (Financial Data)

Yahoo Finance MCP provides revenue, margins, stock data, and financial statements for public companies.

```bash
# 1. Install the MCP server globally:
npm install -g yahoo-finance-mcp

# 2. Add it to Claude Code:
claude mcp add --transport stdio --scope user \
  yahoo-finance -- npx yahoo-finance-mcp

# Verify:
claude
# Type: "Get financial data for COST"
```

**Note**: For private companies, the audit skill uses industry benchmarks and web research instead.

### Step 7: Verify All Servers

```bash
# List all configured MCP servers:
claude mcp list

# You should see:
#   Chrome         (sse, user)
#   similarweb-mcp (sse, user)
#   builtwith      (sse, user)
#   yahoo-finance  (stdio, user)

# Or inside Claude Code, type:
/mcp
# This shows connection status for all servers
```

### All-in-One Copy-Paste Setup

If you have your API keys ready, run all four commands at once:

```bash
# Replace the two YOUR_*_KEY values with your actual keys:

claude mcp add --transport sse --scope user \
  "Chrome" http://127.0.0.1:21405/mcp/sse

claude mcp add --transport sse --scope user \
  --header "Authorization: Bearer YOUR_SIMILARWEB_API_KEY" \
  similarweb-mcp https://mcp.similarweb.com/sse

claude mcp add --transport sse --scope user \
  --header "Authorization: Bearer YOUR_BUILTWITH_API_KEY" \
  builtwith https://mcp.builtwith.com/sse

npm install -g yahoo-finance-mcp && \
claude mcp add --transport stdio --scope user \
  yahoo-finance -- npx yahoo-finance-mcp
```

These commands store the config in `~/.claude.json` with `user` scope, making the servers available in **every** project — terminal, VS Code, and any Claude Code environment.

### MCP Setup for Antigravity

Antigravity has its own MCP configuration UI. The server URLs and API keys are the same:

| Server | Transport | URL/Command | Auth Header |
|--------|-----------|-------------|-------------|
| Chrome | SSE | `http://127.0.0.1:21405/mcp/sse` | None |
| SimilarWeb | SSE | `https://mcp.similarweb.com/sse` | `Authorization: Bearer YOUR_KEY` |
| BuiltWith | SSE | `https://mcp.builtwith.com/sse` | `Authorization: Bearer YOUR_KEY` |
| Yahoo Finance | stdio | `npx yahoo-finance-mcp` | None |

Add these through Antigravity's **Settings → MCP/Tools** configuration panel.

### Troubleshooting

| Problem | Solution |
|---------|----------|
| Chrome MCP won't connect | Make sure Chrome is open with the extension active. Check port 21405. |
| `claude mcp add` says "command not found" | Install Claude Code first: `npm install -g @anthropic-ai/claude-code` |
| SimilarWeb returns "No data for requested country" | The skill handles this automatically by falling back to worldwide data |
| BuiltWith returns "API Credits: 0" | Free tier credits exhausted. Skill falls back to SimilarWeb tech detection. |
| Skills don't show up after install | Restart Claude Code. Skills are loaded at startup. |
| `/algolia-search-audit` not found | Check that `~/.claude/skills/algolia-search-audit/SKILL.md` exists |
| MCP servers not showing in `/mcp` | Run `claude mcp list` to check. Try `claude mcp remove <name>` and re-add. |

---

## Skills

### Brand Content Skills (13)

| Command | What it does |
|---------|-------------|
| `/algolia-brand-check` | Scan content for brand violations, get a compliance score with fixes |
| `/algolia-algolialize` | Transform any rough content into fully branded output |
| `/algolia-blog` | Generate a blog post with proper structure and tone |
| `/algolia-deck` | Create a presentation with slide-by-slide content and design specs |
| `/algolia-social` | Write posts for LinkedIn, X, Facebook, Instagram, or Reddit |
| `/algolia-email` | Write marketing, sales, or event email copy |
| `/algolia-landing` | Generate landing page copy with section structure and design direction |
| `/algolia-case-study` | Create a customer case study with quantified results |
| `/algolia-brief` | Generate a campaign or creative brief |
| `/algolia-one-pager` | Create a single-page datasheet or product overview |
| `/algolia-partner` | Create co-marketing content (joint blogs, integration pages) |
| `/algolia-ui-copy` | Write UI microcopy (tooltips, errors, empty states, buttons) |
| `/algolia-boilerplate` | Get the right pre-approved company description for any context |

### Search Audit Skill (v3.0)

| Command | What it does |
|---------|-------------|
| `/algolia-search-audit <url>` | Run a full search experience audit on a prospect website |

The search audit automates a 5-phase process:

1. **Pre-Audit Research (14 steps)** — Company context + financials + executives, tech stack deep dive (BuiltWith + SimilarWeb Technologies API cross-check), traffic deep dive (14 SimilarWeb endpoints), competitor identification, vertical test query generation, competitor search analysis, strategic angle mining + negative signals, hiring signal detection, financial context + ROI estimate (Yahoo Finance for public companies), trigger event synthesis, investor intelligence (10-K/earnings call analysis), deep hiring analysis (careers page visit, role counts, JD analysis), ICP-to-priority mapping, **vertical-to-case-study matching**
2. **Browser Testing (20 steps)** — 12 core search tests + 8 Algolia value-prop tests (NLP, dynamic facets, popular searches, personalization, recommendations, merchandising rules, analytics visibility). **Search vendor verification** (TAG DETECTED vs ACTIVE via network request inspection)
3. **Analysis** — Severity scoring across 10 challenge areas (6 core + 4 Algolia value-prop)
4. **Report** — Full markdown audit report with strategic intelligence, investor quotes, competitor landscape, and deep hiring analysis
5. **Deliverables (7 files, all brand-validated, all source-hyperlinked)**:
   - Full audit report (markdown)
   - Landing page (HTML with tabbed dual-view)
   - **Algolia-branded presentation deck** (~30-33 slides) — Every source citation is a clickable hyperlink. Full brand standards (Nebula Blue #003DFF, Space Gray #21243D, Algolia Purple #5468FF), speaker notes (60-90 sec/slide), Google Slides-ready layouts
   - Landing page content spec
   - AE Pre-Call Brief (internal, not for prospect)
   - Strategic Signal Brief (LLM-optimized 1-pager)
   - **Print-ready PDF book** (32+ pages) — Executive-ready format with cover page, table of contents, findings with screenshots, appendices. Generated via Chrome headless.

### Audit Fact-Check Skill

| Command | What it does |
|---------|-------------|
| `/algolia-audit-factcheck <dir>` | Validate all claims across the 6 audit deliverables |

Verifies audit output across 7 dimensions: cross-file consistency, math & logic, reference data, API data accuracy, source citation integrity, investor quote verification, and browser observation fidelity. Produces a scored confidence report, a machine-readable correction manifest, and methodology feedback.

---

## Usage Examples

### Brand skills
```
/algolia-blog AI search trends for e-commerce developers medium
/algolia-social linkedin Algolia NeuralSearch launch announcement
/algolia-brand-check [paste your draft content here]
/algolia-email product-announcement Algolia Recommend 2.0
/algolia-deck Sales pitch for enterprise retail prospect
/algolia-boilerplate press-release long
```

### Search audit
```
/algolia-search-audit costco.com
/algolia-search-audit nordstrom.com "Nordstrom" "Fashion Retail"
/algolia-search-audit homedepot.com "Home Depot" "Home Improvement"
```

### Fact-check (run after audit)
```
/algolia-audit-factcheck costco-v2/
```

---

## Audit Output Files

Each search audit produces 7 files in the working directory:

| # | File | Purpose |
|---|------|---------|
| 1 | `{company}-search-audit.md` | Full report with strategic intelligence, investor quotes, findings |
| 2 | `{company}-landing-page.html` | Dual-view landing page with strategic + competitor sections |
| 3 | `{company}-search-audit-deck.md` | ~30-33 slide McKinsey Pyramid + Cold Open presentation |
| 4 | `{company}-landing-page.md` | Content spec for the landing page |
| 5 | `{company}-ae-precall-brief.md` | Internal AE pre-call brief (not for prospect) |
| 6 | `{company}-strategic-signal-brief.md` | 1-page LLM-optimized strategic signal brief |
| 7 | `{company}-search-audit-book.pdf` | **Print-ready PDF book** (32+ pages) with cover, TOC, findings, appendices |

Plus a `screenshots/` directory with browser screenshots from the audit.

### Using Audit Output with NotebookLM

To create a slide deck from audit output using Google NotebookLM:

1. Upload these **4 files** as sources (not all 6 + scratchpad):
   - `{company}-search-audit-deck.md` (primary — contains the full story arc)
   - `{company}-strategic-signal-brief.md` (dense signal format for LLM consumption)
   - `{company}-search-audit.md` (full report for depth)
   - `{company}-landing-page.html` (visual structure reference)
2. Use the "Slide Deck" feature with the prompt from `notebooklm-deck-prompt.md`

**Do NOT upload scratchpad files** — their content is already incorporated into the deliverables. Uploading both creates RAG retrieval confusion.

### Rendering Audit Output

| Method | Best for |
|--------|----------|
| **VS Code Preview** | Quick markdown preview (Cmd+Shift+V) |
| **Browser** | Open the `.html` landing page directly |
| **Marked.js** | Convert markdown to styled HTML: `npx marked -i report.md -o report.html` |
| **Marp** | Convert deck markdown to actual slides: `npx @marp-team/marp-cli deck.md --html` |
| **Pandoc** | Convert to PDF/DOCX: `pandoc report.md -o report.pdf` |

---

## How It Works

Each skill is a `SKILL.md` file that Claude Code auto-discovers from `~/.claude/skills/`. Brand skills reference shared knowledge files in `algolia-shared-reference/`.

```
~/.claude/skills/
├── algolia-shared-reference/        # Brand knowledge (20 files)
│   ├── brand-core/                  # Voice, tone, terminology, editorial, social policy
│   ├── visual-identity/             # Colors, typography, logo, photography
│   ├── content-templates/           # Templates for each content type
│   ├── examples/                    # Approved descriptions
│   └── frontify-asset-map.md        # Live asset fetching guide
├── algolia-brand-check/SKILL.md
├── algolia-algolialize/SKILL.md
├── algolia-blog/SKILL.md
├── algolia-boilerplate/SKILL.md
├── algolia-brief/SKILL.md
├── algolia-case-study/SKILL.md
├── algolia-deck/SKILL.md
├── algolia-email/SKILL.md
├── algolia-landing/SKILL.md
├── algolia-one-pager/SKILL.md
├── algolia-partner/SKILL.md
├── algolia-search-audit/            # Search audit v3.0 (uses MCP servers)
│   ├── SKILL.md                     # 5 phases, 20 tests, 10 areas, 7 deliverables
│   └── knowledge/                   # Supporting reference data
│       ├── algolia-search-audit.md  # Full audit methodology & Bayard UX guidelines
│       ├── search-audit-impact-map.md # SAIM: 15 optimization areas with stats
│       └── audit-report-template.md # Report section structure with copy templates
├── algolia-audit-factcheck/         # Audit fact-checker (uses MCP servers)
│   └── SKILL.md                     # 7-dimension verification, 3 tiers
├── algolia-social/SKILL.md
└── algolia-ui-copy/SKILL.md
```

---

## Optional: Project Memory (CLAUDE.md)

The search audit skill works best with project memory. A template is included:

```bash
cp CLAUDE-template.md ~/.claude/CLAUDE.md
```

This gives Claude Code context about the audit methodology, version history, and completed audits. It's optional but recommended for best results.

---

## Uninstall

```bash
# Remove all Algolia skills:
rm -rf ~/.claude/skills/algolia-*

# Remove MCP servers:
claude mcp remove Chrome
claude mcp remove similarweb-mcp
claude mcp remove builtwith
claude mcp remove yahoo-finance
```

## Updating

```bash
cd algolia-claude-skills/
git pull
./install.sh
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| **v3.0** | **2026-02-25** | **Vertical-to-case-study mapping** (auto-selects relevant Algolia case studies based on prospect industry). SimilarWeb Technologies API cross-check for search vendor detection. TAG DETECTED vs ACTIVE verification workflow. web_source standardization (all traffic data uses consistent parameters). Book PDF as 7th deliverable (32+ pages, print-ready). Yahoo Finance MCP for public company financials. |
| v2.9 | 2026-02-24 | Book chapter completion gates (sub-phase verification), funnel SVG dimensions fix (3-tier design with 110px bottom). Context compaction mitigation. |
| v2.8 | 2026-02-23 | Print-ready PDF book deliverable, 11 editorial standards for book layout, Chrome headless PDF generation, header/footer on every page. |
| v2.7 | 2026-02-21 | Scratchpad mining philosophy, deck expanded to ~30-33 slides, presentation standards |
| v2.6 | 2026-02-21 | Investor intelligence, source citations, McKinsey Pyramid + Cold Open deck |
| v2.5 | 2026-02-21 | Strategic signal brief (6th deliverable), report restructured |
| v2.4 | 2026-02-21 | AE pre-call brief, financial profile, hiring signals, executives |
| v2.2 | 2026-02-20 | Competitor analysis, screenshot persistence, golden angle detection |

## Brand Source

All brand guidelines are derived from the official Algolia brand guide at [algolia.frontify.com/document/1](https://algolia.frontify.com/document/1).

## Questions?

- **Brand skills issues**: Contact the brand/marketing team
- **Search audit issues**: Contact Arijit Chowdhury
- **MCP server setup help**: See [Claude Code MCP docs](https://code.claude.com/docs/en/mcp) or ask in the #claude-code Slack channel
