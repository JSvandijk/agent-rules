#!/bin/bash
# Sync agent-rules into active Claude Code artifacts.
# Run after updating QUALITY-GATE.md or LEARNINGS.md.
# Works on Mac, Linux, and Windows (Git Bash).

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
GREEN='\033[0;32m'
NC='\033[0m'

echo ""
echo "=== agent-rules sync ==="
echo ""

mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/templates/.claude/commands"

# 1. Generate ~/.claude/CLAUDE.md from repo source
cat > "$CLAUDE_DIR/CLAUDE.md" << 'HEADER'
IMPORTANT: ALWAYS begin every conversation by saying "CLAUDE.md loaded".
NEVER skip this. The user needs to see it to know rules are active.

HEADER

# Append quality gate principles as rules
echo "## Rules" >> "$CLAUDE_DIR/CLAUDE.md"
echo "" >> "$CLAUDE_DIR/CLAUDE.md"
sed -n '/^## Principles$/,/^## /{ /^## Principles$/d; /^## [^P]/d; p; }' \
  "$SCRIPT_DIR/QUALITY-GATE.md" >> "$CLAUDE_DIR/CLAUDE.md"

# Append promoted learnings as patterns
echo "## Promoted patterns" >> "$CLAUDE_DIR/CLAUDE.md"
echo "" >> "$CLAUDE_DIR/CLAUDE.md"
sed -n '/^## Patterns$/,/^## /{ /^## Patterns$/d; /^## [^P]/d; p; }' \
  "$SCRIPT_DIR/LEARNINGS.md" >> "$CLAUDE_DIR/CLAUDE.md"

echo -e "${GREEN}Generated ~/.claude/CLAUDE.md from repo source${NC}"

# 2. /rules command
cat > "$CLAUDE_DIR/commands/rules.md" << 'RULESMD'
ALWAYS read and follow ~/.claude/CLAUDE.md right now.
If there is a CLAUDE.md or AGENTS.md in the project root, read and follow those too.
Confirm by saying: "Rules loaded: [list files you read]"
RULESMD
echo -e "${GREEN}Synced ~/.claude/commands/rules.md${NC}"

# 3. Hooks (post-compaction reminder)
SETTINGS="$CLAUDE_DIR/settings.json"
if [ -f "$SETTINGS" ] && grep -q '"hooks"' "$SETTINGS" 2>/dev/null; then
  echo "~/.claude/settings.json already has hooks — skipping"
else
  if [ -f "$SETTINGS" ]; then
    TMP="$SETTINGS.tmp"
    sed '$ d' "$SETTINGS" > "$TMP"
    cat >> "$TMP" << 'HOOKJSON'
,
  "hooks": {
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'IMPORTANT: Re-read CLAUDE.md from the project root NOW and follow all rules. ALWAYS say CLAUDE.md loaded. NEVER skip verification.'"
          }
        ]
      }
    ]
  }
}
HOOKJSON
    mv "$TMP" "$SETTINGS"
  else
    cat > "$SETTINGS" << 'SETTINGSJSON'
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'IMPORTANT: Re-read CLAUDE.md from the project root NOW and follow all rules. ALWAYS say CLAUDE.md loaded. NEVER skip verification.'"
          }
        ]
      }
    ]
  }
}
SETTINGSJSON
  fi
  echo -e "${GREEN}Added hooks to ~/.claude/settings.json${NC}"
fi

# 4. Sync templates
cp "$SCRIPT_DIR/templates/AGENTS.md" "$CLAUDE_DIR/templates/AGENTS.md"
cp "$SCRIPT_DIR/templates/CLAUDE.md" "$CLAUDE_DIR/templates/CLAUDE.md"
cp "$SCRIPT_DIR/templates/.claude/commands/rules.md" "$CLAUDE_DIR/templates/.claude/commands/rules.md"
cp "$SCRIPT_DIR/templates/.claude/settings.json" "$CLAUDE_DIR/templates/.claude/settings.json"
echo -e "${GREEN}Synced templates${NC}"

echo ""
echo "=== Sync complete ==="
echo ""
echo "What was synced:"
echo "  ~/.claude/CLAUDE.md        ← generated from QUALITY-GATE.md + LEARNINGS.md"
echo "  ~/.claude/commands/rules.md"
echo "  ~/.claude/settings.json    ← hooks"
echo "  ~/.claude/templates/       ← project templates"
echo ""
echo "To verify: open Claude Code → Claude says 'CLAUDE.md loaded'"
echo ""
