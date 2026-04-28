---
paths:
  - "**/*.py"
  - "src/**/*.py"
  - "scripts/**/*.py"
  - "notebooks/**/*.ipynb"
---

# Python Data Rules

## Project structure
```
src/
  mypackage/
    __init__.py
    ingestion/       ← data loading and parsing
    processing/      ← transforms, cleaning, enrichment
    storage/         ← database writes, file output
    models/          ← data models and schemas
    utils/           ← shared utilities
scripts/             ← one-off scripts, entry points
tests/
notebooks/           ← exploratory only, not production code
```

## Code style
- Follow PEP 8. Use `ruff` for linting and formatting.
- Type hints on all function signatures: `def process(data: pd.DataFrame) -> pd.DataFrame:`
- Docstrings on all public functions: what it does, params, returns, raises
- Line length: 88 (Black default)
- No mutable default arguments: `def fn(data=None): data = data or []`

## Data handling
- Validate data at ingestion boundaries — don't assume input schema is correct
- Use Pydantic for data validation and schema definition
- Prefer `pathlib.Path` over `os.path` string operations
- Use context managers for file and database connections
- Never load entire large datasets into memory if chunking is possible

## Dependencies
- `requirements.txt` for production, `requirements-dev.txt` for dev tools
- Pin exact versions in production: `pandas==2.1.4` not `pandas>=2.0`
- Virtual environment: always. Document setup in README.
- Prefer standard library + well-maintained packages — minimize dependencies

## Error handling
- Specific exceptions over bare `except:` — always catch what you expect
- Log errors with context before re-raising or handling
- Use `logging` module, not `print()` — configure at entry point, not in library code

## Testing
- `pytest` for all tests
- Test data: small fixtures, not copies of production data
- Mock external services and databases in unit tests
- Use `pytest-cov` for coverage reporting

## Notebooks
- Notebooks are for exploration only — production code lives in `src/`
- Clear output before committing notebooks to version control
- Notebook cells must be runnable top-to-bottom with a fresh kernel
