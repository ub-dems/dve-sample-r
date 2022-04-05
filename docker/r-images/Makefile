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


# ---(project)------------------------------------------------

ID_PROJECT ?= "$(notdir ${ROOT_DIR})"

RG_USER ?= "${USER}"
NS_USER ?= "${RG_USER}"

RG_INTERNAL ?= "${REGISTRY_HOST}"

NS_PRIVATE ?= "dslab/u/${NS_USER}"
NS_PUBLIC ?= "ubdems"

RG_LOCAL ?= "localhost"
RG_PRIVATE ?= "${RG_INTERNAL}"
RG_PUBLIC ?= "docker.io"


BRANCH_NAME := $(shell (cd ${MAKE_DIR} && git rev-parse --abbrev-ref HEAD))
COMMIT_HASH := $(shell (cd ${MAKE_DIR} && git rev-parse HEAD))
IMAGE_REVISION ?= $(COMMIT_HASH)


TAG ?= "latest"

# ---(modules)------------------------------------------------

BLD_RUNTIME ?= runtime
BLD_WORKER ?= worker
BLD_REMOTE_IMAGES ?= anchor
BLD_RUNTIME_IMAGES ?= ${BLD_REMOTE_IMAGES} base ${BLD_RUNTIME}
BLD_WORKER_IMAGES ?= ${BLD_WORKER}
BLD_ALL_IMAGES ?= ${BLD_RUNTIME_IMAGES} ${BLD_WORKER_IMAGES}

IMG_RUNTIME ?= ${ID_PROJECT}.${BLD_RUNTIME}

# ---(runtime)------------------------------------------------

RUN_PORT_INT = 8787
RUN_PORT_EXT = 28787
RUN_USER_UID = 0
RUN_USER_GID = 0
RUN_USER_NAME = root
RUN_USER_HOME = /root

# ---(paths)------------------------------------------------

LOGS_DIR ?= ${ROOT_DIR}/logs
TEMP_DIR ?= ${ROOT_DIR}/temp

BUILD_DIRS = ${TEMP_DIR} ${LOGS_DIR}
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
DOCKER_RUNTIME_OPTIONS := --ulimit=host
endif

#}}} \\\

#{{{ [ MACRO.* ] /////////////////////////////////////////////////////////////////


# ---(build)------------------------------------------------

build_image = {\
}


#}}} \\\



#{{{ [ COMMANDS.* ] /////////////////////////////////////////////////////////////////

# ---(commands)------------------------------------------------

.PHONY: all clean setup test pack build shell server push pull update 

all: # @HELP ...
all: init 

clean: # @HELP ...
clean: clean-all

prepare: # @HELP ...
prepare: init

setup: # @HELP ...
setup:  init prepare build-image-runtime

update: # @HELP ...
update: init build-image-runtime

upgrade: # @HELP ...
upgrade: COND_FORCE_PULL := 1
upgrade: update

runtime: # @HELP ...
runtime: init run/runtime

runtime-repl: # @HELP ...
runtime-repl: init run/r-repl

runtime-cli: # @HELP ...
runtime-cli: init run/rscript-cli

runtime-rstudio: # @HELP ...
runtime-rstudio: init run/rstudio-server

shell: # @HELP ...
shell:

pack: # @HELP ...
pack: init build-image-worker

build: # @HELP ...
build: init build-image-all

test: # @HELP ...
test:

push: # @HELP ...
push:

pull: # @HELP ...
pull:


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
	$(DOCKER) build \
		-f $(patsubst %,${MAKE_DIR}/dockerfiles/%.Dockerfile,$*) \
		-t $(patsubst %,${ID_PROJECT}.%,$*) \
		$(if ${COND_FORCE_PULL},$(if $(findstring $*,$(BLD_REMOTE_IMAGES)),${DOCKER_BUILD_PULL},)) \
		$(BUILD_OPTIONS) \
		.
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
		-p ${RUN_PORT_EXT}:${RUN_PORT_INT} \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
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
		-p ${RUN_PORT_EXT}:${RUN_PORT_INT} \
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-w ${RUN_USER_HOME}/${WORK_DIR}  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		${IMG_RUNTIME} '/usr/local/bin/Rscript' ${RUNTIME_RSCRIPT_OPTS} ${RUNTIME_ARGS}

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
		-v ~/work:${RUN_USER_HOME}/work:Z  \
		-v ~/data:${RUN_USER_HOME}/data:Z  \
		-e PASSWORD=$$_passw_ \
		-e USER=${RUN_USER_NAME} \
		-e USERID=${RUN_USER_UID} \
		-e GROUPID=${RUN_USER_GID} \
		-e ROOT=true  \
		${IMG_RUNTIME} ${RUNTIME_ARGS}

run/runtime: run/rstudio-server


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
