#!/bin/bash
# Project Governance Skill — Standalone Installer
# Installs the /project-governance skill to ~/.claude/skills/
# Works independently of the Algolia brand skills.
#
# Usage:
#   chmod +x install-governance.sh && ./install-governance.sh
#
# After install, open any project in Claude Code and run /project-governance

set -e

SKILL_NAME="project-governance"
SKILLS_DIR="$HOME/.claude/skills"
SKILL_DIR="$SKILLS_DIR/$SKILL_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/skills/$SKILL_NAME/SKILL.md"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║   Project Governance Skill — Installer           ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# Verify source exists
if [ ! -f "$SOURCE" ]; then
  echo "ERROR: Cannot find skills/$SKILL_NAME/SKILL.md"
  echo "       Make sure you run this from the algolia-claude-skills/ directory."
  exit 1
fi

# Create skills dir if needed
if [ ! -d "$SKILLS_DIR" ]; then
  echo "Creating $SKILLS_DIR ..."
  mkdir -p "$SKILLS_DIR"
fi

# Install or update
if [ -d "$SKILL_DIR" ]; then
  echo "Updating existing installation at $SKILL_DIR ..."
else
  echo "Installing to $SKILL_DIR ..."
  mkdir -p "$SKILL_DIR"
fi

cp "$SOURCE" "$SKILL_DIR/SKILL.md"

echo ""
echo "────────────────────────────────────────────────────"
echo "  ✓ Installed: /project-governance"
echo "  Location:    $SKILL_DIR/SKILL.md"
echo "────────────────────────────────────────────────────"
echo ""
echo "Next steps:"
echo ""
echo "  1. Open any project in Claude Code:"
echo "     cd your-project/"
echo "     claude"
echo ""
echo "  2. Bootstrap governance (run once per project):"
echo "     /project-governance"
echo ""
echo "  3. At the start of every future session:"
echo "     /get-up-to-speed"
echo ""
echo "That's it. The system runs itself after that."
echo ""
echo "Read skills/$SKILL_NAME/README.md for full documentation."
echo ""
