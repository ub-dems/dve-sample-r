---
description: Include python packages in `pyproject.toml` for python skill scripts. Re-Run this after python enhanced skill addition.
---

Scan all python code under .agents/skills and look for python package dependenciy not included in `pyproject.toml`, then add the missing dependencie at the end of `dev` `dependency-groups` in `pyproject.toml` using this template:

```toml
[dependency-groups]

dev = [

 #  ignore ...

 # --- skills ---

# ADD ADDITIONAL DEPENDECY HERE

 # --- packaging ---
 #  ignore ...

]
```

After the addition, run `uv sync` command
