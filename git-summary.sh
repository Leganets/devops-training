#!/bin/bash

set -euo pipefail

BRANCH=$(git branch --show-current)
NUM_COM=$(git rev-list --count HEAD)
LAST_COM=$(git log -1 --oneline)
SH_STAT=$(git status --short)

echo "=== Git Summary ==="
echo ""
echo "This branch is $BRANCH"
echo "Number of commits: $NUM_COM"
echo "Last commit: $LAST_COM"
echo ""

if [ -z "$SH_STAT" ]; then
	echo "Working directory clean [OK]"
else
	echo "Modified files:"
	echo "$SH_STAT"
fi
