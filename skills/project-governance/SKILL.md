# /project-governance — Project Governance Bootstrap

**Invocation**: `/project-governance`
**Purpose**: Bootstrap complete project governance for any new or existing project.
**Run once** at project start, or to retrofit an existing project.

---

## Core Design Philosophy

**Files must stay small enough to read without burning context budget.**

Three tiers of information, each with strict size limits:

| File | Size Limit | Read when | Written when |
|------|-----------|-----------|--------------|
| `STATUS.md` | 30 lines max | Every session start | Every auto-persist (full overwrite) |
| `CHECKPOINT.md` | 50 lines max | Session start + after compaction | After every 3 task steps |
| `SESSION.md` | ~100 lines | Session start if task in progress | After every meaningful action, reset each session |
| `docs/get-up-to-speed.md` | ~300 lines | First session or after 3+ day gap | Only when code actually changes |
| `docs/archive/` | Unbounded | Never automatically | Session end, residue cleanup |

**The 90% context problem**: We can't hook into context percentage mechanically. Protection comes from:
1. **13-min cron** — fires before most compactions in active sessions
2. **Every-3-steps rule** — agent checkpoints based on work done, not time
3. **Tiny reads at startup** — STATUS.md + CHECKPOINT.md = ~80 lines total, not hundreds

---

## Canonical Project Directory Structure

Every project bootstrapped with this skill gets this exact layout:

```
project-root/
│
├── .claude/
│   ├── commands/                  ← project slash commands (5 governance commands)
│   └── settings.local.json
│
├── .github/
│   └── workflows/                 ← CI/CD pipelines (create if using GitHub Actions)
│
├── frontend/                      ← all UI code
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/              ← API clients
│   │   ├── lib/                   ← shared utils, constants (lib lives INSIDE src/, not at root)
│   │   └── types/
│   └── package.json
│
├── backend/                       ← all server code (use "backend/", not "lib/" or "server/")
│   ├── src/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── middleware/
│   │   ├── workers/
│   │   └── lib/                   ← shared backend utils (inside src/, not at root)
│   └── package.json
│
├── data/                          ← all data layer
│   ├── migrations/                ← numbered SQL/schema changes (001-, 002-, ...)
│   ├── seeds/                     ← initial and test data
│   └── schemas/                   ← type definitions, JSON schemas
│
├── docs/
│   ├── get-up-to-speed.md         ← agent onboarding (governance — on-demand, not startup)
│   ├── DEVELOPMENT_MANDATES.md    ← extended coding standards with examples
│   ├── system/                    ← project planning and architecture docs
│   │   ├── prd/                   ← PRD per feature (required before any feature work)
│   │   ├── test-plans/            ← test plan per task (required before any code)
│   │   └── decisions/             ← ADRs: why we chose X over Y (001-why-redis.md)
│   ├── ux/                        ← UI/UX specs, wireframes, user flows, component specs
│   ├── api/                       ← API reference: endpoints, request/response shapes, auth
│   └── archive/
│       ├── sessions/              ← archived SESSION.md files (never auto-read)
│       └── status/                ← archived status/complete docs
│
├── scripts/                       ← dev utility scripts
│   ├── setup.sh                   ← one-command local dev setup
│   ├── migrate.sh                 ← run all pending migrations
│   └── reset-dev.sh               ← nuke and rebuild local dev state
│
├── tests/                         ← all tests (or co-locate inside frontend/ and backend/)
│   ├── unit/                      ← pure function tests, no I/O
│   ├── integration/               ← tests that hit real DB, real Redis, real APIs
│   ├── e2e/                       ← browser/full-stack end-to-end tests (Playwright)
│   └── fixtures/                  ← real test data (NOT mocks — real domains, real payloads)
│
├── scratchpad/                    ← agent working files (in .gitignore)
│
├── .env.example                   ← every required env var documented, no values
├── .gitignore                     ← .env, scratchpad/, node_modules/, dist/, .DS_Store
├── docker-compose.yml             ← local services (Redis, Postgres, etc.) if applicable
├── README.md                      ← human-facing project overview
├── CLAUDE.md                      ← agent constitution (governance)
├── STATUS.md                      ← 30-line snapshot (governance — overwritten, never appended)
├── CHECKPOINT.md                  ← active task state (governance — overwritten per step)
└── SESSION.md                     ← current session log (governance — archived + reset per session)
```

### Directory Naming Decisions (canonical)
- **`backend/`** not `lib/`, `server/`, or `api/` — most readable for full server code
- **`lib/`** lives INSIDE `frontend/src/` or `backend/src/` for shared utils — never at project root
- **`api/`** only if the project uses serverless/edge functions without a full server
- **`skills/`** does NOT exist at project root — project automation → `.claude/commands/`, reusable skills → `~/.claude/skills/`
- **`docs/system/decisions/`** — Architecture Decision Records. Every non-obvious technical choice gets a numbered ADR. Prevents agents from re-litigating settled decisions.

---

## Step 1: Gather Project Information

Ask or infer from existing files:
1. Project name, one-line description, primary audience
2. Tech stack (frontend, backend, database, key libraries)
3. Live URLs (frontend, database project ID, repository)
4. Current status (new or existing, % complete)
5. Key directories

---

## Step 2: Create `CLAUDE.md`

Project constitution. Stable. In git. Every agent reads this first.

```markdown
# [PROJECT_NAME] — Development Guidelines

## What This Project Is
[One paragraph: what it does, who it's for]

## Tech Stack
| Layer | Technology | Location |
|-------|-----------|---------|
| [fill in] | | |

## Key Architecture Decisions
- [decision 1]
- [decision 2]

## Shared Libraries — Always Import, Never Redefine
- [e.g., Colors: import from @/lib/constants — never define hex codes inline]

---

## Development Mandates (Non-Negotiable)

### 1. PRD Before Any Feature
Write PRD in `docs/prd/[feature].md` using `docs/PRD_TEMPLATE.md` before any work starts.

### 2. Test Plan Before Any Code
Write test plan in `docs/test-plans/[task].md` using `docs/TEST_PLAN_TEMPLATE.md`.
- No code without an approved test plan. No exceptions.
- All tests use REAL data — no mocks, no stubs.
- All tests run LOCALLY — never test against production.
- Task is NOT complete until all tests pass 100%.
- Never move to next task while any test is failing.

### 3. Error Handling — Every Function
Every function, route handler, service method must have:
  try { ... } catch (error) {
    logger.error('[MODULE] operation failed', { error, context: { ...params } });
    throw error;
  }
Never swallow errors silently. Never use bare catch(e) {}.

### 4. Structured Logging — Every Step
Log at entry AND exit of every: API route, service method, background job,
external API call (log params + response status + latency + cache hit/miss),
database query (log table + operation + row count + duration).

### 5. Context Protection — Checkpoint After Every 3 Steps
Before any task >5 min: write CHECKPOINT.md with goal, steps, current step, files.
After every 3 steps: update CHECKPOINT.md, append 1 line to SESSION.md.
After context compaction: read STATUS.md + CHECKPOINT.md + SESSION.md before continuing.
NEVER continue from compaction summary alone — always verify against disk first.

### 6. Local Development Only
NEVER deploy to any environment without explicit user instruction: "deploy to [env]".
NEVER push to remote git without explicit: "commit and push".
NEVER run migrations on prod/staging without explicit approval.

### 7. TypeScript Strictness (if applicable)
No `any` types. No `!` without explanation comment. Explicit return types on exports.

---

## Development Workflow
1. New feature → Write PRD
2. Start coding → /start-task (enforces test plan gate, writes CHECKPOINT.md)
3. Write code → Update CHECKPOINT.md every 3 steps, append to SESSION.md
4. Finish → /complete-task (verifies 100% tests passing)
5. Commit → Only on explicit user "commit"
6. Deploy → Only on explicit user "deploy to [env]"

## Key Documentation
- `STATUS.md` — Current state (30 lines, read at session start)
- `CHECKPOINT.md` — Active task state (50 lines, read after compaction)
- `SESSION.md` — This session's log (reset each session)
- `docs/get-up-to-speed.md` — Full architecture ref (read on first session or after gap)
```

---

## Step 3: Create `STATUS.md` (30 lines, full overwrite pattern)

```markdown
# Project Status — [PROJECT_NAME]
**Updated**: [date] | **Overall**: [X]% complete

## Active Task
None

## Component Status
| Component | Status | % |
|-----------|--------|---|
| [component] | ⏳ Pending | 0% |

## Top 3 Priorities
1. [priority]
2. [priority]
3. [priority]

## Active Blockers
None

## Recent Commits
[fill from git log]

## Key Paths
- Backend: `[path]` | Frontend: `[path]` | DB: `[path]`
```

---

## Step 4: Create `CHECKPOINT.md` (50 lines, overwrite pattern)

```markdown
# CHECKPOINT — [PROJECT_NAME]
**Status**: IDLE (no task in progress)
**Last updated**: [date]

## Active Task
None

## Goal
None

## Steps
None

## Current Step
None

## Files Being Modified
None
```

---

## Step 5: Create `SESSION.md`

```markdown
# Session Log — [DATE]
**Purpose**: Current session only. Archived + reset at session end.

## Session Goal
[fill in at session start]

## Log
[HH:MM] INIT Project governance bootstrapped
```

---

## Step 6: Create `docs/get-up-to-speed.md`

Full architecture doc. ~300 lines. Not read at every session start — only on demand.

Sections to include:
1. What the project is + audience
2. Full architecture diagram
3. All routes/modules with status table
4. Complete vs. pending table (honest)
5. Key files quick reference
6. How to start working (setup commands)
7. Agent prompt template (copy-paste ready)

Bottom line: `*Last updated: [DATE]*`

---

## Step 7: Create `docs/PRD_TEMPLATE.md`

```markdown
# PRD: [Feature Name]
**Status**: Draft | Approved | Building | Complete
**Date**: [date] | **Test plan**: `docs/test-plans/[task].md`

## Problem Statement
[What user pain does this solve?]

## Objective
[What will be true after this ships?]

## Scope
### In scope: [bullets]
### Out of scope: [bullets — be explicit]

## Functional Requirements
| # | Requirement | Priority |
|---|-------------|----------|
| 1 | | P0 |

## Technical Design
- Data model changes: [tables/fields]
- API changes: [endpoints]
- Frontend changes: [pages/components]

## Success Criteria
[Measurable outcomes]

## Open Questions
- [ ] [question that blocks build]
```

---

## Step 8: Create `docs/TEST_PLAN_TEMPLATE.md`

```markdown
# Test Plan: [Task Name]
**Status**: Draft | Approved | Complete
**PRD**: `docs/prd/[feature].md`

> ⚠️ Approved before any code is written.
> Real data only. No mocks. Local only. 100% pass required to close task.

## Test Environment
```bash
[exact setup commands — e.g., redis-server, npm run dev, real domain to test]
```

## Test Cases
| # | Type | Input | Expected | Pass Criteria |
|---|------|-------|----------|---------------|
| 1 | Unit | [real input] | [exact] | [how to verify] |
| 2 | Integration | | | |
| 3 | E2E | | | |
| 4 | Error case | [bad input] | [graceful error] | |

## Test Data
[Specific real values: domains, IDs, API payloads]

## Definition of Done
- [ ] All test cases pass
- [ ] Error cases handled and logged
- [ ] No TypeScript errors (npx tsc --noEmit)
- [ ] try-catch on every new function
- [ ] Logging at entry + exit of every new function
- [ ] SESSION.md updated
- [ ] User says "tests pass, proceed"
```

---

## Step 9: Create `.claude/commands/get-up-to-speed.md`

```markdown
# Get Up To Speed

## Step 1: Read fast files (always — ~80 lines total)
Read STATUS.md (30 lines) and CHECKPOINT.md (50 lines).
If CHECKPOINT shows IN PROGRESS, also read SESSION.md.

## Step 2: Full context only if needed
Read docs/get-up-to-speed.md only if:
- First session on project, OR last session >3 days ago, OR STATUS.md is insufficient

## Step 3: Check recent changes
git log --oneline -10
cat docs/.knowledge-stale 2>/dev/null

## Step 4: State briefing (5 lines)
- Platform status, active task, top 2 priorities, blockers, whether more context needed

## Step 5: Register cron
CronCreate: cron="*/13 * * * *", recurring=true
Prompt: "Run /auto-persist for [PROJECT]: overwrite STATUS.md (30 lines), update CHECKPOINT.md if task in progress, append to SESSION.md, make targeted edits to get-up-to-speed.md if code changed, archive root residues, commit."
Confirm: "Cron registered (13-min). Re-registers on /get-up-to-speed each session."
```

---

## Step 10: Create `.claude/commands/auto-persist.md`

```markdown
# Auto-Persist

## Always (every 13-min run)
1. Overwrite STATUS.md — 30 lines max, full overwrite, current state only
2. Update CHECKPOINT.md — if task in progress, update current step (50 lines max)
3. Append to SESSION.md — 1 line: [HH:MM] [ACTION] [10-word summary]

## Only if git shows code changes
4. Targeted edits to docs/get-up-to-speed.md (only changed sections)
5. Archive root residues: SESSION_*.md, AGENT*_COMPLETE.md, GIT_COMMIT_*.md > 2 days old
6. git add STATUS.md CHECKPOINT.md SESSION.md docs/ && git commit -m "chore: auto-persist [HH:MM]"

## End of session (when user indicates)
7. cp SESSION.md docs/archive/sessions/$(date '+%Y-%m-%d-%H%M')-session.md
8. Reset SESSION.md to empty template

## Hard size limits (enforce strictly)
STATUS.md: 30 lines | CHECKPOINT.md: 50 lines | SESSION.md: ~100 lines active
If any file exceeds limit: cut, not archive — keep only what's needed to resume work
```

---

## Step 11: Create `.claude/commands/start-task.md`

```markdown
# Start Task

## Gate 1: Test plan required
Ask task name. Check docs/test-plans/[task-name].md exists.
If NOT: "BLOCKED — create test plan first. Template: docs/TEST_PLAN_TEMPLATE.md"
STOP if no test plan.

## Gate 2: Write CHECKPOINT.md (overwrite)
Status: IN PROGRESS | Task: [name] | Goal: [from test plan]
Steps: [all steps numbered] | Current Step: 1 | Files: [list]

## Gate 3: Append to SESSION.md
[HH:MM] STARTED [task-name] | goal | test plan: docs/test-plans/[task-name].md

## Gate 4: Confirm
"Task started. Checkpoint written. Test plan at [path]. Beginning Step 1."
```

---

## Step 12: Create `.claude/commands/complete-task.md`

```markdown
# Complete Task

## Gate 1: Run all tests (from test plan)
Go through every test case. State PASS or FAIL for each.
If ANY fail: "BLOCKED — [test] failing. Fix and re-run /complete-task." STOP.

## Gate 2: Code quality
[ ] try-catch on every new function
[ ] entry+exit logging on every new function
[ ] npx tsc --noEmit — zero errors
[ ] no console.log, no dead code

## Gate 3: Update CHECKPOINT.md
Status: COMPLETE | Tests: N/N passing | What was built: [summary]

## Gate 4: Append to SESSION.md
[HH:MM] COMPLETED [task-name] | N/N tests passing | files: [list]

## Gate 5: Prompt
"Complete. Tests passing. Say 'commit' to commit, 'next task: [name]' to continue.
I will NOT commit or deploy without explicit instruction."
```

---

## Step 13: Create Git Post-Commit Hook

`.git/hooks/post-commit` (chmod +x):
```bash
#!/bin/bash
REPO_ROOT="$(git rev-parse --show-toplevel)"
COMMIT_HASH=$(git rev-parse --short HEAD)
COMMIT_MSG=$(git log -1 --pretty=format:"%s")
COMMIT_TIME=$(date "+%Y-%m-%d %H:%M:%S")
FILES=$(git diff --name-only HEAD~1 HEAD 2>/dev/null | head -10 | tr '\n' ', ')

# Write stale flag (read by auto-persist to know if get-up-to-speed.md needs update)
printf "Stale since: %s\nCommit: %s — %s\nFiles: %s\n" \
  "$COMMIT_TIME" "$COMMIT_HASH" "$COMMIT_MSG" "$FILES" \
  > "$REPO_ROOT/docs/.knowledge-stale"

# Append to commit log (capped at 50 lines)
echo "[$COMMIT_TIME] $COMMIT_HASH — $COMMIT_MSG" >> "$REPO_ROOT/docs/.commit-log"
tail -50 "$REPO_ROOT/docs/.commit-log" > "$REPO_ROOT/docs/.commit-log.tmp"
mv "$REPO_ROOT/docs/.commit-log.tmp" "$REPO_ROOT/docs/.commit-log"

echo "📝 [knowledge-tracker] Stale flag written. /auto-persist will sync in ≤13 min."
exit 0
```

---

## Step 14: Create Full Directory Structure and Root Files

### Create all directories
```bash
mkdir -p .claude/commands
mkdir -p .github/workflows
mkdir -p frontend/src/{components,pages,services,lib,types}
mkdir -p backend/src/{routes,services,middleware,workers,lib}
mkdir -p data/{migrations,seeds,schemas}
mkdir -p docs/{system/{prd,test-plans,decisions},ux,api,archive/{sessions,status}}
mkdir -p tests/{unit,integration,e2e,fixtures}
mkdir -p scripts
mkdir -p scratchpad
```

### Create `.gitignore`
```
# Environment
.env
.env.local
.env.*.local

# Dependencies
node_modules/
.pnp
.pnp.js

# Build outputs
dist/
build/
.next/
out/

# Agent working files (ephemeral, not for version control)
scratchpad/

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log
npm-debug.log*

# Cache
.cache/
.turbo/
dump.rdb

# IDE
.vscode/settings.json
.idea/

# Test coverage
coverage/
.nyc_output/
```

### Create `.env.example`
```bash
# ============================================================
# [PROJECT_NAME] — Environment Variables Template
# Copy to .env and fill in values. NEVER commit .env.
# ============================================================

# Server
PORT=3001
NODE_ENV=development

# Database
SUPABASE_URL=https://[project-id].supabase.co
SUPABASE_KEY=
DATABASE_URL=postgresql://...

# Cache
REDIS_URL=redis://localhost:6379

# External APIs (add as needed)
# SIMILARWEB_API_KEY=
# BUILTWITH_API_KEY=
# APIFY_API_KEY=
# ANTHROPIC_API_KEY=
# OPENAI_API_KEY=
```

### Create `scripts/setup.sh`
```bash
#!/bin/bash
# One-command local dev environment setup
echo "Setting up [PROJECT_NAME] dev environment..."

# Check prerequisites
command -v node >/dev/null 2>&1 || { echo "Node.js required"; exit 1; }
command -v redis-cli >/dev/null 2>&1 || echo "WARNING: Redis not found — run: brew install redis"

# Install dependencies
[ -d frontend ] && (cd frontend && npm install)
[ -d backend ] && (cd backend && npm install)

# Copy env template if .env doesn't exist
[ ! -f backend/.env ] && [ -f .env.example ] && cp .env.example backend/.env && echo "Created backend/.env — add your API keys"

echo "Setup complete. Next:"
echo "  1. Add API keys to backend/.env"
echo "  2. redis-server"
echo "  3. cd backend && npm run dev"
```
Run: `chmod +x scripts/setup.sh`

### Create `docs/system/decisions/000-template.md`
```markdown
# ADR-000: [Decision Title]

**Date**: [date]
**Status**: Accepted | Superseded by ADR-XXX

## Context
[What situation forced this decision?]

## Decision
[What we chose to do]

## Alternatives Considered
- [Option A] — rejected because [reason]
- [Option B] — rejected because [reason]

## Consequences
- [What becomes easier]
- [What becomes harder]
- [What we accept as a trade-off]
```

### Create `docs/ux/README.md`
```markdown
# UX Documentation

All UI/UX specifications, wireframes, user flows, and component specs.

## Contents
- `user-flows/` — step-by-step user journeys
- `component-specs/` — behavior specs for complex components
- `wireframes/` — links to Figma or embedded images
- `design-decisions/` — why the UI works the way it does

## For Agents
Read the relevant spec in this directory before building any UI component.
The spec defines the intended experience — code to match it, not to invent it.
```

### Create `docs/api/README.md`
```markdown
# API Documentation

Endpoint specifications, request/response shapes, auth requirements.

## Format per endpoint
**`METHOD /path`**
- Auth: [required/none]
- Request: [body/params shape]
- Response: [shape + status codes]
- Notes: [rate limits, caching, side effects]

## For Agents
Check here before calling any endpoint from the frontend.
Check here before changing any endpoint in the backend — downstream consumers may break.
```

### Create `tests/fixtures/README.md`
```markdown
# Test Fixtures

Real data for use in tests. No mocks. No generated data.

## Contents
- Real domain names to test with (e.g. costco.com, nike.com)
- Real API response samples (captured from actual calls)
- Real database seed states

## Rules
- Never use faker/mock libraries — use real values
- If you add a fixture, document where it came from
- Fixtures are for reproducibility, not convenience
```

### Touch placeholder files
```bash
touch docs/.commit-log docs/.knowledge-updated
touch scratchpad/.gitkeep
touch tests/unit/.gitkeep tests/integration/.gitkeep tests/e2e/.gitkeep
```

---

## Step 15: Register Session Cron

CronCreate:
- cron: `*/13 * * * *`
- recurring: true
- prompt: "Run /auto-persist for [PROJECT_NAME]: overwrite STATUS.md (30 lines max), update CHECKPOINT.md if task in progress, append to SESSION.md, make targeted edits to docs/get-up-to-speed.md only if git shows code changes, archive root residue files older than 2 days, commit."

---

## Step 16: Output Summary

```
✅ Project Governance Bootstrapped — [PROJECT_NAME]

Files Created:
  CLAUDE.md              ← Constitution (read by every agent)
  STATUS.md              ← 30-line snapshot (overwritten every 13 min)
  CHECKPOINT.md          ← Active task state (overwritten per step)
  SESSION.md             ← Session log (archived + reset each session)
  docs/get-up-to-speed.md  ← Full ref (read on-demand, not every session)
  docs/PRD_TEMPLATE.md   ← Feature planning
  docs/TEST_PLAN_TEMPLATE.md ← Required before any code
  .claude/commands/      ← 5 commands
  .git/hooks/post-commit ← Stale flag on every commit

Cron: /auto-persist every 13 min (session-only, re-registers on /get-up-to-speed)

Context Protection Model:
  Startup: read STATUS.md + CHECKPOINT.md (~80 lines, fast)
  During work: checkpoint every 3 steps → STATE IS ALWAYS ON DISK
  Compaction recovery: read STATUS.md + CHECKPOINT.md + SESSION.md → resume exactly
  Files never grow large: STATUS/CHECKPOINT overwritten, SESSION archived each session
```

---

## Mandate Rationale

| Mandate | Why |
|---------|-----|
| PRD first | Forces clarity on what/why before how |
| Test plan before code | Defines "done" upfront. No test plan = no definition of done |
| Real data only | Mocks hide real bugs. Only actual API responses reveal actual failures |
| Local only | Bad local test = 2 min. Bad prod deploy = hours + real user impact |
| try-catch everywhere | Silent failures are the hardest bugs to find |
| Structured logging | Can't debug what you can't observe |
| STATUS.md 30-line limit | Files that fill context at startup defeat the purpose |
| SESSION.md per-session reset | Prevents the "append-only file that grows to 1000 lines" trap |
| Checkpoint every 3 steps | Makes compaction recovery deterministic, not lucky |
| Explicit deployment approval | Every prod action is a human decision, not an agent default |
