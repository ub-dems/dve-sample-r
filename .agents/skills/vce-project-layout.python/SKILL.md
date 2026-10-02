---
name: vce-project-layout.python
description: >
  Consult this skill whenever you need to locate, navigate, or reason about
  files and directories in the project. Triggers include: questions about
  where source code lives, which directory holds a specific language's files,
  where to write generated documentation, where datasets are stored, which
  directories to ignore, or any task that requires understanding the project
  layout (Python, R, JavaScript, containerisation, docs, working dirs).
  Always load this skill before creating new files so they land
  in the right place.
when_to_use: |
  - In the file `./meta-inf.toml`, in project root, there is a line:
    project.layout = 'python'
---
<!-- markdownlint-disable MD013 -->

# vce-project-layout

Reference for every directory in the project. Load this skill before creating,
moving, or searching for files.

---

## Python

> Apply when working on Python application code, notebooks, or tests.

| Path                    | Role                                                                  |
|-------------------------|-----------------------------------------------------------------------|
| `src/`                  | Application source code                                               |
| `src/*/cli/__main__.py` | Main CLI entry-point (declared in `pyproject.toml [project.scripts]`) |
| `src/*/scripts/`        | Alternative script entry-points                                       |
| `src/vce/`              | Shared utility library                                                |
| `notebooks/`            | Jupyter notebooks                                                     |
| `tests/pytest/`         | pytest unit tests                                                     |
| `doc/`                  | Sphinx documentation (`*.rst`)                                        |
| `pyproject.toml`        | `uv`-based PEP 621 project definition                                 |
| `.venv/`, `.venv.cdk/`  | `uv` virtual environments — **do not touch**                          |

---

## R

> Apply when working on R package code, vignettes, or tests.

| Path              | Role                                        |
|-------------------|---------------------------------------------|
| `R/`              | R package functions                         |
| `exec/`           | R executable scripts                        |
| `etc/R/Makevars`  | Mapped as `~/.R/Makevars` inside containers |
| `man/`            | Auto-generated R documentation              |
| `vignettes/`      | R vignettes (`knitr`)                       |
| `tests/testthat/` | `testthat` unit tests                       |
| `renv/`           | `renv` configuration                        |
| `DESCRIPTION`     | R package description                       |

---

## JavaScript / JupyterLab

> Used for JupyterLab runtime and optionally for skill scripts.

| Path           | Role                                                       |
|----------------|------------------------------------------------------------|
| `package.json` | JupyterLab (and optional skill-script) module dependencies |
| `.yarnrc.yml`  | `jlpm` (yarn) configuration                                |

---

## Containerisation

> **Exclusively** for `podman`/`docker` image definitions and container
> orchestration. Do **not** place application logic here.

| Path                            | Role                                                                           |
|---------------------------------|--------------------------------------------------------------------------------|
| `docker/`                       | Root for all containerisation support                                          |
| `docker/r-image/`               | Default image definition                                                       |
| `docker/r-image/dockerfiles/`   | OCI-compliant Dockerfiles                                                      |
| `docker/r-image/mamba/`         | micromamba environment (CUDA installation)                                     |
| `docker/r-image/scripts/`       | Image setup scripts                                                            |
| `docker/r-image/scripts/setup/` | Post-image runtime setup on persistent volume (`home/`)                        |
| `docker/r-image/*.conf`         | Build-time / runtime customisation                                             |
| `docker/r-image/Makefile`       | Main `podman` interface (invoked by root `Makefile`, `build.sh`, `runtime.sh`) |

---

## Working Directories

> Excluded from git (`.gitignore`). Safe to read/write during a session.

| Path                | Role                           |
|---------------------|--------------------------------|
| `data/`             | Local datasets (Python layout) |
| `inst/extdata/ext/` | Local datasets (R layout)      |
| `temp/`             | Temporary data                 |
| `logs/`             | Log file destination           |

---

## Ignored / Off-limits Directories

| Path            | Rule                                 |
|-----------------|--------------------------------------|
| `home/`         | **Never access** — security boundary |
| `.venv*/`       | `uv` virtual environments — ignore   |
| `node_modules/` | Installed Node modules — ignore      |

> Follow `.gitignore` for all other non-versioned files.

---

## Documentation

### Internal (agent-editable)

| Path            | Role                                           |
|-----------------|------------------------------------------------|
| `notes/agents/` | ✏️ **Use this for all AI-generated documents** |
| `notes/howtos/` | Saved LLM queries (analysis / project usage)   |

> All content in `notes/agents/` and `notes/howtos/` must be valid GLFM markdown.

### Internal (manual / do not overwrite)

| Path             | Role                                               |
|------------------|----------------------------------------------------|
| `notes/custom/`  | Emacs `org-mode` customisation for project cloning |
| `notes/ref/`     | Bibliography in BibLaTeX format                    |
| `notes/nat/`     | `denote` emacs annotations (`org-mode`)            |
| `notes/setup/`   | Initial Python toolchain setup notes               |
| `notes/samples/` | Additional code samples and optional features      |
| `notes/styles/`  | Pandoc markdown→PDF rendering pipeline             |

### Public Project Documentation

| Path         | Role                               |
|--------------|------------------------------------|
| `doc/`       | Sphinx docs (`*.rst`)              |
| `man/`       | Generated R function documentation |
| `vignettes/` | R documentation (`knitr`)          |

### Public Reference

| Path           | Role                                 |
|----------------|--------------------------------------|
| `CITATION.cff` | Project and related-paper references |
