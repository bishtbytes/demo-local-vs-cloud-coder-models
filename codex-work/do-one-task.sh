#!/usr/bin/env bash
# Runs ONE unchecked task from codex-work/todo.md using Codex (Ollama-backed)
# Marks task as completed only on success.

set -euo pipefail

TODO_FILE="codex-work/todo.md"
STATE_FILE="codex-work/.last-task"

if [[ ! -f "$TODO_FILE" ]]; then
  echo "Todo file not found: $TODO_FILE"
  exit 1
fi

LINE_INFO=$(grep -n "^- \[ \] " "$TODO_FILE" | head -n1 || true)

if [[ -z "$LINE_INFO" ]]; then
  exit 1
fi

LINE_NO="${LINE_INFO%%:*}"
LINE_TEXT="${LINE_INFO#*:}"
TASK="${LINE_TEXT#- [ ] }"

echo "----------------------------------------"
echo "Running Codex task (line $LINE_NO)"
echo "Task: $TASK"
echo "----------------------------------------"

PROMPT="Do ONLY the following task.
Do not refactor unrelated code.
Do not invent new requirements.
Task: $TASK"

codex exec --oss --local-provider ollama "$PROMPT"

# Mark task complete
sed -i '' "${LINE_NO}s/^- \[ \]/- [x] /" "$TODO_FILE"

# Save state for worklog (plain text, NOT shell code)
mkdir -p codex-work
{
  echo "line_no=$LINE_NO"
  echo "task=$TASK"
  echo "timestamp=$(date '+%Y-%m-%d %H:%M:%S')"
} > codex-work/.last-task

echo "Task completed and marked as done."
