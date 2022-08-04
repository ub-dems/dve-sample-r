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

  rstudio (default): runs rstudio-server bound on port 28787
  repl             : runs interactive R console
  cli ...          : runs Rscript with arguments
  build ...        : runs ./build.sh with arguments inside runtime
  shell            : runs interactive shell prompt
  bash args,...    : runs shell with args,...
  term             : attach interactive shell to running runtime


Target aliases:

   rstudio => ide, RStudio
   repl    => r, R
   cli     => rscript, Rscript
   build   => bld, build.sh
   shell   => sh, prompt
   bash    => do, command
   term    => in, attach


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


Shell Prompt
------------

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
    
    : ${command:=${1:-'rstudio'}}

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

