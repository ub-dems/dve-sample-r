#!/bin/bash
##{{{
# starter.sh: project script invoker
# ==================================
#
#  project script script invoker
#
#  "./starter.sh help" for usage info
#

E_ROOT_DIR="$(dirname $0)"
E_EXEC_DIR="${E_ROOT_DIR}/exec"
E_EXEC_RUNNER="${E_EXEC_DIR}/runner.sh"

export PATH=$E_EXEC_DIR:$PATH

. $(dirname $0)/functions.sh

#}}} \\\    
#{{{ [ DOCS ] /////////////////////////////////////////////////////////////////

# ---(usage)------------------------------------------------

exit_usage() {

cat <<EOF | $PAGER   

usage $0 [-x script] [args, ...]

runs script in project

where "script" is executable shell script name, defaults to

  ./exec/runner.sh : runs default script fron project root



ENVIRONMENNT
============

- E_ROOT_DIR: project base directory (working directory)
- E_EXEC_DIR: executable scripts directory ( $E_ROOT_DIR'/exec' )
- E_EXEC_NAME: script name (defaults to 'runner.sh')
- E_EXEC_FILE: script path (defaults to $E_EXEC_DIR/$E_EXEC_NAME)
- E_EXEC_ARGS: script arguments

- PATH: $E_EXEC_DIR:$PATH


EOF

exit 1

}


#}}} \\\
#{{{ [ MAIN ] /////////////////////////////////////////////////////////////////

# ---(exec)------------------------------------------------

run_exec() {

    #set -x
    cd $E_ROOT_DIR
    
   ${E_EXEC_WRAP} ${E_EXEC_ARGS}
   rc=$?
   #set +x
   return $rc
}

do_exec() {
    info "> exec::($E_EXEC_NAME, $E_EXEC_ARGS) -- ${E_EXEC_FILE}"
    run_exec 
    info "< exec::($E_EXEC_NAME, $E_EXEC_ARGS) (rc: $rc)"
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
                E_EXEC_RUNNER="$2"
                shift
                ;;
            *)
                cmds="$cmds $1" 
                ;;
        esac
        shift
    done

: ${E_EXEC_WRAP:="$E_EXEC_RUNNER"}
: ${E_EXEC_ARGS:=$cmds}
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





