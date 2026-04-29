#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"

if command -v node >/dev/null 2>&1; then
  # Node CLI is the canonical implementation.
  exec node "$ROOT/cli/index.js" "$@"
fi

echo "Node.js not found — falling back to bash implementation."
exec "$HERE/init.bash-fallback.sh" "$@"
