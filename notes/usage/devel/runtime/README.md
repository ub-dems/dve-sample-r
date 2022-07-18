---
title: "runtime" actions
subtitle: development environment actions
author: --
date: 2021-10-29
---
|                                               |                                             |                            |                                |
|-----------------------------------------------|---------------------------------------------|----------------------------|--------------------------------|
| [Next: Worker Actions](../worker/README.md) | [Up: Development Environment](../README.md) | [[Contents]](../README.md) | [[Index]](../_index/README.md) |


Project "runtime" Actions
=======================
The `./runtime.sh` script
-----------------------


In `containerized` projects, the runtime script enter the execution context 
enabling developmet activities on the project.

The [`runtime.sh`](../../../../runtime.sh) script invokes (thru [`Makefile`](../../../../decker/r-images/Makefile)) 
all [podman "run"](https://docs.podman.io/en/latest/markdown/podman-run.1.html)  actions for the project.

This execution environment, internal in running container, shares filesystemm 
project folder with external (native) calling environment.


For `runtime.sh` usage info:

```bash

./runtime.sh --help

# usage ./runtime.sh [target] [args, ...]


```

Runtime actions (containerized)
-------------------------------

`rstudio` (default), aliases: `ide`, `RStudio`
: runs rstudio-server bound on port 28787

`repl`, aliases: `r`, `R`
: runs interactive R console

`cli`, aliases: `rscript`, `Rscript`
: runs interactive shell prompt

`shell`, aliases: `sh`, `prompt`
: runs interactive shell prompt

`bash`, aliases: `do`, `command`
: runs shell with args,...

`term`, aliases: `in`, `attach`
: attach interactive shell to running runtime



Runtime Drive Mapping
---------------------

default volume mapping:

```
 ~/work => ~/work
 ~/data => ~/data
``` 

*userid*
`user:group` UID:GID => `root:root` (0:0)

*path*:
  `~` := `/home/$USER` => `~` := `/root` (volatile, not shared)

*workdir*: 
   `/root/work/../....`: current project directory


### Examples

#### RStudio

```bash

./runtime.sh

./runtime.sh ide
./runtime.sh rstudio
./runtime.sh RStudio

```
then (depending on connection client),

- if X2Go,

```bash
   chromium-browser http://localhost:28787
```

- if nomachine,

```bash
firefox http://localhost:28787
```

- if remote (with ssh port forwarding) from remote PC

```bash
   ssh -L28787:localhost:28787 user@vm 

```
then open in browser: http://localhost:28787


RStudio login with user `root`, and default user password as password 
_(please contact support fot details)_

#### R Console

```bash
 ./runtime.sh repl
 ./runtime.sh r
 ./runtime.sh R
``` 

then check 'getwd()' and exit 'q()'


R Script
---------

```bash
 ./runtime.sh cli     exec/dummy_runner.R
 ./runtime.sh rscript exec/dummy_runner.R
 ./runtime.sh Rscript exec/dummy_runner.R
```

to run scripts from ./exec directory 


Shell Prompt
------------

```
 ./runtime.sh sh
 ./runtime.sh shell
 ./runtime.sh prompt
``` 
for interactive shell prompt

Shell Command
-------------

or with command args

```bash
 ./runtime.sh do bash -c 'echo "$$(date)" ; df -h ; ip a'
 ./runtime.sh do ( inxi -F | grep -i nvidia )
 ./runtime.sh do whoami
``` 
to run execute shell commands


