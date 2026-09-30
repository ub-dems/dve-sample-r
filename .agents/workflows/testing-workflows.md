# Testing Workflow

When instructed to test or when validating generated functionality:

1. **Run**: Always invoke tests via the `uv` package manager:
   ```bash
   uv run pytest
   ```
2. **Options**: Use `-v` for verbosity or `--disable-warnings` to focus on errors during debugging.
3. **Coverage**: If generating new code, ensure corresponding coverage using `uv run pytest --cov=src` or referring to the `pytest-cov` settings inside `pyproject.toml`.
4. **Fixing**: If tests fail, run `uv run ruff check` to ensure syntax isn't broken, modify the code according to pyright type requirements, and rerun the tests. Avoid relying directly on global `pytest` binaries.
