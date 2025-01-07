#!/bin/bash
##{{{
# runtime.sh: interface to runtime environment
# ============================================= 
#
#  custom R, Rscript, RStudio (server) process control
#
#  "./runtime.sh help" for usage info
#

E_ROOT_DIR="$(dirname $0)"
E_MAKE_FILE="${E_ROOT_DIR}/Makefile"
#E_DOCKER_DIR="${E_ROOT_DIR}/docker/r-images"
#E_MAKE_FILE="${E_DOCKER_DIR}/Makefile"

set -a

: ${E_CONF_DIR:="${E_ROOT_DIR}/docker/r-images"}
: ${E_CONF_FILE:="${E_CONF_DIR}/runtime.conf"}
: ${E_META_FILE:="${E_CONF_DIR}/project.conf"}

[ -r "${E_META_FILE}" ] && source "${E_META_FILE}" || true
[ -r "${E_CONF_FILE}" ] && source "${E_CONF_FILE}" || true


: ${X_PRJ_KIND:="${X_DEF_KIND}"}

if [ "${X_PRJ_KIND}" = 'auto' ]; then
    if [ -n "$(shopt -s nullglob; echo *.Rproj)" ]; then
        X_RUN_KIND='R'
    else    
        X_RUN_KIND='P'
    fi
else    
   X_RUN_KIND="${X_PRJ_KIND}"
fi    
    
case "$X_RUN_KIND" in
    R) X_DEF_RUN_COMMAND="$X_DEF_RUN_R_COMMAND" ;;
    *) X_DEF_RUN_COMMAND="$X_DEF_RUN_P_COMMAND" ;;
esac    
        
: ${X_RUN_COMMAND:="${X_DEF_RUN_COMMAND}"}

: ${X_DEBUG:="${X_DEF_DEBUG}"}
: ${X_DEBUG_ENV:="${X_DEF_DEBUG_ENV}"}

set +a

. $(dirname $0)/functions.sh

#}}} \\\    
#{{{ [ DOCS ] /////////////////////////////////////////////////////////////////

# ---(usage)------------------------------------------------

exit_usage() {
export LESS="-Psman runtime.sh  (press h for help or q to quit)"
cat <<EOF | $PAGER

usage $0 [target] [args, ...]

runs commands in r runtime

where "target" is

  rstudio          : runs rstudio-server bound on port 28787
  jutyper          : runs jupyter lab bound on port 28888
  notebook         : runs jupyter notebook bound on port 28888
  code             : runs visual studio code server on port 28788
  repl             : runs interactive R console
  cli ...          : runs Rscript with arguments
  clear ...        : clear all virtual environmnet and packages
  upgrade ...      : runs poetry/renv lock/snapshot inside runtime
  setup ...        : runs poetry/renv install inside runtime
  status ...       : runs poetry/renv status inside runtime
  build ...        : runs ./build.sh with arguments inside runtime
  shell            : runs interactive shell prompt
  bash args,...    : runs shell with args,...
  term             : attach interactive shell to running runtime


Target aliases:

   rstudio  => ide, RStudio
   jupyter  => lab
   notebook => note
   code     => edit
   repl     => r, R
   cli      => rscript, Rscript
   upgrade  => lock, snapshot
   clear    => zap
   setup    => lib, install
   status   => deps, show
   build    => bld, build.sh
   shell    => sh, prompt
   bash     => do, command
   term     => in, attach


EXAMPLES
========

RStudio
-------

 ./runtime.sh ide
 ./runtime.sh rstudio
 ./runtime.sh RStudio

 then (depending on connection client),

 if X2Go,   
   chromium-browser http://localhost:28787

 if nomachine,
   firefox http://localhost:28787

 if remote (with ssh port forwarding) from remote PC
   ssh -L28787:localhost:28787 user@vm 
   then open in browser: http://localhost:28787

RStudio login with user root, and default user password as password

Jupyter lab
-----------

 ./runtime.sh jupyter
 ./runtime.sh lab


Jupyter notebook
----------------

 ./runtime.sh notebook
 ./runtime.sh note


Visual Studio Code Server
-------------------------

 ./runtime.sh code
 ./runtime.sh edit


R Console
---------

 ./runtime.sh repl
 ./runtime.sh r
 ./runtime.sh R

then check 'getwd()' and exit 'q()'


R Script
---------

 ./runtime.sh cli     exec/dummy_runner.R  
 ./runtime.sh rscript exec/dummy_runner.R  
 ./runtime.sh Rscript exec/dummy_runner.R  

to run scripts from ./exec directory




=====


Build
-----

 ./runtime.sh build all
 ./runtime.sh build test
 ./runtime.sh build docs

for ./build.sh execution inside runtime container


Shell Prompt
------------

 ./runtime.sh sh
 ./runtime.sh shell
 ./runtime.sh prompt

for interactive shell prompt

Shell Command
-------------

or with command args

 ./runtime.sh do bash -c 'echo "$$(date)" ; df -h ; ip a'
 ./runtime.sh do ( inxi -F | grep -i nvidia )
 ./runtime.sh do whoami

to run execute shell commands



VIRTUAL ENVIRONMENTS
===============================

Clear
-----

 ./runtime.sh clear

for ./setup.sh (clear all) execution inside runtime container


Upgrade
-----

 ./runtime.sh upgrade

for ./setup.sh (upgrade mode) execution inside runtime container


Setup
-----

 ./runtime.sh setup

for ./setup.sh execution inside runtime container


Status
-----

 ./runtime.sh status

for ./setup.sh status reporting inside runtime container




MAPPING
=======

default volume mapping:

 ~/work => ~/work
 ~/data => ~/data

user UID/GID => root:root (0:0)

path:
  ~ := /home/$USER => ~ := /root (volatile, not shared)

workdir: 
   /root/work/../....: current project directory

EOF

exit 1

}

#}}} \\\
#{{{ [ MAIN ] /////////////////////////////////////////////////////////////////

# ---(make)------------------------------------------------

run_make() {
   make -f ${E_MAKE_FILE} $@
   rc=$?
   return $rc
}

do_make() {
    info "> make $target $@ -- ${E_MAKE_FILE}"
    export RUNTIME_ARGS="$@"
    run_make $target
    info "< make $target $@ (rc: $rc)"

}

# ---(main)------------------------------------------------

main() {
    
    target=''
    
    : ${command:=${1:-"${X_RUN_COMMAND}"}}

case "${command}" in
    repl|r|R)
        shift
        target=runtime-repl
        ;;
    cli|rscript|Rscript)
        shift
        target=runtime-cli
        ;;
    sh|shell|prompt)
        shift
        target=runtime-shell
        ;;
    bld|build|build.sh)
        shift
        target=runtime-build
        ;;
    clear|zap)
        shift
        target=runtime-clear
        ;;
    lock|snapshot|upgrade)
        shift
        target=runtime-upgrade
        ;;
    lib|install|setup)
        shift
        target=runtime-setup
        ;;
    deps|show|status)
        shift
        target=runtime-status
        ;;
    do|command)
        shift
        export LOG_ACTIVE='OFF'  
        target=runtime-command
        ;;
    in|term|attach)
        shift
        export LOG_ACTIVE='OFF'  
        target=runtime-term
        ;;
    edit|code)
        shift
        target=runtime-code
        ;;
    lab|jupyter)
        shift
        target=runtime-lab
        ;;
    edit|notebook)
        shift
        target=runtime-notebook
        ;;
    ide|rstudio|RStudio)
        shift
        target=runtime-rstudio
        ;;
    
    -?|/h|-h|--help|help)
        exit_usage
        ;;
    *)
        target="runtime-${command}"
        ;;
esac

do_make $@
exit $rc

}

main $@

#}}} \\\

