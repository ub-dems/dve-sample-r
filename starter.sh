.#!/bin/bash
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
   ${E_EXEC_FILE} ${E_EXEC_ARGS}
   rc=$?
   return $rc
}

do_exec() {
    info "> exec::($E_EXEC_NAME, $E_EXEC_ARGS) -- ${E_EXEC_FILE}"
    run_exec 
    info "< exec::($E_EXEC_NAME, $E_EXEC_ARGS) (rc: $rc)"
}

# ---(main)------------------------------------------------

main() {

    target=''

    case "$1" in
        -x)
            shift
            E_EXEC_NAME="$1"
            shift
            ;;
        -?|/h|-h|--help|help)
            exit_usage
            ;;
        *)
            ;;
    esac

    : ${E_EXEC_NAME:="runner.sh"}
    : ${E_EXEC_ARGS:=($@)}

    if [ -z "$E_EXEC_FILE" ]; then
        if [ -f "$E_EXEC_DIR/$E_EXEC_NAME" ]; then
            E_EXEC_FILE="$E_EXEC_DIR/$E_EXEC_NAME"
        else    
            E_EXEC_FILE="$E_EXEC_NAME"
        fi
    fi

    export E_EXEC_NAME
    export E_EXEC_FILE
    export E_EXEC_ARGS

    do_exec $@
    exit $rc

}

main $@

#}}} \\\





