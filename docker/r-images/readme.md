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

# environment

export E_ROOT_DIR=$(git rev-parse --show-toplevel)
export E_DOCKER_DIR=${E_ROOT_DIR}/docker/r-images
export E_ID_PROJECT="$(basename ${E_ROOT_DIR})"

env | grep ^E_ | sort


# runtime images

cd $E_DOCKER_DIR && pwd

podman build -t localhost/${E_ID_PROJECT}.anchor    -f dockerfiles/anchor.Dockerfile . 
podman build -t localhost/${E_ID_PROJECT}.base      -f dockerfiles/base.Dockerfile . 
podman build -t localhost/${E_ID_PROJECT}.runtime   -f dockerfiles/runtime.Dockerfile . 


# package images

cd $E_ROOT_DIR && pwd

podman build -t localhost/${ID_PROJECT}.worker      -f dockerfiles/worker.Dockerfile . 



```

Run rstudio
-----------

```

# set password

: ${E_RUN_USER_PASSWORD:=$(mkpasswd $RANDOM)}; echo "passwd=${E_RUN_USER_PASSWORD}"

# run rstudio server

RS=1; \
   export E_RUN_USER_NAME="root"; \
   export E_RUN_USER_HOME="/{E_RUN_USER_NAME}"; \
   export E_RUN_USER_UID="0"; \
   export E_RUN_USER_GID="0"; \
   export E_ROOT_DIR=$(git rev-parse --show-toplevel); \
   export E_DOCKER_DIR=${E_ROOT_DIR}/docker/r-images; \
   export E_ID_PROJECT="$(basename ${E_ROOT_DIR})"; \
   : ${E_IMG_RUNTIME:="${E_ID_PROJECT}.runtime"}; \
   echo "" \ 
   echo "======================" \ 
   echo "=== rstudio server ===" \ 
   echo "======================" \ 
   echo "user: ${E_RUN_USER_NAME}" \ 
   echo "pass: ${E_RUN_USER_PASSWORD}" \ 
   echo "" \ 
   echo " url: http://localhost:28787/" \ 
   echo "" \ 
   podman run \
		--rm \
		--ulimit=host \
		-p 28787:8787 \
		-v ~/work:${E_RUN_USER_HOME}/work:Z  \
		-v ~/data:${E_RUN_USER_HOME}/data:Z  \
		-e PASSWORD=${E_RUN_USER_PASSWORD} \
		-e USER=${E_RUN_USER_NAME} \
		-e USERID=${E_RUN_USER_UID} \
		-e GROUPID=${E_RUN_USER_GID} \
		-e ROOT=true  \
		${E_IMG_RUNTIME}




```


