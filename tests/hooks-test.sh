#!/usr/bin/env bash
# Smoke test for pre-commit secret scanning.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP=$(mktemp -d 2>/dev/null || mktemp -d -t hooks-test)
trap 'rm -rf "$TMP"' EXIT

git -C "$TMP" init -q
git -C "$TMP" -c user.name=hooks-test -c user.email=hooks-test@example.com commit --allow-empty -m "init" -q
git -C "$TMP" checkout -q -b hooks-test
cp "$REPO_ROOT/base/.claude/hooks/pre-commit.sh" "$TMP/.git/pre-commit-test.sh"
chmod +x "$TMP/.git/pre-commit-test.sh"

# Negative case (no secret)
echo "hello world" > "$TMP/safe.txt"
git -C "$TMP" add safe.txt
if (cd "$TMP" && ./.git/pre-commit-test.sh); then
  echo "PASS: clean diff allowed"
else
  echo "FAIL: clean diff blocked"; exit 1
fi

# Positive case (fake key)
echo 'const k = "sk-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"' > "$TMP/leak.js"
git -C "$TMP" add leak.js
if (cd "$TMP" && ./.git/pre-commit-test.sh); then
  echo "FAIL: fake secret not blocked"; exit 1
else
  echo "PASS: fake secret blocked"
fi

echo "OK"
