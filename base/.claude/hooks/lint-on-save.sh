#!/bin/bash
# lint-on-save.sh
# Runs after every file edit/write by Claude.
# Exit code 2 = flag the issue. Exit code 0 = all clear.
#
# Keep this fast — it runs after every single edit.
# Heavy operations belong in pre-commit.sh, not here.

set -euo pipefail

# The file that was just edited is passed as $1 by Claude Code hooks
EDITED_FILE="${1:-}"

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
