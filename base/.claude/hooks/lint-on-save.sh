#!/usr/bin/env bash
# lint-on-save.sh -- runs after every Edit/Write by Claude.
# Exit 0 always; this is best-effort formatting.
set -uo pipefail
EDITED_FILE="${1:-}"
[ -z "$EDITED_FILE" ] && exit 0

case "$EDITED_FILE" in
  *.ts|*.tsx|*.js|*.jsx)  {{LINT_ON_SAVE_JS}}  ;;
  *.py)                    {{LINT_ON_SAVE_PY}}  ;;
  *.go)                    {{LINT_ON_SAVE_GO}}  ;;
esac
exit 0
