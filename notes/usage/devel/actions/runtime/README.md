---
title: Project "runtime" Actions
subtitle: development environment actions
caption: runtime.sh
author: --
date: 2021-10-29
---
|                                             |                                            |                                          |                               |                                   |
|---------------------------------------------|--------------------------------------------|------------------------------------------|-------------------------------|-----------------------------------|
| [Next: Worker Actions](../worker/README.md) | [Prev:  Build Actions](../build/README.md) | [Up: Development Commands](../README.md) | [[Contents]](../../../README.md) | [[Index]](../../../_index/README.md) |


Project "runtime" Actions
=======================

The `./runtime.sh` script
-----------------------

In `containerized` projects, the runtime script enter the execution context enabling development activities on the project.

The [`runtime.sh`](../../../../../runtime.sh) script invokes (thru [`Makefile`](../../../../../decker/r-images/Makefile)) all [Podman "run"](https://docs.podman.io/en/latest/markdown/podman-run.1.html) runtime actions for the project.

This execution environment, internal in running container, shares file-system project folder with external (native) calling environment.


For `runtime.sh` usage info is shown by:

```bash

./runtime.sh --help

# usage ./runtime.sh [target] [args, ...]

```

Runtime actions (containerized)
-------------------------------

***rstudio*** (default), aliases: `ide`, `RStudio`
: runs RStudio-server bound locally on port 28787

***repl***, aliases: `r`, `R`
: runs interactive R console

***cli***, aliases: `rscript`, `Rscript`
: runs interactive shell prompt

***shell***, aliases: `sh`, `prompt`
: runs interactive shell prompt

***bash***, aliases: `do`, `command`
: runs shell with args,...

***term***, aliases: `in`, `attach`
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


### Mapping Definition

Runtime [Volume mapping](https://docs.podman.io/en/latest/markdown/podman-run.1.html#volume-v-source-volume-host-dir-container-dir-options) if defined in [`Makefile`](../../../../decker/r-images/Makefile)), in lines

```
	$(DOCKER)  run \
    ...
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
    ...

```

### Examples

#### RStudio

```bash

./runtime.sh

# aliases
./runtime.sh ide
./runtime.sh rstudio
./runtime.sh RStudio

```
then (depending on connection client),

- if `X2Go`,

```bash
   chromium-browser http://localhost:28787
```

- if `nomachine`,

```bash
firefox http://localhost:28787
```

- if remote (with [`ssh port forwarding`](https://linuxize.com/post/how-to-setup-ssh-tunneling/)) from remote PC

```bash
   ssh -L28787:localhost:28787 user@vm 

```

running RStudio Server is available at:

- http://localhost:28787

with credentials:

|              |                                                 |
| ------------ | ----------------------------------------------- |
| **user**     | `root`                                          |
| **password** | *default remote user password (generated)* [^1] |

[^1]: please contact support for details


#### R Console

```bash

./runtime.sh repl

# aliases
 ./runtime.sh r
 ./runtime.sh R
 
``` 

then check 'getwd()' and exit 'q()'


R Script
---------

```bash
./runtime.sh cli     exec/dummy_runner.R

# aliases
./runtime.sh rscript exec/dummy_runner.R
./runtime.sh Rscript exec/dummy_runner.R

```

to run scripts from ./exec directory 


Shell Prompt
------------

```bash
 ./runtime.sh sh
 
# aliases
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


