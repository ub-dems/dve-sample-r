---
name: vce-project-layout
description: >
  Consult this skill whenever you need to locate, navigate, or reason about
  files and directories in the project. Triggers include: questions about
  where source code lives, which directory holds a specific language's files,
  where to write generated documentation, where datasets are stored, which
  directories to ignore, or any task that requires understanding the project
  layout (Python, R, JavaScript, containerisation, docs, working dirs).
  Always load this skill before creating new files so they land
  in the right place.
---
<!-- markdownlint-disable MD013 -->

# vce-project-layout

In the file `./meta-inf.toml`, in project root, look for a line starting with `project.layout` 
and route to the correct projects layout skill:

| Skill                       | Triggers                                  |
|-----------------------------+-------------------------------------------|
| `vce-project-layout.python` | if the line is: project.layout = 'python' |
| `vce-project-layout.R`      | if the line is: project.layout = 'R'      |
|                             |                                           |

