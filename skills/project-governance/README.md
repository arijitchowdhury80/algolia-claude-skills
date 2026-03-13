# Project Governance for Claude Code

> **One command. Any project. Claude never forgets.**

A [Claude Code](https://claude.ai/code) skill that solves the two most painful problems with AI-assisted development: **context loss between sessions** and **knowledge drift over time**. Run it once on any project and Claude gains a persistent memory system, structured working habits, and the discipline to never deploy code it hasn't tested.

---

## The Problem

Claude Code is extremely capable — but it has no memory between sessions.

Every time you open a new conversation, Claude starts from zero. It re-reads the same files, re-discovers the same architecture, re-makes the same mistakes. In long sessions, context compaction silently drops earlier work. After a multi-day gap, the agent has no idea what changed.

**The result**: you spend 10–20 minutes of every session re-orienting the agent. You catch regressions it should have avoided. You watch it confidently deploy broken code because it forgot the test plan.

This skill fixes that.

---

## What It Does

Running `/project-governance` once on any project bootstraps a complete knowledge persistence system:

### 1. Three Bounded State Files (Total: ~80 lines at startup)

| File | Size | Purpose |
|------|------|---------|
| `STATUS.md` | ≤ 30 lines | What the project is, what's done, what's blocked. Full overwrite each session. |
| `CHECKPOINT.md` | ≤ 50 lines | What task is in progress, what step, what files are open. Overwritten every 3 steps. |
| `SESSION.md` | ~100 lines | Timestamped action log for the current session. Archived + reset each session. |

Files stay small by design — reading them costs almost no context budget.

### 2. Three-Tier Persistence (Knowledge is never lost)

```
Tier 1: Git post-commit hook (always-on, survives session gaps)
         → writes .knowledge-stale flag on every commit
         → even between sessions, Claude knows what changed

Tier 2: 13-minute cron heartbeat (in-session)
         → fires auto-persist before most context compactions
         → writes STATE.md, CHECKPOINT.md, appends SESSION.md

Tier 3: Project slash commands (deliberate control)
         → /start-task, /complete-task, /auto-persist, /update-knowledge
         → enforces test plan gates and quality checks before code
```

### 3. Five Project Commands

| Command | When to run | What it does |
|---------|-------------|--------------|
| `/get-up-to-speed` | Start of every session | Reads STATE.md + CHECKPOINT.md → gives you a 5-line project briefing. Registers the 13-min cron. |
| `/start-task` | Before any coding task | Checks that a test plan exists in `docs/test-plans/`. **Blocks with STOP if it doesn't.** Writes CHECKPOINT.md. |
| `/complete-task` | After finishing a task | Runs every test case from the test plan. **Blocks if any are failing.** Updates CHECKPOINT.md to COMPLETE. |
| `/auto-persist` | Every 13 minutes (automatic) | Overwrites STATUS.md, updates CHECKPOINT.md, appends to SESSION.md, commits if code changed. |
| `/update-knowledge` | End of session (optional) | Manual sync of `docs/get-up-to-speed.md` and MEMORY files. |

### 4. Agent Onboarding Doc

Creates `docs/get-up-to-speed.md` (~300 lines) — a complete project orientation document for any new agent picking up the project. Written once, updated only when code actually changes.

### 5. Canonical Project Directory Structure

Bootstraps a consistent, opinionated directory layout:

```
project-root/
├── .claude/commands/          ← 5 governance slash commands
├── frontend/src/              ← UI code (lib/ lives inside src/, not at root)
├── backend/src/               ← Server code (named "backend/", not "lib/" or "server/")
├── data/migrations/           ← Numbered schema changes
├── docs/
│   ├── get-up-to-speed.md     ← Agent onboarding (read on demand)
│   ├── system/prd/            ← PRD per feature (required before feature work)
│   ├── system/test-plans/     ← Test plan per task (required before coding)
│   ├── system/decisions/      ← ADRs: why we chose X over Y
│   ├── ux/                    ← UI/UX specs and wireframes
│   ├── api/                   ← API reference
│   └── archive/sessions/      ← Archived SESSION.md files
├── scripts/                   ← setup.sh, migrate.sh, reset-dev.sh
├── tests/
│   ├── unit/
│   ├── integration/           ← Real DB, real Redis, real APIs (no mocks)
│   ├── e2e/                   ← Playwright browser tests
│   └── fixtures/              ← Real captured data (NOT generated mocks)
├── scratchpad/                ← Agent working files (.gitignored)
├── .env.example               ← Every required env var documented
├── STATUS.md                  ← 30-line snapshot
├── CHECKPOINT.md              ← Active task state
└── SESSION.md                 ← Current session log
```

### 6. Development Mandates (Written into CLAUDE.md)

Every project gets a `CLAUDE.md` that enforces:
- **Try-catch on every async operation** — structured logging, not `console.log`
- **PRD before features** — no feature work without a written PRD in `docs/system/prd/`
- **Test plan before code** — `/start-task` blocks if no test plan exists
- **Real data only** — no mocks, no stubs; `tests/fixtures/` holds real captured payloads
- **No deployments without explicit approval** — agent will never push to production unless you say so
- **Checkpoint every 3 steps** — protects against context compaction data loss

---

## Why You Need This

### The Context Compaction Problem

Claude Code compacts context when it fills up. Earlier messages are summarized and the originals are dropped. The agent continues — but it may have lost the specific error message from three steps ago, the exact file path you were working on, or the reason you decided against a particular approach.

**Without this skill**: You don't know what was dropped. The agent acts confident about stale information.

**With this skill**: Every 3 task steps, state is written to disk. Every 13 minutes, a cron fires and syncs. After compaction, Claude reads `STATUS.md + CHECKPOINT.md` (80 lines total) and is fully re-oriented in seconds.

### The Session Gap Problem

You close your laptop on Friday. You open a new Claude Code session on Monday. The agent has no memory of what you were doing, what was broken, or what you just shipped.

**Without this skill**: You re-explain the project, re-describe the task, hope the agent doesn't repeat the same mistakes.

**With this skill**: Run `/get-up-to-speed`. Claude reads STATUS.md, sees the git log, checks the `.knowledge-stale` flag from the post-commit hook, and gives you a 5-line briefing in under 30 seconds.

### The "Just Ship It" Problem

AI agents are optimistic. They'll write the code, declare it working, and push to production — especially if you don't explicitly stop them. They'll skip tests because they feel confident. They'll deploy to staging when you meant local-only.

**Without this skill**: You catch regressions after the fact.

**With this skill**: `/start-task` blocks if no test plan exists. `/complete-task` blocks if any test is failing. The CLAUDE.md mandate explicitly states: the agent will NOT commit or deploy without your instruction.

---

## Benefits at a Glance

| Benefit | How |
|---------|-----|
| Zero re-orientation overhead | `/get-up-to-speed` briefing in <30 seconds |
| No context compaction data loss | Every-3-steps checkpoint + 13-min cron |
| No knowledge drift between sessions | Git hook marks knowledge stale on every commit |
| No accidental deployments | CLAUDE.md mandate: no push without explicit approval |
| No code without tests | `/start-task` blocks — hard gate, not a soft reminder |
| No test without real data | `tests/fixtures/` mandate: real captured data only |
| Clean repo structure | Canonical directory layout bootstrapped once |
| New agent onboarding in 30 seconds | `docs/get-up-to-speed.md` is always current |

---

## Requirements

- [Claude Code](https://claude.ai/code) (any version)
- Git (initialized repo)
- macOS, Linux, or WSL

No other dependencies. No API keys. No external services.

---

## Installation

### Option A — GitHub (Recommended)

```bash
# 1. Clone the repo
git clone https://github.com/arijitchowdhury80/algolia-claude-skills.git
cd algolia-claude-skills/

# 2. Run the governance installer
chmod +x install-governance.sh
./install-governance.sh

# 3. Open any project in Claude Code
cd your-project/
claude

# 4. Bootstrap governance on that project
/project-governance
```

### Option B — Direct File Install (No git required)

Copy the single skill file to the right place:

```bash
mkdir -p ~/.claude/skills/project-governance
curl -s https://raw.githubusercontent.com/arijitchowdhury80/algolia-claude-skills/main/skills/project-governance/SKILL.md \
  -o ~/.claude/skills/project-governance/SKILL.md
```

Then restart Claude Code and type `/project-governance` in any project.

### Option C — Zip File

1. Download the zip from GitHub (Code → Download ZIP)
2. Extract it
3. Run: `chmod +x install-governance.sh && ./install-governance.sh`

### Verify Installation

```bash
# In any terminal with Claude Code:
claude
# Type: /
# You should see "project-governance" in the autocomplete list
```

---

## Quick Start

```bash
# Step 1: Install the skill (once, globally)
chmod +x install-governance.sh && ./install-governance.sh

# Step 2: Open your project
cd my-project/
claude

# Step 3: Bootstrap governance (once per project)
/project-governance
# → Creates all directories, files, git hook, CLAUDE.md, 5 commands

# Step 4: At the start of every future session:
/get-up-to-speed
# → 5-line briefing, cron registered, ready to work
```

After that, the system runs itself. The 13-minute cron fires automatically. The git hook marks knowledge stale on every commit. You just work.

---

## Retrofitting an Existing Project

The skill works on existing projects too — it won't overwrite your code.

```bash
cd my-existing-project/
claude
/project-governance
```

It creates the governance files (`STATUS.md`, `CHECKPOINT.md`, `SESSION.md`) and the `.claude/commands/` directory alongside your existing code. It writes a `CLAUDE.md` if one doesn't exist, or appends the governance mandates section if one already does. It creates `docs/` subdirectories only if they don't exist.

---

## How It Works

### At Session Start

```
You: /get-up-to-speed
Claude reads: STATUS.md (≤30 lines) + CHECKPOINT.md (≤50 lines)
Claude checks: git log --oneline -10 + docs/.knowledge-stale
Claude says: "Here's where we are: [5-line briefing]"
Claude registers: CronCreate cron="*/13 * * * *"
Time: ~10 seconds
```

### During a Task

```
You: /start-task "add user authentication"
Claude checks: docs/test-plans/user-authentication.md — exists? → proceed
Claude writes: CHECKPOINT.md (goal, steps, current step, open files)
Claude begins: Step 1

[Every 3 steps]
Claude updates: CHECKPOINT.md (step N of M)
Claude appends: SESSION.md (1-line summary)

[Every 13 minutes, automatic]
Cron fires: /auto-persist
→ Overwrites STATUS.md
→ Updates CHECKPOINT.md
→ Appends SESSION.md
→ If code changed: updates docs/get-up-to-speed.md
→ Commits: "chore: auto-persist [timestamp]"
```

### Finishing a Task

```
You: /complete-task
Claude runs: every test case in docs/test-plans/user-authentication.md
If any failing: BLOCKS — "X test(s) failing. Cannot mark complete."
If all passing: updates CHECKPOINT.md → COMPLETE, appends SESSION.md
Claude confirms: "Task complete. Ready for next task. NOT committing or deploying until you say so."
```

### Session End

```
SESSION.md is archived → docs/archive/sessions/YYYY-MM-DD-HHmm-session.md
SESSION.md is reset to empty template
PROGRESS.md gets a one-line append (permanent record)
```

---

## File Reference

| File | Lives at | Purpose | Never grows beyond |
|------|----------|---------|-------------------|
| `STATUS.md` | project root | Project snapshot | 30 lines |
| `CHECKPOINT.md` | project root | Active task state | 50 lines |
| `SESSION.md` | project root | Current session log | ~100 lines (archived + reset) |
| `docs/get-up-to-speed.md` | `docs/` | Agent onboarding doc | ~300 lines |
| `CLAUDE.md` | project root | Agent constitution | ~150 lines |
| `docs/archive/sessions/` | `docs/archive/` | Historical session logs | Unbounded (never auto-read) |
| `.git/hooks/post-commit` | `.git/hooks/` | Marks knowledge stale on commit | 15 lines |
| `.claude/commands/` | `.claude/` | 5 governance slash commands | — |

---

## FAQ

**Does this work on an existing project?**
Yes. It creates governance files alongside your existing code without touching it.

**Does it work on projects with no code yet?**
Yes — it's designed for this. Bootstrap on a blank repo and it sets up the directory structure you'll build into.

**Do I need to re-run `/project-governance` each session?**
No — run it once. Each session, run `/get-up-to-speed` instead.

**What if Claude Code's context fills up and compacts?**
After compaction, tell Claude: "Read STATUS.md and CHECKPOINT.md before continuing." Those two files restore full state in ~80 lines.

**Can I use this alongside other Claude Code skills?**
Yes. It's fully independent. It adds project-scoped commands under `.claude/commands/` which don't conflict with global `~/.claude/skills/` skills.

**Does this affect my project's actual code?**
No. It only creates/modifies governance files (`STATUS.md`, `CHECKPOINT.md`, `SESSION.md`, `CLAUDE.md`, `.claude/commands/`, `.git/hooks/post-commit`, `docs/`). Your code is untouched.

**What if I don't want the git hook?**
Delete `.git/hooks/post-commit`. The rest of the system still works — you just won't get automatic knowledge-stale flags on commits.

---

## Uninstall

```bash
# Remove the skill globally:
rm -rf ~/.claude/skills/project-governance

# Remove from a specific project (doesn't touch your code):
rm -f STATUS.md CHECKPOINT.md SESSION.md PROGRESS.md
rm -f CLAUDE.md   # only if it was created by this skill
rm -rf .claude/commands/
rm -f .git/hooks/post-commit
rm -rf docs/archive/ docs/system/prd/ docs/system/test-plans/ docs/system/decisions/
rm -rf scratchpad/
```

---

## Updating

```bash
cd algolia-claude-skills/
git pull
./install-governance.sh
```

The skill file is updated in `~/.claude/skills/project-governance/SKILL.md`. Already-bootstrapped projects are unaffected — the commands in `.claude/commands/` and the git hook were written to disk at bootstrap time and aren't auto-updated. Re-run `/project-governance --update` in any project to pull the latest command templates.

---

*Part of the [Algolia Claude Code Skills](https://github.com/arijitchowdhury80/algolia-claude-skills) collection.*
