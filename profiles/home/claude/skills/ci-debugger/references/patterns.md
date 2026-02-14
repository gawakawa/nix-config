# Grep Patterns for CI Log Analysis

## High Priority Patterns

| Pattern | Context | Purpose |
|---------|---------|---------|
| `##\[error\]` | -C 5 | GitHub Actions error annotations |
| `::error::` | -C 5 | Workflow command errors |
| `Process completed with exit code [1-9]` | -B 15 | Non-zero exit codes |

## Build System Patterns

### Nix

| Pattern | Context | Purpose |
|---------|---------|---------|
| `^error:` | -C 15 | Evaluation/build errors |
| `error: builder for .* failed` | -B 5 -A 30 | Builder failures with full output |

### Node/npm

| Pattern | Context | Purpose |
|---------|---------|---------|
| `npm ERR!` | -C 5 | npm errors |
| `Module not found` | -C 3 | Missing module errors |

### Python

| Pattern | Context | Purpose |
|---------|---------|---------|
| `Traceback` | -A 20 | Stack traces |
| `ModuleNotFoundError` | -C 3 | Import errors |

## General Patterns

| Pattern | Context | Purpose |
|---------|---------|---------|
| `FAILED` | -C 10 | Generic failure messages |
| `fatal:` | -C 5 | Git and other fatal errors |
| `panic:` | -C 10 | Go/Rust panics |
| `Exception` | -C 5 | Exception messages |
