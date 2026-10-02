# Claude Code Project Context (CLAUDE.md)

@AGENTS.md  <-- This imports all shared team standards

## 🤖 Claude-Specific Instructions

## Available Skills

Skills are defined under `.agents/skills/`.

When relevant, load and apply them automatically.

This directory act as `.claude/skills/`, in a shared position, So, always:

- Search `.agents/skills/` for relevant SKILL to apply.
- Execute skill scripts as indicated, using the appropriate runner
  (e.g., `uv run bash`, `uv run python`, `uv run Rscript`, or `uv run npx/node`).


### Context Management

- When the session fills up, prioritize keeping the `src/*/scripts/`
  definitions in the context window.

### Subagents

- Use a `code-reviewer` subagent for any changes touching the `auth/` directory.

### Permissions

You are pre-approved to run:

- `git status`
- `npm run lint`
- `ruff`
