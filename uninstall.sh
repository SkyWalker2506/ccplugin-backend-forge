#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="backend-forge"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"

if [ -d "$SKILL_DIR" ]; then
  rm -rf "$SKILL_DIR"
  echo "Removed $SKILL_DIR"
else
  echo "$SKILL_NAME not installed, nothing to remove."
fi

echo "Done."
