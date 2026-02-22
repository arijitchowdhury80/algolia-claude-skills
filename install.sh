#!/bin/bash
# Algolia Claude Code Skills — Unified Installer v2.7
# Installs 15 Algolia skills (13 brand + 1 search audit + 1 factcheck) to ~/.claude/skills/

set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skills"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║   Algolia Skills for Claude Code — Install v2.7  ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Verify source exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "ERROR: Cannot find skills/ directory at $SOURCE_DIR"
  echo "Make sure you run this script from the algolia-claude-skills/ directory."
  exit 1
fi

# Create ~/.claude/skills/ if it doesn't exist
if [ ! -d "$SKILLS_DIR" ]; then
  echo "Creating $SKILLS_DIR ..."
  mkdir -p "$SKILLS_DIR"
fi

# Copy all skill directories
echo "Installing skills to $SKILLS_DIR ..."
echo ""

SKILL_COUNT=0
BRAND_COUNT=0
AUDIT_COUNT=0
FACTCHECK_COUNT=0
REF_COUNT=0

for skill_dir in "$SOURCE_DIR"/algolia-*; do
  if [ -d "$skill_dir" ]; then
    skill_name=$(basename "$skill_dir")
    echo "  -> $skill_name"
    cp -R "$skill_dir" "$SKILLS_DIR/"

    if [ "$skill_name" = "algolia-shared-reference" ]; then
      REF_COUNT=1
    elif [ "$skill_name" = "algolia-search-audit" ]; then
      AUDIT_COUNT=1
    elif [ "$skill_name" = "algolia-audit-factcheck" ]; then
      FACTCHECK_COUNT=1
    else
      BRAND_COUNT=$((BRAND_COUNT + 1))
    fi
    SKILL_COUNT=$((SKILL_COUNT + 1))
  fi
done

echo ""
echo "────────────────────────────────────────────────────"
echo "  Installed: $BRAND_COUNT brand skills"
echo "             $AUDIT_COUNT search audit skill (v2.7)"
echo "             $FACTCHECK_COUNT audit fact-check skill"
echo "             $REF_COUNT shared brand reference directory"
echo "────────────────────────────────────────────────────"
echo ""
echo "Brand Content Skills:"
echo "  /algolia-brand-check   — Check content for brand compliance"
echo "  /algolia-algolialize   — Transform any content to Algolia brand"
echo "  /algolia-blog          — Generate a branded blog post"
echo "  /algolia-boilerplate   — Get approved company descriptions"
echo "  /algolia-brief         — Generate a campaign brief"
echo "  /algolia-case-study    — Create a customer case study"
echo "  /algolia-deck          — Create a branded presentation"
echo "  /algolia-email         — Write branded email copy"
echo "  /algolia-landing       — Generate landing page copy"
echo "  /algolia-one-pager     — Create a product one-pager"
echo "  /algolia-partner       — Create co-marketing content"
echo "  /algolia-social        — Write social media posts"
echo "  /algolia-ui-copy       — Write UI microcopy"
echo ""
echo "Search Audit Skills:"
echo "  /algolia-search-audit       — Run a full search audit on a prospect website"
echo "  /algolia-audit-factcheck    — Validate audit deliverables (run after audit)"
echo ""
echo "────────────────────────────────────────────────────"
echo ""

# Check for MCP servers needed by search audit
SETTINGS_FILE="$HOME/.claude/settings.json"
MCP_MISSING=()

if [ -f "$SETTINGS_FILE" ]; then
  # Check for Chrome MCP
  if ! grep -q "127.0.0.1:21405" "$SETTINGS_FILE" 2>/dev/null; then
    MCP_MISSING+=("Chrome MCP")
  fi
  # Check for SimilarWeb
  if ! grep -q "similarweb" "$SETTINGS_FILE" 2>/dev/null; then
    MCP_MISSING+=("SimilarWeb MCP")
  fi
  # Check for BuiltWith
  if ! grep -q "builtwith" "$SETTINGS_FILE" 2>/dev/null; then
    MCP_MISSING+=("BuiltWith MCP")
  fi
else
  MCP_MISSING=("Chrome MCP" "SimilarWeb MCP" "BuiltWith MCP")
fi

if [ ${#MCP_MISSING[@]} -gt 0 ]; then
  echo "⚠  SEARCH AUDIT SETUP REQUIRED"
  echo ""
  echo "  The /algolia-search-audit skill needs these MCP servers:"
  for mcp in "${MCP_MISSING[@]}"; do
    echo "    ✗ $mcp — not detected"
  done
  echo ""
  echo "  See README.md for setup instructions (API keys & configuration)."
  echo "  The 13 brand skills work immediately — no extra setup needed."
  echo ""
else
  echo "✓ All MCP servers detected. Search audit is ready to use."
  echo ""
fi

# Offer to copy CLAUDE.md template
if [ -f "$SCRIPT_DIR/CLAUDE-template.md" ]; then
  if [ ! -f "$HOME/.claude/CLAUDE.md" ]; then
    echo "TIP: A CLAUDE.md project memory template is available."
    echo "     Run: cp CLAUDE-template.md ~/.claude/CLAUDE.md"
    echo "     This gives Claude Code context about the audit methodology."
    echo ""
  fi
fi

echo "Open any project in Claude Code and type /algolia- to see all commands."
echo ""
echo "Done!"
