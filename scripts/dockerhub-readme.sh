#!/usr/bin/env bash

# Docker Hub renders every README image as a block, so badges on one line still stack. Converting the
# badge line to a single-row table keeps them side by side there, while GitHub keeps the plain badge line.

set -o errexit

README="${1:-README.md}"

awk '
  /^\[!\[/ {
    n = split($0, badges, /\) \[!\[/)
    row = "|"
    divider = "|"
    for (i = 1; i <= n; i++) {
      badge = badges[i]
      if (i > 1) badge = "[![" badge
      if (i < n) badge = badge ")"
      row = row " " badge " |"
      divider = divider ":-:|"
    }
    print row
    print divider
    next
  }
  { print }
' "$README"
