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
  # Check for common secret patterns in staged files
  SECRET_PATTERNS="(sk-[a-zA-Z0-9]{32,}|api[_-]?key\s*=\s*['\"][^'\"]+['\"]|password\s*=\s*['\"][^'\"]+['\"]|secret\s*=\s*['\"][^'\"]+['\"]|token\s*=\s*['\"][^'\"]+['\"])"
  
  if git diff --cached | grep -iP "$SECRET_PATTERNS" 2>/dev/null; then
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
