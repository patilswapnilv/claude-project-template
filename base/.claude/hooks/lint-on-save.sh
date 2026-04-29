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

# ─── TypeScript/JavaScript ──────────────────────────────────────────────────
if [[ "$EDITED_FILE" =~ \.(ts|tsx|js|jsx)$ ]]; then
  # Uncomment for ESLint auto-fix on save
  # npx eslint "$EDITED_FILE" --fix --quiet 2>/dev/null || true
  echo "  [lint-on-save] Skipped (configure your linter above)"
fi

# ─── Python ────────────────────────────────────────────────────────────────
if [[ "$EDITED_FILE" =~ \.py$ ]]; then
  # Uncomment for ruff or black auto-format on save
  # ruff check "$EDITED_FILE" --fix --quiet 2>/dev/null || true
  # black "$EDITED_FILE" --quiet 2>/dev/null || true
  echo "  [lint-on-save] Skipped (configure your formatter above)"
fi

# ─── Go ────────────────────────────────────────────────────────────────────
if [[ "$EDITED_FILE" =~ \.go$ ]]; then
  # gofmt -w "$EDITED_FILE" 2>/dev/null || true
  echo "  [lint-on-save] Skipped (configure gofmt above)"
fi

exit 0
