---
name: python-conventions
description: Python-specific idioms, data pipeline patterns, and project conventions. Auto-invoked when building Python scripts, data pipelines, or packages.
user-invocable: true
---

# Python Conventions Skill

## Data ingestion pattern (generic)
```python
from pathlib import Path
from typing import Iterator
import logging

logger = logging.getLogger(__name__)

def ingest_file(path: Path, chunk_size: int = 1000) -> Iterator[list[dict]]:
    """
    Yields chunks of records from a file.
    
    Args:
        path: Path to the input file
        chunk_size: Records per chunk
        
    Yields:
        List of parsed records
        
    Raises:
        FileNotFoundError: If path does not exist
        ValueError: If file format is invalid
    """
    if not path.exists():
        raise FileNotFoundError(f"Input file not found: {path}")
    
    chunk = []
    with open(path) as f:
        for line in f:
            try:
                record = parse_line(line)
                chunk.append(record)
                if len(chunk) >= chunk_size:
                    yield chunk
                    chunk = []
            except ValueError as e:
                logger.warning("Skipping malformed line: %s", e)
    
    if chunk:
        yield chunk
```

## Pydantic model pattern
```python
from pydantic import BaseModel, field_validator
from datetime import datetime

class EventRecord(BaseModel):
    id: str
    timestamp: datetime
    value: float
    source: str

    @field_validator("value")
    @classmethod
    def value_must_be_positive(cls, v: float) -> float:
        if v < 0:
            raise ValueError("value must be non-negative")
        return v
    
    model_config = {"frozen": True}  # immutable after creation
```

## CLI entry point pattern (click)
```python
import click
import logging

@click.command()
@click.option("--input", "-i", required=True, type=click.Path(exists=True))
@click.option("--output", "-o", required=True, type=click.Path())
@click.option("--verbose", "-v", is_flag=True)
def main(input: str, output: str, verbose: bool) -> None:
    """Process input file and write results to output."""
    logging.basicConfig(level=logging.DEBUG if verbose else logging.INFO)
    # ...

if __name__ == "__main__":
    main()
```

## Environment config pattern
```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    api_key: str
    batch_size: int = 500
    log_level: str = "INFO"

    model_config = {"env_file": ".env"}

settings = Settings()  # validates on import, fails fast if required vars missing
```

## Common mistakes to avoid
- Mutable default arguments: `def fn(items=[])` — use `None` and initialize inside
- Catching broad exceptions: `except Exception:` — be specific
- `print()` in library code — use `logging`
- Not closing file handles — always use `with open()`
- String formatting with `%` or `.format()` — use f-strings
- `import *` — always explicit imports
