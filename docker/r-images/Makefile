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


# ---(tag)------------------------------------------------

BRANCH_NAME := $(shell (cd ${MAKE_DIR} && git rev-parse --abbrev-ref HEAD))
COMMIT_HASH := $(shell (cd ${MAKE_DIR} && git rev-parse HEAD))
IMAGE_REVISION ?= $(COMMIT_HASH)


TAG ?= "latest"

# ---(runtime)------------------------------------------------

RUN_PORT_INT = 8787
RUN_PORT_EXT = 28787
RUN_USER_UID = 0
RUN_USER_GID = 0
RUN_USER_NAME = root
RUN_USER_HOME = /root

# ---(paths)------------------------------------------------

HOME_DIR ?= ${ROOT_DIR}/home/user
LOGS_DIR ?= ${ROOT_DIR}/logs
TEMP_DIR ?= ${ROOT_DIR}/temp

BUILD_DIRS = ${TEMP_DIR} ${LOGS_DIR} ${HOME_DIR} 
CLEAN_DIRS = ${TEMP_DIR}

# ---(progs)------------------------------------------------

SHELL := /bin/bash

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
DOCKER_BUILD_OPTIONS := 
DOCKER_BUILD_PULL := --pull
#DOCKER_RUNTIME_OPTIONS := --ulimit=host --group-add dsdata
#DOCKER_RUNTIME_OPTIONS := --ulimit=host --group-add keep-groups --subgidname=dsuser
DOCKER_RUNTIME_OPTIONS := --ulimit=host --group-add keep-groups
#DOCKER_RUNTIME_OPTIONS := --ulimit=host --annotation run.oci.keep_original_groups=1 
endif

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

runtime-build: init run/build

runtime-command: init run/command

runtime-term: init run/term

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
	echo -e "# ${C_BWhite}#BUILD[*]:>> $$(date -Isec) - ${C_BYellow}$$X_BLD_IMAGE_NAME${C_BWhite} <<- $$X_BLD_DOCKERFILE ${C_OFF}"; \
	$(DOCKER) build \
		-f $$X_BLD_DOCKERFILE \
		-t $$X_BLD_IMAGE_NAME \
		--label="it.unimib.datalab.project=${ID_PROJECT}" \
		--label="it.unimib.datalab.branch=${BRANCH_NAME}" \
		--label="it.unimib.datalab.commit=${COMMIT_HASH}" \
		--label="it.unimib.datalab.package=${ID_PACKAGE}" \
		$(if ${COND_FORCE_PULL},$(if $(findstring $*,$(BLD_REMOTE_IMAGES)),${DOCKER_BUILD_PULL},)) \
		$(BUILD_OPTIONS) \
		. ; \
	echo -e "# ${C_BWhite}#BUILD($$?):<< $$(date -Isec) - ${C_BYellow}$$X_BLD_IMAGE_NAME${C_BWhite} <<- $$X_BLD_DOCKERFILE ${C_OFF}"

build-image-runtime: $(foreach I, $(BLD_RUNTIME_IMAGES), build-image/$(I))
build-image-worker: $(foreach I, $(BLD_WORKER_IMAGES), build-image/$(I))

build-image-all: build-image-runtime build-image-worker

build-image/anchor:
build-image/base: build-image/anchor
build-image/${BLD_RUNTIME}: build-image/base
build-image/${BLD_WORKER}: build-image/${BLD_RUNTIME}

#}}} \\\


#{{{ [ RUNTIME.* ] /////////////////////////////////////////////////////////////////


# ---(server)------------------------------------------------

.PHONY: run/%

run/r-repl:
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
		-ti  \
		${IMG_RUNTIME} \
		'/usr/local/bin/R' ${RUNTIME_R_OPTS} ${RUNTIME_ARGS}

run/rscript-cli:
	@echo "CLI: Rscript ${RUNTIME_ARGS}"
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
		${IMG_RUNTIME} '/usr/local/bin/Rscript' ${RUNTIME_RSCRIPT_OPTS} ${RUNTIME_ARGS}

run/shell:
	@echo "CLI: shell ${RUNTIME_ARGS}"
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
		-ti  \
		${IMG_RUNTIME} '/bin/bash' ${RUNTIME_RSCRIPT_OPTS} ${RUNTIME_ARGS}

run/build:
	@echo "CLI: build ${RUNTIME_ARGS}"
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
		-ti  \
		${IMG_RUNTIME} './build.sh' ${RUNTIME_RSCRIPT_OPTS} ${RUNTIME_ARGS}

run/command:
        #@echo "CLI: command ${RUNTIME_ARGS}"
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
		${IMG_RUNTIME} ${RUNTIME_ARGS} ${RUNTIME_RSCRIPT_OPTS}

run/term:
        #@echo "CLI: term ${RUNTIME_ARGS}"
	$(DOCKER)  exec \
		-ti  \
		$(shell ${DOCKER} ps | grep ${IMG_RUNTIME} | cut -d' ' -f1 ) \
		'/bin/bash' ${RUNTIME_RSCRIPT_OPTS} ${RUNTIME_ARGS}

run/rstudio-server:
	@echo "======================"
	@echo "=== rstudio-server ==="
	@echo "======================"
	@echo "USER: ${RUN_USER_NAME}"
	@echo "PASS: <user-pass>"
	@echo ""
	@echo "URL: http://localhost:${RUN_PORT_EXT}"
	@echo ""
	@echo "View:"
	@echo ""
	@echo " X2Go:      chromium-browser http://localhost:${RUN_PORT_EXT}"
	@echo " nomachine: firefox          http://localhost:${RUN_PORT_EXT}"
	@echo ""
	@export _passw_=$$(cat ~/.rup/*); \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-p ${RUN_PORT_EXT}:${RUN_PORT_INT} \
		-v ${HOME_DIR}:${RUN_USER_HOME}:Z  \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-v ~/data:${HOME}/data:Z  \
		-v /store/local:/store/local:Z  \
		-v /store/share:/store/share  \
		-v /user:/user  \
		-v /vol:/vol  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		${IMG_RUNTIME} ${RUNTIME_ARGS}

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
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-w ${WORKER_DIR}  \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		${IMG_WORKER} \
		'make' ${WORKER_MAKE_OPTS} ${MAKE_ARGS}

wrk/build:
	@echo "WORKER: build.sh -- ${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}"
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-w ${WORKER_DIR}  \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		${IMG_WORKER} \
		'./build.sh' ${WORKER_MAKE_OPTS} ${MAKE_ARGS}

wrk/runner:
	@echo "WORKER: exec -- ${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}"
	echo -e "# ${C_BWhite}#WORKER[*]:>> $$(date -Isec) - exec --  ${C_BYellow}${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}${C_BWhite} ${C_OFF}"; \
	$(DOCKER)  run \
		--rm \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-w ${WORKER_DIR}  \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		${IMG_WORKER} \
		${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS} ;\
	echo -e "# ${C_BWhite}#WORKER($$?):<< $$(date -Isec) - exec --  ${C_BYellow}${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}${C_BWhite} ${C_OFF}"

wrk/shell:
	@echo "WORKER: shell -- ${WORKER_SCRIPT_FILE} ${WORKER_SCRIPT_ARGS}"
	$(DOCKER)  run \
		--rm \
		-it \
		${DOCKER_RUNTIME_OPTIONS} \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-w ${WORKER_DIR}  \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
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
