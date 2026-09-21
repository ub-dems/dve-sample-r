# Python Development & Refactoring Best Practices in Antigravity

This document provides a focused discussion on integrating your `uv`-managed Python setup into an efficient Antigravity workflow natively. Antigravity brings strong deterministic LLM capacities that excel when boundaries and scopes are well-defined. By using these practices, you provide Antigravity with optimal context and maintain a clean separation of concerns.

## 1. Fast Setup with `uv`
- **Execution Strategy:** Antigravity doesn't need external MCP wrappers to run `uv` because `uv` is incredibly fast to execute natively in the shell. Rely on `uv run <command>` dynamically inside agent workloads.
- **Dependency Addition:** When prompted to add a feature, Antigravity should perform `uv add <dependency>` directly. `uv` seamlessly manages updates to `pyproject.toml` and locks.

## 2. Leverage Project Scoping
- **Context Management:** Antigravity reads scopes strictly to avoid hallucinating paths. Keep pure Python features inside `src/`. If an API requires containerization, orchestrate it completely out of `docker/`. Modularity keeps the LLM's context window focused and significantly reduces errors.
- **Data Engineering:** You're importing heavier items (`pandas`, `polars`, `torch`). Make sure Antigravity accesses `.parquet` or `.csv` solely via logic generated for `src/` to prevent LLMs from trying to ingest large binary files natively in the interface.

## 3. Strict Quality Verification
- **Test-Driven:** Ask Antigravity to "add tests for `<feature>`". It knows to place it in `tests/pytest/` based on `project-scopes.md` and check it instantly using `uv run pytest`.
- **Formatting Loop:** Incorporate a validation step before finishing any PR/Feature: `uv run ruff format` and `uv run ruff check --fix`. The IDE relies on standardizing PEP defaults.
- **Static Typing (`pyright`):** Antigravity is aware of Pyright typing requirements; always enforce adding `-> Type:` semantics.

## 4. CUDA and Podman Best Practices
- **Host vs Container:** For NLP/Pytorch processes, run `pytest` via `uv` on the local host to leverage local CUDA drivers (`torch130` explicitly identified in pyproject). 
- **Podman:** Use `podman` in the `docker/` scope for finalizing images before shipping. Avoid running generic code-generation tests inside podman unless explicitly integrating CI behaviors.
- **Model Caching:** Map `$HOME/.cache/huggingface` internally between local and container executions to avoid redownloading transformer checkpoints.

Following these practices ensures zero friction between Antigravity’s rapid feedback loop and standard deep-learning ecosystem rules.
