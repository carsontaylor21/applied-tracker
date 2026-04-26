#!/bin/bash
# Deploy any pending changes in this repo to GitHub Pages.
# Usage: ./update.sh ["commit message"]
#
# Workflow assumption: Claude writes directly to ~/applied-tracker/ via Cowork's
# connected-folder feature. This script just stages everything in the repo,
# commits if there are real changes, and pushes. GitHub Pages rebuilds in ~30s.
#
# Override message: ./update.sh "added error log feature"

set -e

MSG="${1:-update tracker}"

git add -A

# Exit gracefully if nothing actually changed
if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

git commit -m "$MSG"
git push

echo "Pushed: $MSG"
echo "GitHub Pages will rebuild in ~30 seconds."
