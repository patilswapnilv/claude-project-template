# Hooks Contract

See: https://code.claude.com/docs/en/hooks

## Input Contract

Claude Code command hooks receive JSON via stdin.

- For `PostToolUse` on `Edit|Write`, the edited file path is at `.tool_input.file_path`.
- The template hook `base/.claude/hooks/lint-on-save.sh` reads stdin JSON first.
- For compatibility with manual runs, the script falls back to `$1` when stdin is empty or unparsable.

Example hook payload shape:

```json
{
  "hook_event_name": "PostToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/absolute/path/to/file.ts"
  }
}
```

## Exit Codes

- `0` allow/continue
- `2` block (event-dependent in Claude Code)
- `1` script/runtime error (logged)

## lint-on-save Behavior

`lint-on-save.sh` is scaffold-only by default. It detects the edited file extension and prints a skip message unless language-specific formatter/linter commands are uncommented.
