# Algolia Skills for Claude Code

15 slash commands for the Algolia sales and marketing team — **13 brand content skills**, an **automated search audit** skill, and an **audit fact-check** skill. Every content skill references official Algolia brand guidelines. The search audit skill runs live browser-based tests on prospect websites and produces 6 deliverables per audit.

---

## Quick Start

```bash
git clone https://github.com/arijitchowdhury80/algolia-claude-skills.git
cd algolia-claude-skills/
chmod +x install.sh
./install.sh
```

This copies all skills to `~/.claude/skills/`, making them available in **every** Claude Code project — terminal, VS Code, Antigravity, or any IDE with Claude Code support.

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

### Search Audit Skill (1)

| Command | What it does |
|---------|-------------|
| `/algolia-search-audit <url>` | Run a full search experience audit on a prospect website |

The search audit (v2.7) automates a 5-phase process:

1. **Pre-Audit Research (14 steps)** — Company context + financials + executives, tech stack deep dive (BuiltWith + relationships), traffic deep dive (6 SimilarWeb calls), competitor identification, vertical test query generation, competitor search analysis (BuiltWith per competitor — golden angle if competitor uses Algolia), strategic angle mining + negative signals, hiring signal detection, financial context + ROI estimate, trigger event synthesis, investor intelligence (10-K/earnings call analysis), deep hiring analysis (careers page visit, role counts, JD analysis), ICP-to-priority mapping
2. **Browser Testing (20 steps)** — 12 core search tests + 8 Algolia value-prop tests (NLP, dynamic facets, popular searches, personalization, recommendations, merchandising rules, analytics visibility)
3. **Analysis** — Severity scoring across 10 challenge areas (6 core + 4 Algolia value-prop)
4. **Report** — Full markdown audit report with strategic intelligence, investor quotes, competitor landscape, and deep hiring analysis
5. **Deliverables (6 files, all brand-validated, all source-cited)**:
   - Full audit report (markdown)
   - Landing page (HTML with tabbed dual-view)
   - McKinsey Pyramid + Cold Open presentation deck (~30-33 slides)
   - Landing page content spec
   - AE Pre-Call Brief (internal, not for prospect)
   - Strategic Signal Brief (LLM-optimized 1-pager)

### Audit Fact-Check Skill (1)

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

## Using with Different IDEs

Claude Code skills live in `~/.claude/skills/` — this is a **user-level** directory, not project-level. Once installed, skills work everywhere:

| Environment | How to use |
|-------------|-----------|
| **Terminal (Claude Code CLI)** | `claude` in any directory, then type `/algolia-search-audit url` |
| **VS Code** | Install the [Claude Code extension](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code). Skills appear in the slash command menu. |
| **Antigravity** | Skills auto-discover from `~/.claude/skills/` — same as terminal. |
| **Cursor / Windsurf** | If using Claude Code as the AI backend, skills are available. If using native AI, skills won't work (they're Claude Code-specific). |

### Using Under a Different Account

If you're installing on a different machine or under a different user account:

1. Clone the repo: `git clone https://github.com/arijitchowdhury80/algolia-claude-skills.git`
2. Run `./install.sh`
3. Set up MCP servers (see Prerequisites below) — you'll need your own API keys
4. Optionally copy the `CLAUDE.md` template (see below) to `~/.claude/CLAUDE.md` for project memory

### Optional: CLAUDE.md Project Memory

The search audit skill works best with project memory in `~/.claude/CLAUDE.md`. A template is included:

```bash
cp CLAUDE-template.md ~/.claude/CLAUDE.md
```

This gives Claude Code context about the audit methodology, version history, and completed audits. It's optional but recommended for best results.

---

## Prerequisites

### For Brand Content Skills (no extra setup needed)
The 13 brand skills work out of the box with any Claude Code installation. No additional MCP servers or API keys required.

### For Search Audit + Fact-Check Skills (3 MCP servers required)

The search audit skill uses browser automation, traffic analytics, and technology detection. You'll need to set up three MCP (Model Context Protocol) servers:

#### 1. Chrome MCP (Browser Automation & Screenshots)

Chrome MCP lets Claude Code control a Chrome browser to run live search tests and capture screenshots.

**Install the Chrome extension:**
1. Go to the Chrome Web Store and search for **"Claude in Chrome"** (by anthropic)
   - Direct link: https://chromewebstore.google.com/detail/claude-in-chrome/
2. Click **"Add to Chrome"**
3. Pin the extension to your toolbar

**Configure Claude Code to use it:**
Add to your `~/.claude/settings.json` (under `"mcpServers"`):

```json
{
  "mcpServers": {
    "Claude in Chrome": {
      "type": "sse",
      "url": "http://127.0.0.1:21405/mcp/sse"
    }
  }
}
```

**Verify it works:**
1. Open Chrome with the extension active
2. In Claude Code, type: "Take a screenshot of this browser tab"
3. If it works, Chrome MCP is connected

**Documentation:** https://docs.anthropic.com/en/docs/claude-code/mcp

#### 2. SimilarWeb MCP (Traffic & Engagement Data)

SimilarWeb provides monthly visits, bounce rate, traffic sources, demographics, and technology stack data.

**Get your API key:**
1. Go to https://www.similarweb.com/
2. Sign up for an account or log into your existing one
3. Navigate to **Account Settings > API** (or ask your Algolia team lead — we may have a shared key)
4. Copy your API key

**Configure Claude Code:**
Add to your `~/.claude/settings.json` (under `"mcpServers"`):

```json
{
  "mcpServers": {
    "similarweb-mcp": {
      "type": "sse",
      "url": "https://mcp.similarweb.com/sse",
      "headers": {
        "Authorization": "Bearer YOUR_SIMILARWEB_API_KEY"
      }
    }
  }
}
```

Replace `YOUR_SIMILARWEB_API_KEY` with your actual key.

**Verify it works:**
In Claude Code, type: "Get traffic data for amazon.com"

**Documentation:** https://developers.similarweb.com/docs

#### 3. BuiltWith MCP (Technology Stack Detection)

BuiltWith detects what search provider, e-commerce platform, analytics tools, and other technologies a website uses.

**Get your API key:**
1. Go to https://builtwith.com/
2. Sign up for a free or paid account
3. Go to **API > Keys** at https://api.builtwith.com/
4. Copy your API key

**Configure Claude Code:**
Add to your `~/.claude/settings.json` (under `"mcpServers"`):

```json
{
  "mcpServers": {
    "builtwith": {
      "type": "sse",
      "url": "https://mcp.builtwith.com/sse",
      "headers": {
        "Authorization": "Bearer YOUR_BUILTWITH_API_KEY"
      }
    }
  }
}
```

Replace `YOUR_BUILTWITH_API_KEY` with your actual key.

**Verify it works:**
In Claude Code, type: "What technologies does shopify.com use?"

**Documentation:** https://api.builtwith.com/

### Complete `~/.claude/settings.json` Example

Here's what your full settings file should look like with all three MCP servers:

```json
{
  "mcpServers": {
    "Claude in Chrome": {
      "type": "sse",
      "url": "http://127.0.0.1:21405/mcp/sse"
    },
    "similarweb-mcp": {
      "type": "sse",
      "url": "https://mcp.similarweb.com/sse",
      "headers": {
        "Authorization": "Bearer YOUR_SIMILARWEB_API_KEY"
      }
    },
    "builtwith": {
      "type": "sse",
      "url": "https://mcp.builtwith.com/sse",
      "headers": {
        "Authorization": "Bearer YOUR_BUILTWITH_API_KEY"
      }
    }
  }
}
```

### Troubleshooting MCP Setup

| Problem | Solution |
|---------|----------|
| Chrome MCP won't connect | Make sure Chrome is open and the extension is active. Check that port 21405 is not blocked. |
| SimilarWeb returns "No data for requested country" | Try using worldwide data — the skill handles this automatically |
| BuiltWith returns "API Credits: 0" | Your free tier credits are exhausted. The skill falls back to SimilarWeb tech detection automatically. |
| Skills don't show up after install | Restart Claude Code. Skills are loaded at startup. |
| `/algolia-search-audit` not found | Check that `~/.claude/skills/algolia-search-audit/SKILL.md` exists |

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
├── algolia-search-audit/            # Search audit v2.7 (uses MCP servers)
│   ├── SKILL.md                     # 5 phases, 20 tests, 10 areas, 6 deliverables
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

## Audit Output Files

Each search audit produces 6 files in the working directory:

| # | File | Purpose |
|---|------|---------|
| 1 | `{company}-search-audit.md` | Full report with strategic intelligence, investor quotes, findings |
| 2 | `{company}-landing-page.html` | Dual-view landing page with strategic + competitor sections |
| 3 | `{company}-search-audit-deck.md` | ~30-33 slide McKinsey Pyramid + Cold Open presentation |
| 4 | `{company}-landing-page.md` | Content spec for the landing page |
| 5 | `{company}-ae-precall-brief.md` | Internal AE pre-call brief (not for prospect) |
| 6 | `{company}-strategic-signal-brief.md` | 1-page LLM-optimized strategic signal brief |

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

---

## Rendering Audit Output

The audit produces markdown and HTML files. Options for viewing:

| Method | Best for |
|--------|----------|
| **VS Code Preview** | Quick markdown preview (Cmd+Shift+V) |
| **Browser** | Open the `.html` landing page directly |
| **Marked.js** | Convert markdown to styled HTML: `npx marked -i report.md -o report.html` |
| **Marp** | Convert deck markdown to actual slides: `npx @marp-team/marp-cli deck.md --html` |
| **Pandoc** | Convert to PDF/DOCX: `pandoc report.md -o report.pdf` |

---

## Uninstall

```bash
rm -rf ~/.claude/skills/algolia-*
```

## Updating

To update to a newer version, `git pull` and re-run `install.sh` — it overwrites existing files.

## Version History

| Version | Date | Changes |
|---------|------|---------|
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
- **MCP server setup help**: See [Claude Code MCP docs](https://docs.anthropic.com/en/docs/claude-code/mcp) or ask in the #claude-code Slack channel
