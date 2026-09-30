---
name: vce-coding-standards
description: >
  Consult this skill whenever you are writing, editing, reviewing, or testing
  code in the VCE project. Triggers include: creating or modifying any Python,
  R, or JavaScript file; writing pytest tests; reviewing a pull request diff;
  adding imports or dependencies; running ruff, pyright, or testthat; checking
  type annotations; or any task where coding style, test patterns, or import
  conventions need to be applied. Load this skill before producing any code
  output so that formatting, linting, and test standards are applied correctly
  from the start.
---

# vce-coding-standards

Standards for Python, R, and JavaScript code in this project.
Apply every rule in the relevant section before delivering code.

---

## Python — Formatting & Linting

Run **both** steps immediately after writing or editing any Python file,
before moving to the next task

```bash
uv run ruff format <file_path>
uv run ruff check --fix <file_path>
```

Then run static type-checking:

```bash
uv run pyright <file_path>
```

### Import rules

- All imports at the **top of the file**.
- Valid exceptions only:
  - Circular imports (restructure if possible; document if not)
  - Lazy loading for worker isolation
  - `TYPE_CHECKING` blocks

### Style reference

See `/python-code-style` for full formatting conventions.

---

## Python — Testing Standards

- **Framework:** `pytest` patterns only — do not use `unittest.TestCase`.
- **Coverage:** add tests for success, failure, and edge cases for every new behaviour.
- **Mocking:** use `spec` / `autospec` when mocking objects.
- **Parametrisation:** use `@pytest.mark.parametrize` for multiple similar inputs.
- **Database tests:** mark with `@pytest.mark.db_test`.
- **Fixtures:** see `tests/pytest/dve/tests/pytest_plugin.py`.

### Running tests

```bash
# Single test
uv run pytest path/to/test.py::TestClass::test_method -xvs

# Test file
uv run pytest path/to/test.py -xvs

# All tests in a package
uv run pytest path/to/package -xvs
```

---

## R — Conventions

- Virtual environment: managed by `renv` (explicit lock-file commits required).
- Tests: `testthat` under `tests/testthat/`.
- Documentation: roxygen2 in `R/`; rendered to `man/`.
- Run R scripts inside the container via `runtime.sh rs <script>` or
  natively via `uv run Rscript <script>` when the env is active.

---

## JavaScript / JupyterLab — Conventions

- Package manager: `jlpm` (yarn-compatible).
- Install / update: `uv run jlpm up && uv run jlpm install`.
- Scope: JupyterLab extensions and optional skill scripts (`package.json`).
- Do not mix application logic into the `docker/` subtree.
