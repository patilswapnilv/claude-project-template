#!/bin/bash
# init.bash-fallback.sh — Claude Project Template Bootstrap
# Usage: ./scripts/init.bash-fallback.sh [--target <path>] [--yes] [--force] [target-project-path]
#
# Copies base template + selected profile to your project.
# Fills in CLAUDE.md placeholders interactively.

set -euo pipefail

TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET=""
YES=0
FORCE=0

print_usage() {
  cat <<'EOF'
Usage: ./scripts/init.bash-fallback.sh [--target <path>] [--yes] [--force] [target-project-path]

Options:
  --target <path>   Install to this directory (default: current directory)
  --yes, -y         Non-interactive, accept all defaults
  --force           Overwrite existing CLAUDE.md and .claude/ without prompting
  --help, -h        Show this help
EOF
}

# ─── Colors ────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

print_header() { echo -e "\n${BOLD}${BLUE}$1${NC}"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
prompt() { echo -ne "${BOLD}$1${NC} "; }

# ─── Parse args ─────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      if [[ -z "${2:-}" ]]; then
        print_error "--target requires a path"
        exit 1
      fi
      TARGET="$2"
      shift 2
      ;;
    --yes|-y)
      YES=1
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --help|-h)
      print_usage
      exit 0
      ;;
    --*)
      print_error "Unknown option: $1"
      print_usage
      exit 1
      ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$1"
      fi
      shift
      ;;
  esac
done

# ─── Get target directory ──────────────────────────────────────────────────
if [ -z "$TARGET" ]; then
  if [ "$YES" -eq 1 ]; then
    TARGET="$(pwd)"
  else
    prompt "Target project directory (absolute path or . for current):"
    read -r TARGET
  fi
fi

if [ "$TARGET" = "." ]; then
  TARGET="$(pwd)"
fi

if [ ! -d "$TARGET" ]; then
  print_error "Directory does not exist: $TARGET"
  exit 1
fi

print_header "Claude Project Template — Bootstrap"
echo "Template source: $TEMPLATE_DIR"
echo "Target project:  $TARGET"
echo ""

# ─── Guard against overwriting ─────────────────────────────────────────────
if [ -f "$TARGET/CLAUDE.md" ] || [ -d "$TARGET/.claude" ]; then
  if [ "$FORCE" -eq 1 ]; then
    print_warning "Existing CLAUDE.md or .claude/ — overwriting (--force)."
  elif [ "$YES" -eq 1 ]; then
    print_error "Existing CLAUDE.md or .claude/ found. Re-run with --force to overwrite, or remove them first."
    exit 1
  else
    prompt "CLAUDE.md or .claude/ already exists in target. Overwrite? (y/N):"
    read -r OVERWRITE
    OVERWRITE="${OVERWRITE,,}"
    if [[ "$OVERWRITE" != "y" && "$OVERWRITE" != "yes" ]]; then
      echo "Aborted."
      exit 0
    fi
  fi
fi

# ─── Gather project info ───────────────────────────────────────────────────
print_header "Project details"

prompt "Project name:"
read -r PROJECT_NAME

prompt "One-line description:"
read -r PROJECT_DESC

prompt "Project status (active/maintenance/greenfield) [active]:"
read -r PROJECT_STATUS
PROJECT_STATUS="${PROJECT_STATUS:-active}"

# ─── Stack selection ───────────────────────────────────────────────────────
print_header "Stack profile"
echo "Available profiles:"
echo "  1) nextjs        — Next.js 13+ with App Router"
echo "  2) go-service    — Go service or CLI"
echo "  3) python-data   — Python data pipeline or script"
echo "  4) react-native  — React Native mobile app"
echo "  5) fullstack-saas — Fullstack SaaS (multi-profile)"
echo "  6) none          — Base only, no stack profile"

prompt "Select profile [1-6]:"
read -r PROFILE_CHOICE

case "$PROFILE_CHOICE" in
  1) PROFILE="nextjs" ;;
  2) PROFILE="go-service" ;;
  3) PROFILE="python-data" ;;
  4) PROFILE="react-native" ;;
  5) PROFILE="fullstack-saas" ;;
  6) PROFILE="" ;;
  *) print_warning "Invalid choice, using base only."; PROFILE="" ;;
esac

# ─── Stack commands ────────────────────────────────────────────────────────
print_header "Commands (press Enter to skip)"

set_hardcoded_defaults() {
  case "$1" in
    nextjs)
      DEV_CMD_DEFAULT="npm run dev"
      BUILD_CMD_DEFAULT="npm run build"
      TEST_CMD_DEFAULT="npm test"
      LINT_CMD_DEFAULT="npm run lint"
      TYPECHECK_CMD_DEFAULT="npx tsc --noEmit"
      LINT_ON_SAVE_CMD_DEFAULT='npx eslint "$EDITED_FILE" --fix --quiet'
      ;;
    go-service)
      DEV_CMD_DEFAULT="go run ./cmd/..."
      BUILD_CMD_DEFAULT="go build ./..."
      TEST_CMD_DEFAULT="go test -race ./..."
      LINT_CMD_DEFAULT="golangci-lint run"
      TYPECHECK_CMD_DEFAULT="go vet ./..."
      LINT_ON_SAVE_CMD_DEFAULT='gofmt -w "$EDITED_FILE"'
      ;;
    python-data)
      DEV_CMD_DEFAULT="python src/main.py"
      BUILD_CMD_DEFAULT="pip install -e ."
      TEST_CMD_DEFAULT="pytest"
      LINT_CMD_DEFAULT="ruff check ."
      TYPECHECK_CMD_DEFAULT="mypy ."
      LINT_ON_SAVE_CMD_DEFAULT='ruff check "$EDITED_FILE" --fix --quiet'
      ;;
    react-native)
      DEV_CMD_DEFAULT="npx expo start"
      BUILD_CMD_DEFAULT="npx expo build"
      TEST_CMD_DEFAULT="npm test"
      LINT_CMD_DEFAULT="npm run lint"
      TYPECHECK_CMD_DEFAULT="npx tsc --noEmit"
      LINT_ON_SAVE_CMD_DEFAULT='npx eslint "$EDITED_FILE" --fix --quiet'
      ;;
    fullstack-saas)
      DEV_CMD_DEFAULT="npm run dev"
      BUILD_CMD_DEFAULT="npm run build"
      TEST_CMD_DEFAULT="npm test"
      LINT_CMD_DEFAULT="npm run lint"
      TYPECHECK_CMD_DEFAULT="npx tsc --noEmit"
      LINT_ON_SAVE_CMD_DEFAULT='npx eslint "$EDITED_FILE" --fix --quiet'
      ;;
    *)
      DEV_CMD_DEFAULT=""
      BUILD_CMD_DEFAULT=""
      TEST_CMD_DEFAULT=""
      LINT_CMD_DEFAULT=""
      TYPECHECK_CMD_DEFAULT=""
      LINT_ON_SAVE_CMD_DEFAULT=""
      ;;
  esac
}

PROFILE_KEY="${PROFILE:-none}"
PROFILES_JSON="$TEMPLATE_DIR/config/profiles.json"
LOADED_FROM_JSON=0

if command -v node >/dev/null 2>&1 && [ -f "$PROFILES_JSON" ]; then
  PROFILE_DATA="$(
    node -e "const fs=require('fs');const [file,key]=process.argv.slice(1);const data=JSON.parse(fs.readFileSync(file,'utf8'));const p=data[key]||data.none;if(!p){process.exit(1);}process.stdout.write([p.devCmd,p.buildCmd,p.testCmd,p.lintCmd,p.typecheckCmd,p.lintOnSaveCmd||''].join('\u001f'));" \
      "$PROFILES_JSON" \
      "$PROFILE_KEY" \
      2>/dev/null || true
  )"
  if [ -n "$PROFILE_DATA" ]; then
    IFS=$'\x1f' read -r DEV_CMD_DEFAULT BUILD_CMD_DEFAULT TEST_CMD_DEFAULT LINT_CMD_DEFAULT TYPECHECK_CMD_DEFAULT LINT_ON_SAVE_CMD_DEFAULT <<< "$PROFILE_DATA"
    LOADED_FROM_JSON=1
  fi
fi

if [ "$LOADED_FROM_JSON" -ne 1 ]; then
  set_hardcoded_defaults "$PROFILE_KEY"
fi

LINT_ON_SAVE_JS=':'
LINT_ON_SAVE_PY=':'
LINT_ON_SAVE_GO=':'
if [ -n "$LINT_ON_SAVE_CMD_DEFAULT" ]; then
  LINT_ON_SAVE_CMD_BEST_EFFORT="$LINT_ON_SAVE_CMD_DEFAULT 2>/dev/null || true"
  case "$LINT_ON_SAVE_CMD_DEFAULT" in
    *eslint*)
      LINT_ON_SAVE_JS="$LINT_ON_SAVE_CMD_BEST_EFFORT"
      ;;
    ruff*|*' black '*)
      LINT_ON_SAVE_PY="$LINT_ON_SAVE_CMD_BEST_EFFORT"
      ;;
    gofmt*)
      LINT_ON_SAVE_GO="$LINT_ON_SAVE_CMD_BEST_EFFORT"
      ;;
  esac
fi

prompt "Dev command [$DEV_CMD_DEFAULT]:"
read -r DEV_CMD
DEV_CMD="${DEV_CMD:-$DEV_CMD_DEFAULT}"

prompt "Build command [$BUILD_CMD_DEFAULT]:"
read -r BUILD_CMD
BUILD_CMD="${BUILD_CMD:-$BUILD_CMD_DEFAULT}"

prompt "Test command [$TEST_CMD_DEFAULT]:"
read -r TEST_CMD
TEST_CMD="${TEST_CMD:-$TEST_CMD_DEFAULT}"

prompt "Lint command [$LINT_CMD_DEFAULT]:"
read -r LINT_CMD
LINT_CMD="${LINT_CMD:-$LINT_CMD_DEFAULT}"

prompt "Typecheck command [$TYPECHECK_CMD_DEFAULT]:"
read -r TYPECHECK_CMD
TYPECHECK_CMD="${TYPECHECK_CMD:-$TYPECHECK_CMD_DEFAULT}"

# ─── Copy base ────────────────────────────────────────────────────────────
print_header "Installing files"

cp -r "$TEMPLATE_DIR/base/.claude" "$TARGET/"
print_success "Copied base .claude/"

cp "$TEMPLATE_DIR/base/CLAUDE.md" "$TARGET/CLAUDE.md"
print_success "Copied CLAUDE.md"

cp "$TEMPLATE_DIR/base/CLAUDE.local.md.example" "$TARGET/CLAUDE.local.md"
print_success "Created CLAUDE.local.md (your personal overrides — gitignored)"

# ─── Merge profile ────────────────────────────────────────────────────────
if [ -n "$PROFILE" ] && [ -d "$TEMPLATE_DIR/profiles/$PROFILE/.claude" ]; then
  # Merge rules
  if [ -d "$TEMPLATE_DIR/profiles/$PROFILE/.claude/rules" ]; then
    cp -r "$TEMPLATE_DIR/profiles/$PROFILE/.claude/rules/." "$TARGET/.claude/rules/"
    print_success "Merged $PROFILE rules"
  fi
  # Merge skills
  if [ -d "$TEMPLATE_DIR/profiles/$PROFILE/.claude/skills" ]; then
    cp -r "$TEMPLATE_DIR/profiles/$PROFILE/.claude/skills/." "$TARGET/.claude/skills/"
    print_success "Merged $PROFILE skills"
  fi
fi

# ─── Fill placeholders in CLAUDE.md ───────────────────────────────────────
CLAUDE_MD="$TARGET/CLAUDE.md"

sed -i.bak \
  -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
  -e "s/{{ONE_LINE_DESCRIPTION}}/$PROJECT_DESC/g" \
  -e "s/{{active | maintenance | greenfield}}/$PROJECT_STATUS/g" \
  -e "s|{{DEV_COMMAND}}|$DEV_CMD|g" \
  -e "s|{{BUILD_COMMAND}}|$BUILD_CMD|g" \
  -e "s|{{TEST_COMMAND}}|$TEST_CMD|g" \
  -e "s|{{LINT_COMMAND}}|$LINT_CMD|g" \
  -e "s|{{TYPECHECK_COMMAND}}|$TYPECHECK_CMD|g" \
  "$CLAUDE_MD"

rm -f "$CLAUDE_MD.bak"
print_success "Filled placeholders in CLAUDE.md"

# Update hook scripts with actual test command
for hook in "$TARGET/.claude/hooks/"*.sh; do
  sed -i.bak \
    -e "s|{{TEST_COMMAND}}|$TEST_CMD|g" \
    -e "s|{{LINT_ON_SAVE_JS}}|$LINT_ON_SAVE_JS|g" \
    -e "s|{{LINT_ON_SAVE_PY}}|$LINT_ON_SAVE_PY|g" \
    -e "s|{{LINT_ON_SAVE_GO}}|$LINT_ON_SAVE_GO|g" \
    "$hook"
  rm -f "$hook.bak"
done

# Update command files with actual commands
for cmd in "$TARGET/.claude/commands/"*.md; do
  sed -i.bak \
    -e "s|{{TEST_COMMAND}}|$TEST_CMD|g" \
    -e "s|{{LINT_COMMAND}}|$LINT_CMD|g" \
    -e "s|{{BUILD_COMMAND}}|$BUILD_CMD|g" \
    -e "s|{{TYPECHECK_COMMAND}}|$TYPECHECK_CMD|g" \
    "$cmd"
  rm -f "$cmd.bak"
done

# ─── Set hook permissions ─────────────────────────────────────────────────
chmod +x "$TARGET/.claude/hooks/"*.sh
print_success "Set hook permissions"

# ─── Add to .gitignore ────────────────────────────────────────────────────
GITIGNORE="$TARGET/.gitignore"
if [ -f "$GITIGNORE" ]; then
  if ! grep -q "CLAUDE.local.md" "$GITIGNORE"; then
    echo "" >> "$GITIGNORE"
    echo "# Claude Code personal overrides" >> "$GITIGNORE"
    echo "CLAUDE.local.md" >> "$GITIGNORE"
    print_success "Added CLAUDE.local.md to .gitignore"
  else
    print_warning "CLAUDE.local.md already in .gitignore"
  fi
else
  echo "CLAUDE.local.md" > "$GITIGNORE"
  print_success "Created .gitignore with CLAUDE.local.md"
fi

# ─── Done ─────────────────────────────────────────────────────────────────
print_header "Done! ✨"
echo ""
echo "Your Claude Code setup is ready at: $TARGET"
echo ""
echo "Next steps:"
echo "  1. Open $TARGET/CLAUDE.md and fill in the remaining {{PLACEHOLDER}} sections"
echo "  2. Edit $TARGET/CLAUDE.local.md with your personal preferences"
echo "  3. Review $TARGET/.claude/settings.json — adjust allow/deny lists for your stack"
echo "  4. Customize hooks in $TARGET/.claude/hooks/ for your linter/test runner"
echo "  5. Open Claude Code in $TARGET and start building"
echo ""
echo "Profile installed: ${PROFILE:-none (base only)}"
echo ""
