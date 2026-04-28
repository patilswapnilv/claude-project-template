---
name: go-conventions
description: Go-specific idioms, patterns, and project structure conventions. Auto-invoked when building Go services, CLIs, or packages.
user-invocable: true
---

# Go Conventions Skill

## HTTP handler pattern (standard library + minimal deps)
```go
type UserHandler struct {
    svc UserService
}

func (h *UserHandler) GetUser(w http.ResponseWriter, r *http.Request) {
    ctx := r.Context()
    id, err := parseID(r.PathValue("id"))  // Go 1.22+
    if err != nil {
        respondError(w, http.StatusBadRequest, "invalid id")
        return
    }

    user, err := h.svc.GetUser(ctx, id)
    if errors.Is(err, ErrNotFound) {
        respondError(w, http.StatusNotFound, "user not found")
        return
    }
    if err != nil {
        // log here, don't expose internal error
        respondError(w, http.StatusInternalServerError, "internal error")
        return
    }

    respondJSON(w, http.StatusOK, user)
}
```

## Config pattern
```go
// internal/config/config.go
type Config struct {
    Port     int    `env:"PORT" envDefault:"8080"`
    DBUrl    string `env:"DATABASE_URL,required"`
    LogLevel string `env:"LOG_LEVEL" envDefault:"info"`
}

func Load() (*Config, error) {
    cfg := &Config{}
    if err := env.Parse(cfg); err != nil {
        return nil, fmt.Errorf("config.Load: %w", err)
    }
    return cfg, nil
}
```

## Dependency injection (manual, no framework)
```go
// cmd/myservice/main.go
func main() {
    cfg, err := config.Load()
    if err != nil { log.Fatal(err) }

    db := database.Connect(cfg.DBUrl)
    userRepo := repository.NewUserRepository(db)
    userSvc := service.NewUserService(userRepo)
    userHandler := handler.NewUserHandler(userSvc)

    mux := http.NewServeMux()
    mux.HandleFunc("GET /users/{id}", userHandler.GetUser)

    log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", cfg.Port), mux))
}
```

## Common mistakes to avoid
- Returning a nil interface with a non-nil type (the nil interface trap)
- Closing `http.Response.Body` without checking if response is nil first
- Using `time.Sleep` in production code instead of timers/tickers
- Not draining and closing `http.Response.Body` even on error responses
- Goroutine leaks from channels no one reads or goroutines with no exit path

## CLI pattern (cobra)
```go
var rootCmd = &cobra.Command{
    Use:   "mytool",
    Short: "One-line description",
    RunE: func(cmd *cobra.Command, args []string) error {
        // business logic here, return errors don't log them
        return nil
    },
}
```
