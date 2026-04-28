---
paths:
  - "**/*.go"
  - "cmd/**/*"
  - "internal/**/*"
  - "pkg/**/*"
---

# Go Service Rules

## Project structure (Standard Layout)
```
cmd/
  myservice/
    main.go          ← entry point, minimal — just wires up and starts
internal/
  service/           ← business logic
  repository/        ← data access
  handler/           ← HTTP/gRPC handlers
  middleware/        ← request middleware
  config/            ← config loading and validation
pkg/                 ← code safe to import by external packages (if any)
```
Never put business logic in `main.go`. Never put handlers in `cmd/`.

## Error handling
- Always handle errors — `_` for an error is almost always wrong
- Wrap errors with context: `fmt.Errorf("user.GetByID %d: %w", id, err)`
- Don't log and return — either log it OR return it, not both
- Sentinel errors for known conditions: `var ErrNotFound = errors.New("not found")`
- Use `errors.Is()` and `errors.As()` for error comparison — never string matching

## Interfaces
- Define interfaces at the point of use (consumer), not at the point of definition (producer)
- Keep interfaces small — single-method interfaces compose well
- Accept interfaces, return structs
- Don't over-abstract early — extract interfaces when you need to mock for tests

## Concurrency
- Use channels to communicate, not to synchronize — use mutexes to protect shared state
- Every goroutine must have a clear lifetime and exit path
- Use `context.Context` for cancellation — accept it as the first parameter
- Always cancel contexts you create: `ctx, cancel := context.WithTimeout(...); defer cancel()`
- Use `errgroup` for managing groups of goroutines

## Testing
- Table-driven tests for functions with multiple input scenarios
- Test file: `package foo_test` (black-box) for public API, `package foo` (white-box) for internals
- Use `testify/assert` and `testify/require` — `require` for setup, `assert` for assertions
- Mock interfaces with `testify/mock` or `go:generate` + `mockery`
- Race detector in CI: `go test -race ./...`

## Performance
- Avoid allocations in hot paths — benchmark before optimizing
- Prefer `strings.Builder` over string concatenation in loops
- Pool objects that are expensive to create: `sync.Pool`
- Profile before optimizing: `pprof` is built in

## Style
- Run `gofmt` and `golint` — no exceptions
- Follow Effective Go and the Google Go Style Guide
- Max function length: ~50 lines. Longer functions are a design smell.
- Named return values only when they add significant clarity (rare)
