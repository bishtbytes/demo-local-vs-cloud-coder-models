#!/usr/bin/env bash
# Appends last executed task to codex-work/worklog.md
# Format:
# ## YYYY-MM-DD
# - HH:MM — short task summary (todo #N)

set -euo pipefail

STATE_FILE="codex-work/.last-task"
WORKLOG="codex-work/worklog.md"

if [[ ! -f "$STATE_FILE" ]]; then
  echo "No task state found. Nothing to log."
  exit 0
fi

LINE_NO=$(sed -n 's/^line_no=//p' "$STATE_FILE")
TASK=$(sed -n 's/^task=//p' "$STATE_FILE")
TIMESTAMP=$(sed -n 's/^timestamp=//p' "$STATE_FILE")

# Clean task summary (remove checkbox if present)
CLEAN_TASK=$(echo "$TASK" | sed -E 's/^[[:space:]]*-\s*\[[ xX]\]\s*//')

DATE_PART=$(echo "$TIMESTAMP" | cut -d' ' -f1)
TIME_PART=$(echo "$TIMESTAMP" | cut -d' ' -f2 | cut -d':' -f1,2)

mkdir -p codex-work

# Initialize worklog if missing
if [[ ! -f "$WORKLOG" ]]; then
  echo "# Codex Worklog" > "$WORKLOG"
  echo >> "$WORKLOG"
fi

# Add date header if not already present
if ! grep -q "^## $DATE_PART$" "$WORKLOG"; then
  echo >> "$WORKLOG"
  echo "## $DATE_PART" >> "$WORKLOG"
fi

# Append task entry
echo "- $TIME_PART — $CLEAN_TASK (todo #$LINE_NO)" >> "$WORKLOG"


# Cleanup state
rm -f "$STATE_FILE"

echo "Worklog updated."
