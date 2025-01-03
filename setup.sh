#!/bin/bash
##{{{
# setup.sh: project virtual environment
# =============================================
#
#  (in-container) project virtual environment manager
#
#  "./setup.sh help" for usage info
#

E_ROOT_DIR="$(dirname $0)"
E_SETUP_DIR="${E_ROOT_DIR}/docker/r-images/scripts/setup"
E_SETUP_RUNNER="${E_SETUP_DIR}/setup_ubs-all.sh"

export PATH=$E_SETUP_DIR:$PATH

. $(dirname $0)/functions.sh

#}}} \\\    
#{{{ [ DOCS ] /////////////////////////////////////////////////////////////////

# ---(usage)------------------------------------------------

exit_usage() {

cat <<EOF | $PAGER   

out-container usage

  ./runtime.sh setup   : for virtual environment installation
  ./runtime.sh upgrade : for virtual environment additional resolution
  ./runtime.sh status  : for virtual environment status reporting


in-container usage $0 --status|--all [--upgrade]

runs virtual enviroment install scripts inside runtime container

if '--upgrade' options, dependency upgrade is forced by removing

  ./poetry.lock : to force python dependency upgrade, with 'pyproject.toml' specification
  ./renv.lock   : to force R dependency upgrade, with 'DESCRIPTION' project specification


CONFIGURATION
==============

see ./docker/r-images/build.conf for setup scripts options
see ./docker/r-images/scripts/setup/*.sh for executable setup scripts


ENVIRONMENNT
============

- E_ROOT_DIR: project base directory (working directory)
- E_SETUP_DIR: executable scripts directory ( $E_ROOT_DIR'/exec' )
- E_SETUP_ARGS: script arguments

- PATH: $E_SETUP_DIR:$PATH


EOF

exit 1

}


#}}} \\\
#{{{ [ MAIN ] /////////////////////////////////////////////////////////////////

# ---(exec)------------------------------------------------

run_exec() {

    #set -x
    cd $E_ROOT_DIR
    
   ${E_SETUP_WRAP} ${E_SETUP_ARGS}
   rc=$?
   #set +x
   return $rc
}

do_exec() {
    info "> exec::($E_SETUP_NAME, $E_SETUP_ARGS) -- ${E_SETUP_FILE}"
    run_exec 
    info "< exec::($E_SETUP_NAME, $E_SETUP_ARGS) (rc: $rc)"
}


# ---(args)------------------------------------------------

parse_args_start() {

    args="$@"
    log ">(args.run):" "$args"

    cmds=""

    while [ $# -gt 0 ]; do
        case "$1" in
            --help|-h)
                exit_usage $@
                ;;
            -x|--exec)
                E_SETUP_RUNNER="$2"
                shift
                ;;
            *)
                cmds="$cmds $1" 
                ;;
        esac
        shift
    done

: ${E_SETUP_WRAP:="$E_SETUP_RUNNER"}
: ${E_SETUP_ARGS:=$cmds}
export     

    log "<(args.sub):" "cmds: $cmds"
            
    
}




# ---(main)------------------------------------------------

main() {

    parse_args_start $@
    
    do_exec $@
    exit $rc

}

main $@

#}}} \\\





