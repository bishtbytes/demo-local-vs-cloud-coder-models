#!/usr/bin/env bash
# Runs all unchecked tasks sequentially using do-one-task.sh
# Updates worklog after each successful task
# Stops when no unchecked tasks remain

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

ONE_TASK="$SCRIPT_DIR/do-one-task.sh"
WORKLOG="$SCRIPT_DIR/do-worklog-update.sh"

while true; do
  if "$ONE_TASK"; then
    "$WORKLOG"
  else
    echo "----------------------------------------"
    echo "All tasks completed."
    echo "----------------------------------------"
    exit 0
  fi
done
