---
trigger: always_on
---

- The main method in main.py is the entry point to showcase functionality.
- Do not generate code in the main method. Instead generate distinct functionality in a new file (eg. feature_x.py) respecting the project directory scopes defined in `project-scopes.md`.
- Then, generate example code to show the new functionality in a new method in main.py (eg. example_feature_x) and simply call that method from the main method.
- For dependency management and scripting, always execute scripts via `uv run` to ensure isolation, or use `uv add` when the user asks to install new dependencies.
