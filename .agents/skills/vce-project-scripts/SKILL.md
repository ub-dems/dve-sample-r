---
name: vce-project-scripts
description: >
  Consult this skill whenever you need to run project-level scripts in the
  project. Triggers include: building the project, running tests via build.sh,
  managing container images with podman/docker, starting or stopping containers,
  launching JupyterLab or RStudio servers, running interactive REPLs inside a
  container, executing batch Python or R scripts in a containerised environment,
  or any task that involves build.sh, runtime.sh, the root Makefile, or
  docker/r-image/Makefile. Load this skill before invoking any of those scripts.
---
<!-- markdownlint-disable MD013 -->

# vce-project-scripts

Reference for every project-level script command. Read this before invoking
`build.sh`, `runtime.sh`, or any `make` target.

---

## Script Entry-points

| Script                    | Purpose                                                             |
|---------------------------|---------------------------------------------------------------------|
| `build.sh`                | Build, test, lint, docs, and container-image commands               |
| `runtime.sh`              | Container lifecycle and interactive session commands                |
| `Makefile`                | Core command implementation — invoked by the scripts above          |
| `docker/r-image/Makefile` | Low-level `podman` interface (normally called by the scripts above) |

Run `build.sh --help` or `runtime.sh --help` for the full option list.

---

## build.sh — Container Image Lifecycle

| Command            | Effect                                                                           |
|--------------------|----------------------------------------------------------------------------------|
| `build.sh setup`   | Initial image creation                                                           |
| `build.sh update`  | Update existing images                                                           |
| `build.sh upgrade` | Remove `uv.lock` and `renv.lock` to force full package upgrade                   |
| `build.sh full`    | `setup` + `runtime.sh` virtual-environment installation in the persistent volume |

---

## build.sh — Native & Containerised Project Commands

These commands work in **both** native and containerised contexts.

| Command          | Effect                                      |
|------------------|---------------------------------------------|
| `build.sh build` | Build the project (Python + R)              |
| `build.sh test`  | Run project tests (Python + R)              |
| `build.sh check` | Run linters and static checks (Python + R)  |
| `build.sh docs`  | Generate project documentation (Python + R) |

---

## runtime.sh — Initial Setup (run once)

| Command                  | Effect                                                                            |
|--------------------------|-----------------------------------------------------------------------------------|
| `runtime.sh environment` | Import `~/.config` and SSH keys into the mapped `home/user/` inside the container |
| `runtime.sh setup`       | Run `setup.sh` inside the container to initialise virtual environments            |

---

## runtime.sh — Interactive Sessions

| Command             | Effect                                                    |
|---------------------|-----------------------------------------------------------|
| `runtime.sh sh`     | Interactive `bash` inside the container via `uv run bash` |
| `runtime.sh python` | `ipython` REPL                                            |
| `runtime.sh R`      | R REPL                                                    |
| `runtime.sh term`   | Attach an interactive terminal to a running container     |
| `runtime.sh xterm`  | Attach an `xterm` to a running container                  |

---

## runtime.sh — Batch Execution

| Command                   | Effect                                           |
|---------------------------|--------------------------------------------------|
| `runtime.sh pyrun <args>` | Run `uv run python <args>` inside the container  |
| `runtime.sh rs <args>`    | Run `uv run Rscript <args>` inside the container |

---

## runtime.sh — Wrapper Commands

These delegate to the equivalent `build.sh` / `setup.sh` command, but execute
**inside** the container.

| Command            | Equivalent                       |
|--------------------|----------------------------------|
| `runtime.sh build` | `build.sh build` (containerised) |
| `runtime.sh test`  | `build.sh test` (containerised)  |
| `runtime.sh check` | `build.sh check` (containerised) |

---

## runtime.sh — Servers (ports forwarded to host)

| Command               | Service          | Port    |
|-----------------------|------------------|---------|
| `runtime.sh rstudio`  | RStudio Server   | `28787` |
| `runtime.sh lab`      | JupyterLab       | `28888` |
| `runtime.sh notebook` | Jupyter Notebook | `28888` |

---

## runtime.sh — IDE Commands (require X-Window for GUI)

| Command                  | Effect                                          |
|--------------------------|-------------------------------------------------|
| `runtime.sh code`        | `code-server` inside the container              |
| `runtime.sh cursor`      | Cursor IDE inside the container (X-Window)      |
| `runtime.sh antigravity` | Antigravity IDE inside the container (X-Window) |
