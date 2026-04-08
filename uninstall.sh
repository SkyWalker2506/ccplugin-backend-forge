#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="backend-forge"
SKILL_DIR="$HOME/.claude/skills/$SKILL_NAME"

if [ ! -d "$SKILL_DIR" ]; then
  echo "$SKILL_NAME not installed, nothing to remove."
  exit 0
fi

if [ "${1:-}" != "--force" ]; then
  echo "Will remove: $SKILL_DIR"
  printf "Continue? [y/N] "
  read -r confirm
  if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Cancelled."
    exit 0
  fi
fi

rm -rf "$SKILL_DIR"
echo "Removed $SKILL_DIR"
echo "Done."
