##
#{{{ Makefile: project global/standard actions
#
# @see: ./notes/usage/readme.md for usage info
#
#}}} \\\


#{{{ [ VARS.* ] /////////////////////////////////////////////////////////////////



# ---(base)------------------------------------------------

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKE_DIR := $(patsubst %/,%,$(dir $(MAKEFILE_PATH)))
ROOT_DIR := $(shell (cd ${MAKE_DIR} && git rev-parse --show-toplevel))
WORK_DIR := $(patsubst ${HOME}/%,./%,${ROOT_DIR})
MAKEFILE_FOLDER := $(notdir ${MAKE_DIR})


# ---(project)------------------------------------------------

ID_PROJECT ?= "$(notdir ${ROOT_DIR})"
PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')

BRANCH_NAME := $(shell (cd ${MAKE_DIR} && git rev-parse --abbrev-ref HEAD))
COMMIT_HASH := $(shell (cd ${MAKE_DIR} && git rev-parse HEAD))


TAG ?= "latest"

# ---(IMAGES)------------------------------------------------

IMG_MAKE_DIR ?= 'docker/r-images'


# ---(paths)------------------------------------------------

LOGS_DIR ?= ${ROOT_DIR}/logs
TEMP_DIR ?= ${ROOT_DIR}/temp

BUILD_DIRS = ${TEMP_DIR} ${LOGS_DIR}
CLEAN_DIRS = ${TEMP_DIR}

# ---(progs)------------------------------------------------

SHELL := /bin/bash
RSCRIPT := Rscript


#}}} \\\

#{{{ [ CONTAINERS.* ] /////////////////////////////////////////////////////////////////

# ---(commands)------------------------------------------------

.PHONY: setup update upgrade

setup: # @HELP ...
setup:  cd ${IMG_MAKE_DIR} && $(MAKE) $@

update: # @HELP ...
update: cd ${IMG_MAKE_DIR} && $(MAKE) $@

upgrade: # @HELP ...
upgrade: cd ${IMG_MAKE_DIR} && $(MAKE) $@


#}}} \\\

#{{{ [ COMMANDS.* ] /////////////////////////////////////////////////////////////////

# ---(commands)------------------------------------------------

.PHONY: all test check docs man vignettes readme build install clean init


all: # @HELP ...
all: init check test docs install

test: # @HELP ...
test: init
	${RSCRIPT} -e 'devtools::test()'


check: # @HELP ...
check: init
	${RSCRIPT} -e 'devtools::check()'

docs: # @HELP ...
docs: man readme vignettes

man: # @HELP ...
man: init
	@mkdir -p man
	${RSCRIPT} -e "devtools::document()"

vignettes: # @HELP ...
vignettes: vignettes/*.Rmd
	${RSCRIPT} -e 'devtools::build_vignettes()'

README.md: README.Rmd
	Rscript -e 'devtools::load_all(); knitr::knit("README.Rmd")'
	sed -i.bak 's/[[:space:]]*$$//' $@
	rm -f $@.bak

readme: # @HELP ...
readme: README.md

build: # @HELP ...
build: 
	${RSCRIPT} -e 'devtools::build()'

install: # @HELP ...
install:
	${RSCRIPT} -e 'devtools::install()'

clean: # @HELP ...
	rm -f src/*.o src/*.so src/*.dll

init: # @HELP ...
	@mkdir -p ${LOGS_DIR}
	@mkdir -p ${TEMP_DIR}

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
