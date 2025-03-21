##
#{{{ Makefile: image build and run
#
# The following environment variables must be set in make.env:
#	- DIST_DIR: directory the app is built to
#	- CONTAINER_APP: name of the Docker image
#	- CONTAINER_PORT: port the app is listening to
#	- CONTAINER_REGISTRY: URL of the registry the image will be pushed to
#	- LOCAL_PORT: port used to access app on localhost
#
#}}} \\\


#{{{ [ VARS.* ] /////////////////////////////////////////////////////////////////

# ---(shell)------------------------------------------------

SHELL = /bin/bash
.SHELLFLAGS := -o pipefail -c
#.SHELLFLAGS = -xo pipefail -c

# ---(info)------------------------------------------------

E_BUILD_TS ?= $(shell (date +%Y%m%d-%H%M%S-%Z))

# ---(config)------------------------------------------------

# Import environment variables from make.env
#conf ?= make.env
#include $(conf)
#export $(shell sed 's/=.*//' $(conf))

# ---(base)------------------------------------------------

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKE_DIR := $(patsubst %/,%,$(dir $(MAKEFILE_PATH)))
ROOT_DIR := $(shell (cd ${MAKE_DIR} && git rev-parse --show-toplevel))
WORK_DIR := $(patsubst ${HOME}/%,./%,${ROOT_DIR})
MAKEFILE_FOLDER := $(notdir ${MAKE_DIR})

WORKER_DIR := '/worker'

# ---(modules)------------------------------------------------

BLD_RUNTIME ?= runtime
BLD_WORKER ?= worker
BLD_REMOTE_IMAGES ?= anchor
BLD_RUNTIME_IMAGES ?= ${BLD_REMOTE_IMAGES} base ${BLD_RUNTIME}
BLD_WORKER_IMAGES ?= ${BLD_WORKER}
BLD_ALL_IMAGES ?= ${BLD_RUNTIME_IMAGES} ${BLD_WORKER_IMAGES}

DKF_RUNTIME ?= $(patsubst %,${MAKE_DIR}/dockerfiles/%.Dockerfile,${BLD_RUNTIME})
DKF_WORKER ?= $(patsubst %,${MAKE_DIR}/dockerfiles/%.Dockerfile,${BLD_WORKER})

IMG_RUNTIME ?= $(shell (grep 'org.opencontainers.image.title' ${DKF_RUNTIME} | cut -d\" -f2))
IMG_WORKER ?= $(shell (grep 'org.opencontainers.image.title' ${DKF_WORKER} | cut -d\" -f2))

# ---(registry)------------------------------------------------

REGISTRY_HOST := svsi680reg.azurecr.io

# ---(tag)------------------------------------------------

BRANCH_NAME := $(shell (cd ${MAKE_DIR} && git rev-parse --abbrev-ref HEAD))
COMMIT_HASH := $(shell (cd ${MAKE_DIR} && git rev-parse HEAD))
IMAGE_REVISION ?= $(COMMIT_HASH)

# @see: https://github.com/kubeflow/kubeflow/blob/master/components/example-notebook-servers/jupyter/Makefile

GIT_COMMIT     := $(shell git rev-parse HEAD)
GIT_TREE_STATE := $(shell test -n "`git status --porcelain`" && echo "-dirty" || echo "")

REGISTRY ?= $(REGISTRY_HOST)/ubdems
TAG      ?= sha-$(GIT_COMMIT)$(GIT_TREE_STATE)
TAG      ?= "latest"

# IMAGE_NAME := jupyter

# BASE_IMAGE         := $(REGISTRY)/base:$(TAG)
# BASE_IMAGE_FOLDERS := base




# ---(project)------------------------------------------------

ID_PROJECT_DIR ?= "$(notdir ${ROOT_DIR})"
ID_PROJECT ?= $(shell echo "${ID_PROJECT_DIR}" | perl -pe 's/(.*?\.)?([^+]+)\+?(.*)$$/$$2/' )
ID_PACKAGE ?= $(shell grep '^Package:' ${ROOT_DIR}/DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')

ID_PATH ?= $(shell (grep 'it.unimib.datalab.path' ${DKF_WORKER} | tr '/' '.' | cut -d\" -f2))
ID_PARENT ?= $(shell (grep 'it.unimib.datalab.path' ${DKF_WORKER} | cut -d\" -f2 | perl -pe 's{.*/([^\/]+)\/([^\/]+)$$}{$$1}'))
#ID_PARENT ?= $(shell git remote show  origin | grep 'Fetch URL' | cut -d ':' -f3 | perl -pe 's{.*/([^\/]+)\/([^\/]+)\.git}{$$1}' )
#ID_USER ?= $(shell case "${ID_PARENT}" in ('ds-labs') echo 'ubdems';; ('') echo 'ubdems.misc';; (*)  echo "$${ID_PARENT}";; esac )
ID_USER ?= $(shell (grep 'org.opencontainers.image.vendor' ${DKF_WORKER} | cut -d\" -f2))

RG_USER ?= "${ID_USER}"
NS_USER ?= "${RG_USER}"

RG_INTERNAL ?= "${REGISTRY_HOST}"

NS_PRIVATE ?= "dslab/u/${NS_USER}"
NS_PUBLIC ?= "${RG_USER}"

RG_LOCAL ?= "localhost"
RG_PRIVATE ?= "${RG_INTERNAL}"
RG_PUBLIC ?= "docker.io"

PRC_RUNTIME ?= "run-${ID_PROJECT}"
PRC_WORKER ?= "wrk-${ID_PROJECT}"


# ---(PYTHON)------------------------------------------------

X_PY_PYENV_VERSION ?= $(shell (cd ${ROOT_DIR} && cat .python-version))
X_PY_RUN ?= poetry run

# ---(runtime)------------------------------------------------

RUN_PORT_A_INT ?= 8888
RUN_PORT_A_EXT ?= 8888
#RUN_PORT_A_EXT ?= 28888
RUN_PORT_B_INT ?= 8787
RUN_PORT_B_EXT ?= 28787
RUN_PORT_C_INT ?= 8686
RUN_PORT_C_EXT ?= 28686
RUN_PORT_D_INT ?= 8080
RUN_PORT_D_EXT ?= 28080
RUN_USER_UID = 0
RUN_USER_GID = 0
RUN_USER_NAME = root
RUN_USER_HOME = /root


# ---(paths)------------------------------------------------

HOME_DIR ?= ${ROOT_DIR}/home/user
LOGS_DIR ?= ${ROOT_DIR}/logs
LOGB_DIR ?= ${ROOT_DIR}/logs/_build_/logs-${E_BUILD_TS}
TEMP_DIR ?= ${ROOT_DIR}/temp

BUILD_DIRS = ${TEMP_DIR} ${LOGS_DIR} ${LOGB_DIR} ${HOME_DIR} 
CLEAN_DIRS = ${TEMP_DIR}

# ---(progs)------------------------------------------------

ifeq (${USE_DOCKER},1)
DOCKER_MODE := true
else
PODMAN_MODE := true
endif

ifdef DOCKER_MODE
DOCKER := docker
DOCKER_BUILD_OPTIONS := 
DOCKER_BUILD_PULL := --pull
DOCKER_RUNTIME_OPTIONS := 
endif

ifdef PODMAN_MODE
DOCKER := podman
#DOCKER_BUILD_OPTIONS := --rm --squash
DOCKER_BUILD_OPTIONS := --rm
DOCKER_BUILD_PULL := --pull


DOCKER_NVIDIA_TOOLKIT_CTK := /etc/cdi/nvidia.yaml

ifneq ("$(wildcard $(DOCKER_NVIDIA_TOOLKIT_CTK))","")
    DOCKER_NVIDIA_CTK_OPTIONS = \
           --security-opt label=type:nvidia_container_t  \
	   --device nvidia.com/gpu=all \

#          --runtime nvidia --gpus=all \
#          --security-opt=label=disable \
#          --security-opt=no-new-privileges --cap-drop=ALL \  #rstudio compatibility

else
    DOCKER_NVIDIA_CTK_OPTIONS =
endif

DOCKER_NVIDIA_TOOLKIT_OCI := /usr/share/containers/oci/hooks.d/oci-nvidia-hook.json
ifneq ("$(wildcard $(DOCKER_NVIDIA_TOOLKIT_OCI))","")
    DOCKER_NVIDIA_OCI_OPTIONS = \
           --hooks-dir=/usr/share/containers/oci/hooks.d/ \

else
    DOCKER_NVIDIA_OCI_OPTIONS =
endif

DOCKER_NVIDIA_OPTIONS := $(DOCKER_NVIDIA_CTK_OPTIONS) $(DOCKER_NVIDIA_OCI_OPTIONS)


#DOCKER_RUNTIME_OPTIONS := --ulimit=host --group-add dsdata
#DOCKER_RUNTIME_OPTIONS := --ulimit=host --group-add keep-groups --subgidname=dsuser
DOCKER_RUNTIME_OPTIONS := --ulimit=host --group-add keep-groups $(DOCKER_NVIDIA_OPTIONS) $(DOCKER_ARGS)
#DOCKER_RUNTIME_OPTIONS := --ulimit=host --annotation run.oci.keep_original_groups=1 
endif

# ---(setup)------------------------------------------------

SETUP_EXTRA_RUNTIME_OPTIONS := 
SETUP_DEFAULT_RUNTIME_OPTIONS := $(SETUP_EXTRA_RUNTIME_OPTIONS) 
SETUP_INSTALL_RUNTIME_OPTIONS := $(SETUP_DEFAULT_RUNTIME_OPTIONS) --all
SETUP_UPGRADE_RUNTIME_OPTIONS := $(SETUP_DEFAULT_RUNTIME_OPTIONS) --all --upgrade
SETUP_CLEAR_RUNTIME_OPTIONS   := $(SETUP_DEFAULT_RUNTIME_OPTIONS) --clear
SETUP_STATUS_RUNTIME_OPTIONS  := $(SETUP_DEFAULT_RUNTIME_OPTIONS) --status

RUNTIME_SETUP_OPTS := $(SETUP_INSTALL_RUNTIME_OPTIONS)
RUNTIME_UPGRADE_OPTS := $(SETUP_UPGRADE_RUNTIME_OPTIONS)
RUNTIME_CLEAR_OPTS := $(SETUP_CLEAR_RUNTIME_OPTIONS)
RUNTIME_STATUS_OPTS := $(SETUP_STATUS_RUNTIME_OPTIONS)

# ---(setup)------------------------------------------------

BUILD_EXTRA_RUNTIME_OPTIONS := 
BUILD_DEFAULT_RUNTIME_OPTIONS := $(BUILD_EXTRA_RUNTIME_OPTIONS) 
BUILD_RUNTIME_OPTIONS := $(BUILD_DEFAULT_RUNTIME_OPTIONS)

RUNTIME_BUILD_OPTS := $(BUILD_RUNTIME_OPTIONS)


# ---(rscript)------------------------------------------------

RSCRIPT_EXTRA_RUNTIME_OPTIONS := 
RSCRIPT_DEFAULT_RUNTIME_OPTIONS := $(RSCRIPT_EXTRA_RUNTIME_OPTIONS) 
RSCRIPT_RUNTIME_OPTIONS := $(RSCRIPT_DEFAULT_RUNTIME_OPTIONS)

RUNTIME_RSCRIPT_OPTS := $(RSCRIPT_RUNTIME_OPTIONS)


# ---(codet)------------------------------------------------

# --accept-server-license-terms
CODE_EXTRA_RUNTIME_OPTIONS := 
CODE_DEFAULT_RUNTIME_OPTIONS := $(CODE_EXTRA_RUNTIME_OPTIONS) 
CODE_RUNTIME_OPTIONS := $(CODE_DEFAULT_RUNTIME_OPTIONS)

RUNTIME_CODE_OPTS := $(CODE_RUNTIME_OPTIONS)


# ---(jupyter)------------------------------------------------

JUPYTER_EXTRA_RUNTIME_OPTIONS := 
JUPYTER_NETWORK_RUNTIME_OPTIONS := --ip=0.0.0.0 --port=8888 
JUPYTER_AUTH_RUNTIME_OPTIONS := --ServerApp.allow_remote_access=true
JUPYTER_BASE_RUNTIME_OPTIONS := --notebook-dir=notebooks --no-browser --allow-root
JUPYTER_DEFAULT_RUNTIME_OPTIONS := $(JUPYTER_BASE_RUNTIME_OPTIONS) $(JUPYTER_NETWORK_RUNTIME_OPTIONS) $(JUPYTER_AUTH_RUNTIME_OPTIONS) $(JUPYTER_EXTRA_RUNTIME_OPTIONS) 
JUPYTER_NOTEBOOK_RUNTIME_OPTIONS := notebook $(JUPYTER_DEFAULT_RUNTIME_OPTIONS)
JUPYTER_LAB_RUNTIME_OPTIONS := lab $(JUPYTER_DEFAULT_RUNTIME_OPTIONS)

RUNTIME_JUPYTER_LAB_OPTS := $(JUPYTER_LAB_RUNTIME_OPTIONS)
RUNTIME_JUPYTER_NOTEBOOK_OPTS := $(JUPYTER_NOTEBOOK_RUNTIME_OPTIONS)

# ---(rstudio)------------------------------------------------

RSTUDIO_EXTRA_RUNTIME_OPTIONS := 
RSTUDIO_DEFAULT_RUNTIME_OPTIONS := $(RSTUDIO_EXTRA_RUNTIME_OPTIONS) 
RSTUDIO_RUNTIME_OPTIONS := $(RSTUDIO_DEFAULT_RUNTIME_OPTIONS)

RUNTIME_RSTUDIO_OPTS := $(RSTUDIO_RUNTIME_OPTIONS)

# ---(colors)------------------------------------------------

C_OFF=\033[0m
C_Green=\033[0;32m
C_IGreen=\033[0;92m
C_Blue=\033[0;34m
C_BBlue=\033[1;34m
C_UBlue=\033[4;34m
C_On_Blue=\033[44m
C_IBlue=\033[0;94m
C_On_IBlue=\033[0;104m
C_BIBlue=\033[1;94m
C_Cyan=\033[0;36m
C_BCyan=\033[1;36m
C_ICyan=\033[0;96m
C_UCyan=\033[4;36m
C_BICyan=\033[1;96m
C_BYellow=\033[1;33m
C_IYellow=\033[0;93m
C_BIYellow=\033[1;93m
C_BRed=\033[1;31m
C_IRed=\033[0;91m
C_URed=\033[4;31m
C_BIRed=\033[1;91m
C_BWhite=\033[1;37m
C_IWhite=\033[0;97m
C_UWhite=\033[4;37m
C_BIWhite=\033[1;97m



#}}} \\\

#{{{ [ MACRO.* ] /////////////////////////////////////////////////////////////////


# ---(build)------------------------------------------------

build_image = {\
}


#}}} \\\



#{{{ [ COMMANDS.* ] /////////////////////////////////////////////////////////////////

# ---(commands)------------------------------------------------

.PHONY: all init clean

# ---(generic)-------------------------------------------

.PHONY: all clean

all: # @HELP ...
all: init build

clean: # @HELP ...
clean: clean-all

# ---(run)------------------------------------------------

.PHONY: build-prepare build-setup build-update build-upgrade

build-prepare: init

build-setup:  init build-prepare build-image-runtime

build-update: init build-image-runtime

build-upgrade: COND_FORCE_PULL := 1
build-upgrade: build-update

# ---(run)------------------------------------------------

.PHONY: runtime runtime-repl runtime-cli runtime-rstudio

runtime: init run/runtime

runtime-repl: init run/r-repl

runtime-cli: init run/rscript-cli

runtime-shell: init run/shell

runtime-clear: init run/clear

runtime-upgrade: init run/upgrade

runtime-setup: init run/setup

runtime-status: init run/status

runtime-build: init run/build

runtime-command: init run/command

runtime-term: init run/term

runtime-code: init run/code-server

runtime-notebook: init run/jupyter-notebook

runtime-lab: init run/jupyter-lab

runtime-rstudio: init run/rstudio-server


# ---(worker)------------------------------------------------

worker-pack: init build-image-worker

worker-push: init wrk/push

worker-pull: init wrk/pull

worker-make: init wrk/make

worker-test: MAKE_ARGS := 'test'
worker-test: worker-make

worker-check: MAKE_ARGS := 'check'
worker-check: worker-make

worker-docs: MAKE_ARGS := 'docs'
worker-docs: worker-make

worker-build: MAKE_ARGS := 'build'
worker-build: worker-make

worker-install: MAKE_ARGS := 'install'
worker-install: worker-make

worker-exec: WORKER_SCRIPT_FILE := "./starter.sh"
worker-exec: WORKER_SCRIPT_ARGS := ${MAKE_REST}
worker-exec: init wrk/runner

worker-shell: init wrk/shell

worker-help:  help/worker



#}}} \\\



#{{{ [ SETUP.* ] /////////////////////////////////////////////////////////////////


# ---(init)------------------------------------------------

.PHONY: init%

init: $(BUILD_DIRS)

$(BUILD_DIRS):
	@mkdir -p $@

# ---(clean)------------------------------------------------

.PHONY: clean-% 

clean-dir:
	-rm -rf $(CLEAN_DIRS)
clean-all: clean-dir

#}}} \\\


#{{{ [ BUILD.* ] /////////////////////////////////////////////////////////////////


# ---(build)------------------------------------------------

.PHONY: build-image%

BUILD_OPTIONS ?= ${DOCKER_BUILD_OPTIONS}

build-image/%:
	cd $(if $(findstring $*,$(BLD_WORKER_IMAGES)),${ROOT_DIR},${MAKE_DIR}); \
	export X_BLD_DOCKERFILE="$(patsubst %,${MAKE_DIR}/dockerfiles/%.Dockerfile,$*)"; \
	export X_BLD_IMAGE_NAME="$$(grep 'org.opencontainers.image.title' $$X_BLD_DOCKERFILE | cut -d\" -f2)"; \
	: $${X_BLD_IMAGE_NAME:=$(patsubst %,${ID_USER}/${ID_PROJECT}.%,$*)}; \
	export X_BLD_LOGFILE=${LOGB_DIR}/$$(basename $${X_BLD_IMAGE_NAME}).log; \
	echo -e "# ${C_BWhite}#BUILD[*]:>> $$(date -Isec) - ${C_BYellow}$$X_BLD_IMAGE_NAME${C_BWhite} <<- $$X_BLD_DOCKERFILE ${C_OFF}" | tee -a ${LOGB_DIR}/build-summary.log; \
	$(DOCKER) build \
		-f $$X_BLD_DOCKERFILE \
		-t $$X_BLD_IMAGE_NAME \
		--build-arg Y_WORK_DIR="${RUN_USER_HOME}/${WORK_DIR}" \
		--build-arg Y_DEBUG_ENV="${Y_DEBUG_ENV:-0}" \
		--label="it.unimib.datalab.project=${ID_PROJECT}" \
		--label="it.unimib.datalab.branch=${BRANCH_NAME}" \
		--label="it.unimib.datalab.commit=${COMMIT_HASH}" \
		--label="it.unimib.datalab.package=${ID_PACKAGE}" \
		$(if ${COND_FORCE_PULL},$(if $(findstring $*,$(BLD_REMOTE_IMAGES)),${DOCKER_BUILD_PULL},)) \
		$(BUILD_OPTIONS) \
		. 2>&1 | tee -a $$X_BLD_LOGFILE; \
		RC=$${PIPESTATUS[0]} ; \
	echo -e "# ${C_BWhite}#BUILD($$RC):<< $$(date -Isec) - ${C_BYellow}$$X_BLD_IMAGE_NAME${C_BWhite} <<- $$X_BLD_DOCKERFILE ${C_OFF}" | tee -a ${LOGB_DIR}/build-summary.log; \
	exit $$RC

# . 2>&1 | tee -a $$X_BLD_LOGFILE ; \


build-image-runtime: $(foreach I, $(BLD_RUNTIME_IMAGES), build-image/$(I))
build-image-worker: $(foreach I, $(BLD_WORKER_IMAGES), build-image/$(I))

build-image-all: build-image-runtime build-image-worker

build-image/anchor:
build-image/cuda: build-image/anchor
build-image/base: build-image/cuda
build-image/${BLD_RUNTIME}: build-image/base
build-image/${BLD_WORKER}: build-image/${BLD_RUNTIME}

#}}} \\\


#{{{ [ RUNTIME.* ] /////////////////////////////////////////////////////////////////


.PHONY: run/%

# ---(bare)------------------------------------------------

run/shell:
	@echo "CLI: shell ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); set -x; \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_A_EXT}:${RUN_PORT_A_INT} \
		-p ${RUN_PORT_B_EXT}:${RUN_PORT_B_INT} \
		-p ${RUN_PORT_C_EXT}:${RUN_PORT_C_INT} \
		-p ${RUN_PORT_D_EXT}:${RUN_PORT_D_INT} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		-ti  \
		--name  \
		${PRC_RUNTIME}.sh-$$PPID \
		${IMG_RUNTIME} \
		'/bin/bash' ${RUNTIME_RSCRIPT_OPTS} ${RUNTIME_ARGS}


run/status:
	@echo "CLI: status ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e X_AUTO_ENV=0  \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		-e REV_ID_PROJECT=${ID_PROJECT}  \
		-e REV_ID_PACKAGE=${ID_PACKAGE}  \
		-e REV_BRANCH_NAME=${BRANCH_NAME}  \
		-e REV_COMMIT_HASH=${COMMIT_HASH}  \
		-e REV_IMAGE_REVISION=${IMAGE_REVISION}  \
		-e REV_GIT_COMMIT=${GIT_COMMIT}  \
		-e REV_GIT_TREE_STATE=${GIT_TREE_STATE}  \
		-e REV_REGISTRY=${REGISTRY}  \
		-e REV_TAG=${TAG}  \
		-ti  \
		--name  \
		${PRC_RUNTIME}.status-$$PPID \
		${IMG_RUNTIME} \
		'./setup.sh' ${RUNTIME_STATUS_OPTS} ${RUNTIME_ARGS}


run/setup:
	@echo "CLI: setup ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e X_AUTO_ENV=0  \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		-ti  \
		--name  \
		${PRC_RUNTIME}.setup-$$PPID \
		${IMG_RUNTIME} \
		'./setup.sh' ${RUNTIME_SETUP_OPTS} ${RUNTIME_ARGS}

run/upgrade:
	@echo "CLI: upgrade ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e X_AUTO_ENV=0  \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		-ti  \
		--name  \
		${PRC_RUNTIME}.setup-$$PPID \
		${IMG_RUNTIME} \
		'./setup.sh' ${RUNTIME_UPGRADE_OPTS} ${RUNTIME_ARGS}

run/clear:
	@echo "CLI: clear ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e X_AUTO_ENV=0  \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		-ti  \
		--name  \
		${PRC_RUNTIME}.setup-$$PPID \
		${IMG_RUNTIME} \
		'./setup.sh' ${RUNTIME_CLEAR_OPTS} ${RUNTIME_ARGS}


# ---(attach)----------------------------------------------

run/term:
        #@echo "CLI: term ${RUNTIME_ARGS}"
	$(DOCKER)  exec \
		-ti  \
		$(shell ${DOCKER} ps | grep ${IMG_RUNTIME} | cut -d' ' -f1 ) \
		'/bin/bash' ${RUNTIME_RSCRIPT_OPTS} ${RUNTIME_ARGS}


# ---(venv)------------------------------------------------

run/r-repl:
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		-ti  \
		--name  \
		${PRC_RUNTIME}.r-$$PPID \
		${IMG_RUNTIME} \
		${X_PY_RUN} \
		'/usr/local/bin/R' ${RUNTIME_R_OPTS} ${RUNTIME_ARGS}

run/rscript-cli:
	@echo "CLI: Rscript ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		-ti  \
		--name  \
		${PRC_RUNTIME}.rs-$$PPID \
		${IMG_RUNTIME} \
		${X_PY_RUN} \
		'/usr/local/bin/Rscript' ${RUNTIME_RSCRIPT_OPTS} ${RUNTIME_ARGS}

run/build:
	@echo "CLI: build ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		-ti  \
		--name  \
		${PRC_RUNTIME}.build-$$PPID \
		${IMG_RUNTIME} \
		${X_PY_RUN} \
		'./build.sh' ${RUNTIME_BUILD_OPTS} ${RUNTIME_ARGS}

run/command:
        #@echo "CLI: command ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		--name  \
		${PRC_RUNTIME}.do-$$PPID \
		${IMG_RUNTIME} \
		${X_PY_RUN} \
		${RUNTIME_ARGS} ${RUNTIME_RSCRIPT_OPTS}

run/code-server:
	@echo "CODE: server ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_C_EXT}:${RUN_PORT_C_INT} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		--name  \
		${PRC_RUNTIME}.code-$$PPID \
		${IMG_RUNTIME} \
		${X_PY_RUN} \
		'code-server' ${RUNTIME_CODE_OPTS} ${RUNTIME_ARGS}


run/jupyter-lab:
	@echo "JUPYTER: lab ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_A_EXT}:${RUN_PORT_A_INT} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		--name  \
		${PRC_RUNTIME}.lab-$$PPID \
		${IMG_RUNTIME} \
		'jupyter' ${RUNTIME_JUPYTER_LAB_OPTS} ${RUNTIME_ARGS}


run/jupyter-notebook:
	@echo "JUPYTER: notebook ${RUNTIME_ARGS}"
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_A_EXT}:${RUN_PORT_A_INT} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		--name  \
		${PRC_RUNTIME}.note-$$PPID \
		${IMG_RUNTIME} \
		${X_PY_RUN} \
		'jupyter' ${RUNTIME_JUPYTER_NOTEBOOK_OPTS} ${RUNTIME_ARGS}


run/rstudio-server:
	@echo "======================"
	@echo "=== rstudio-server ==="
	@echo "======================"
	@echo "USER: ${RUN_USER_NAME}"
	@echo "PASS: <user-pass>"
	@echo ""
	@echo "URL: http://localhost:${RUN_PORT_B_EXT}"
	@echo ""
	@echo "View:"
	@echo ""
	@echo " X2Go:      chromium-browser http://localhost:${RUN_PORT_B_EXT}"
	@echo " nomachine: firefox          http://localhost:${RUN_PORT_B_EXT}"
	@echo ""
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_B_EXT}:${RUN_PORT_B_INT} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e RUNROOTLESS=true \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e X_DEBUG="${X_DEBUG:-0}" \
		-e X_DEBUG_ENV="${X_DEBUG_ENV:-0}" \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		--name  \
		${PRC_RUNTIME}.rstudio-$$PPID \
		${IMG_RUNTIME} \
		'/init' ${RUNTIME_RSTUDIO_OPTS} ${RUNTIME_ARGS}

run/runtime: run/rstudio-server


#}}} \\\



#{{{ [ WORKER.* ] /////////////////////////////////////////////////////////////////


# ---(build)------------------------------------------------

.PHONY: wrk/%

wrk/make:
	@echo "WORKER: make -- ${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}"
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_A_EXT}:${RUN_PORT_A_INT} \
		-p ${RUN_PORT_B_EXT}:${RUN_PORT_B_INT} \
		-p ${RUN_PORT_C_EXT}:${RUN_PORT_C_INT} \
		-p ${RUN_PORT_D_EXT}:${RUN_PORT_D_INT} \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-w ${WORKER_DIR}  \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		--name  \
		${PRC_WORKER}.make-$$PPID \
		${IMG_WORKER} \
		'make' ${WORKER_MAKE_OPTS} ${MAKE_ARGS}

wrk/build:
	@echo "WORKER: build.sh -- ${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}"
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_A_EXT}:${RUN_PORT_A_INT} \
		-p ${RUN_PORT_B_EXT}:${RUN_PORT_B_INT} \
		-p ${RUN_PORT_C_EXT}:${RUN_PORT_C_INT} \
		-p ${RUN_PORT_D_EXT}:${RUN_PORT_D_INT} \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-w ${WORKER_DIR}  \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		--name  \
		${PRC_WORKER}.build-$$PPID \
		${IMG_WORKER} \
		'./build.sh' ${WORKER_MAKE_OPTS} ${MAKE_ARGS}

wrk/runner:
	@echo "WORKER: exec -- ${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}"
	echo -e "# ${C_BWhite}#WORKER[*]:>> $$(date -Isec) - exec --  ${C_BYellow}${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}${C_BWhite} ${C_OFF}"; \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_A_EXT}:${RUN_PORT_A_INT} \
		-p ${RUN_PORT_B_EXT}:${RUN_PORT_B_INT} \
		-p ${RUN_PORT_C_EXT}:${RUN_PORT_C_INT} \
		-p ${RUN_PORT_D_EXT}:${RUN_PORT_D_INT} \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-w ${WORKER_DIR}  \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		--name  \
		${PRC_WORKER}.run-$$PPID \
		${IMG_WORKER} \
		${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS} ;\
	echo -e "# ${C_BWhite}#WORKER($$?):<< $$(date -Isec) - exec --  ${C_BYellow}${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}${C_BWhite} ${C_OFF}"

wrk/shell:
	@echo "WORKER: shell -- ${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}"
	$(DOCKER)  run \
		--rm \
		-it \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_A_EXT}:${RUN_PORT_A_INT} \
		-p ${RUN_PORT_B_EXT}:${RUN_PORT_B_INT} \
		-p ${RUN_PORT_C_EXT}:${RUN_PORT_C_INT} \
		-p ${RUN_PORT_D_EXT}:${RUN_PORT_D_INT} \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-w ${WORKER_DIR}  \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		-e PYENV_VERSION=${X_PY_PYENV_VERSION}  \
		--name  \
		${PRC_WORKER}.sh-$$PPID \
		${IMG_WORKER} \
		'bash' ${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}


#}}} \\\



#{{{ [ UTILS.* ] /////////////////////////////////////////////////////////////////

# ---(debug)------------------------------------------------

.PHONY: print-%

# Display the value.
# ex. $ make print-REPORT_SOURCE_DIR
# ex. $ make print-IMAGE_REVISION
print-%:
	@echo $* = $($*)

# ---(help)------------------------------------------------

.PHONY: help

help: # @HELP prints this message
help:
	@echo "NOTE: Use BUILDARCH/BUILDOS variables to override OS/ARCH"
	@echo
	@echo "VARIABLES:"
	@echo "  BINS = $(BINS)"
	@echo "  OS = $(OS)"
	@echo "  ARCH = $(ARCH)"
	@echo "  REGISTRY = $(REGISTRY)"
	@echo "  HOSTARCH = $(HOSTARCH)"
	@echo
	@echo "TARGETS:"
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST)    \
	    | awk '                                   \
	        BEGIN {FS = ": *# *@HELP"};           \
	        { printf "  %-30s %s\n", $$1, $$2 };  \
	    '



#}}} \\\
# vim: set foldmethod=marker :
