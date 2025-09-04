#!/usr/bin/env bash
set -euo pipefail

README="README.md"
OUT="index.md"

if [[ ! -f "$README" ]]; then
  echo "ERROR: $README not found." >&2
  exit 1
fi

# Start fresh
: > "$OUT"

# Write front matter for our clean layout
{
  echo "---"
  echo "layout: clean"
  echo "title: HomeLab"
  echo "---"
  echo
} >> "$OUT"

# If line 1 is a top-level H1 ('# ...'), drop it; else keep everything.
# This avoids double headings while preserving content if you don't start with '#'.
awk 'NR==1 && /^#[[:space:]]/ {next} {print}' "$README" >> "$OUT"

echo "Built $OUT from $README"
