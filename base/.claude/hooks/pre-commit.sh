#!/bin/bash
# pre-commit.sh
# Runs before every commit Claude makes.
# Exit code 2 = BLOCK the commit. Exit code 0 = ALLOW it.
#
# Customize the commands below for your stack.
# Comment out sections that don't apply to your project.

set -euo pipefail

echo "🔍 Running pre-commit checks..."

# ─── TypeScript type check ─────────────────────────────────────────────────
# Uncomment if project uses TypeScript
# echo "  → Type check..."
# npx tsc --noEmit || {
#   echo "❌ Type check failed. Fix errors before committing."
#   exit 2
# }

# ─── Linting ───────────────────────────────────────────────────────────────
# Uncomment and adjust for your linter
# STAGED_FILES=$(git diff --cached --name-only | grep -E "\.(ts|tsx|js|jsx)$" || true)
# if [ -n "$STAGED_FILES" ]; then
#   echo "  → Lint staged files..."
#   npx eslint $STAGED_FILES --quiet || {
#     echo "❌ Lint failed. Run 'npm run lint' to see all issues."
#     exit 2
#   }
# fi

# ─── Tests ─────────────────────────────────────────────────────────────────
# Uncomment to run tests before every commit (can be slow — consider only on push)
# echo "  → Running tests..."
# npm test -- --silent || {
#   echo "❌ Tests failed. Fix failing tests before committing."
#   exit 2
# }

# ─── Secret detection ──────────────────────────────────────────────────────
echo "  → Scanning for secrets..."
STAGED_FILES=$(git diff --cached --name-only || true)
if [ -n "$STAGED_FILES" ]; then
  # Portable extended-regex pattern (BSD + GNU grep).
  # Patterns: OpenAI-style sk- keys, and key=value pairs for api_key/password/secret/token.
  PATTERN='(sk-[A-Za-z0-9-]{8,}|(api[-_]?key|password|secret|token)[[:space:]]*=[[:space:]]*["'"'"']?[^"'"'"'[:space:]]+["'"'"']?)'
  if git diff --cached -U0 | grep -E '^\+[^+]' | grep -iE "$PATTERN" >/dev/null; then
    echo "❌ Possible secret detected in staged changes. Review before committing."
    echo "   If this is a false positive, use: git commit --no-verify"
    exit 2
  fi
fi

# ─── Branch protection ─────────────────────────────────────────────────────
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
PROTECTED_BRANCHES="main master production"

for branch in $PROTECTED_BRANCHES; do
  if [ "$CURRENT_BRANCH" = "$branch" ]; then
    echo "❌ Direct commits to '$branch' are blocked."
    echo "   Create a feature branch and open a PR."
    exit 2
  fi
done

echo "✅ All pre-commit checks passed."
exit 0
