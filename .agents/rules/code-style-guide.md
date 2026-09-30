---
trigger: always_on
---

- Make sure all python code is styled with PEP 8 style guide, enforcing the `ruff` formatter config defined in `pyproject.toml` (e.g. `uv run ruff format`).
- Adhere strictly to the linting rules set by `ruff`. Use `uv run ruff check --fix` before presenting code.
- Ensure code leverages type hinting. The `pyright` tool is standard for this project.
- Make sure all the code is properly commented using Google style docstrings.
- Unit testing is mandated. Use `pytest` for all functional testing.
