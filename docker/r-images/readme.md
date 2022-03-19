---
title: r-images Podman HowTo
subtitle: R podman images based on Rocker Project standard R images
author: --
date: 2022-02-08
---

REFERENCES
==========

* [The Rocker Project - Docker Containers for the R Environment](https://www.rocker-project.org/)
* [Version-stable Rocker images](https://github.com/rocker-org/rocker-versioned2)
* [Pod Manager tool (podman)](https://podman.io/)
* [How to share files between rstudio/rocker and external folders with podman](https://github.com/rocker-org/rocker-versioned2/issues/346)



QUICK START
===========

Image Build
-----------

```
podman build -t ubdems/dve-base    -f dockerfiles/dve-base_devel.Dockerfile . 

podman build -t ubdems/dve-default -f dockerfiles/dve-default_devel.Dockerfile . 

```

Run rstudio
-----------

```

#podman run --rm --ulimit=host -p 8787:8787 -e PASSWORD=Sec3et -v ~/work:/root/work:Z  -e USER=root -e USERID=0 -e GROUPID=0 -e ROOT=true  ubdems/dve-base 

podman  run --rm --ulimit=host -p 8787:8787 -e PASSWORD=Sec3et -v ~/work:/root/work:Z  -e USER=root -e USERID=0 -e GROUPID=0 -e ROOT=true  ubdems/dve-default


# firefox http://localhost:8787

```


