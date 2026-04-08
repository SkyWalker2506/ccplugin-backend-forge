#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="backend-forge"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing $SKILL_NAME..."

mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"

if [ -f "$SCRIPT_DIR/alternatives.md" ]; then
  cp "$SCRIPT_DIR/alternatives.md" "$SKILL_DIR/alternatives.md"
fi

if [ -f "$SCRIPT_DIR/auth-providers.md" ]; then
  cp "$SCRIPT_DIR/auth-providers.md" "$SKILL_DIR/auth-providers.md"
fi

if [ -f "$SCRIPT_DIR/state-template.json" ]; then
  cp "$SCRIPT_DIR/state-template.json" "$SKILL_DIR/state-template.json"
fi

# Secure secrets directory permissions
SECRETS_DIR="$HOME/.claude/secrets"
if [ -d "$SECRETS_DIR" ]; then
  chmod 700 "$SECRETS_DIR"
  [ -f "$SECRETS_DIR/secrets.env" ] && chmod 600 "$SECRETS_DIR/secrets.env"
  for f in "$SECRETS_DIR/projects/"*.env 2>/dev/null; do
    [ -f "$f" ] && chmod 600 "$f"
  done
fi

echo "Installed to $SKILL_DIR"
echo "Done. backend-forge is now available in Claude Code sessions."
