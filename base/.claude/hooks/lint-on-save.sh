#!/bin/bash
# lint-on-save.sh
# Runs after every file edit/write by Claude.
# Exit code 2 = flag the issue. Exit code 0 = all clear.
#
# Keep this fast — it runs after every single edit.
# Heavy operations belong in pre-commit.sh, not here.
# See: https://code.claude.com/docs/en/hooks
# Hook command input is JSON on stdin; for Edit|Write file paths are in
# `.tool_input.file_path`. This script preserves legacy `$1` fallback.

set -euo pipefail

# Preferred path: parse hook JSON from stdin when available.
INPUT=""
if [ -p /dev/stdin ] || [ -f /dev/stdin ]; then
  INPUT="$(cat || true)"
fi

EDITED_FILE=""
if [ -n "$INPUT" ] && command -v jq >/dev/null 2>&1; then
  EDITED_FILE="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"
fi

# Backward-compatible fallback for direct/manual invocation.
if [ -z "$EDITED_FILE" ]; then
  EDITED_FILE="${1:-}"
fi

if [ -z "$EDITED_FILE" ]; then
  exit 0
fi

case "$EDITED_FILE" in
  *.ts|*.tsx|*.js|*.jsx)
    {{LINT_ON_SAVE_JS}}
    ;;
  *.py)
    {{LINT_ON_SAVE_PY}}
    ;;
  *.go)
    {{LINT_ON_SAVE_GO}}
    ;;
esac

exit 0
