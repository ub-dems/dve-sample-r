#!/bin/bash
##{{{
# worker.sh: project container task control
# =========================================
#
#  conteinerized project image management and job control
#
#  "./worker.sh help" for usage info
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

cat <<EOF    

usage $0 target[,target,target ...]

where "target" is one of:

EOF

run_make help | perl -ne 'print if /^TARGETS:/../EOF/' | sed '1d'

exit 1

}

#}}} \\\
#{{{ [ MAIN ] /////////////////////////////////////////////////////////////////

# ---(make)------------------------------------------------


run_make() {
   make -f ${E_MAKE_FILE} $MAKE_OPTS "worker-$@" $MAKE_REST
   rc=$?
   return $rc
}

run_self() {
   $0 $MAKE_OPTS $@ $MAKE_REST
   rc=$?
   return $rc
}

do_make() {
    info "> make $@ -- ${E_MAKE_FILE}"
    run_make $@
    info "< make $@ (rc: $rc)"

}

do_self() {
    info "> exec $@ -- ${0}"
    export _in_self_=1
    run_self $@
    unset _in_self_
    info "< exec $@ (rc: $rc)"

}

do_list() {
    info "> BUILD $@ -- ${E_MAKE_FILE}"
    cmds=("$@")
    for cmd in "${cmds[@]}"; do
        do_self $cmd
        rc=$?
        [ $rc ] || die "exec cmd: $cmd failed! (rc=$rc)"
    done
    info "< BUILD $@ (rc: $rc)"

}


# ---(main)------------------------------------------------

main() {
    
if [ $# = '0' ]; then
    exit_usage
fi    

case "$1" in
    -?|/h|-h|--help|help)
        exit_usage
        ;;
    *)
        ;;
esac

MAKE_OPTS=""
MAKE_CMDS=""
MAKE_REST=""

args=("$@")
for arg in "${args[@]}"; do
    case $arg in
        -*) MAKE_OPTS="$MAKE_OPTS $arg" ;;
        *) if [ -z "$MAKE_CMDS" ]; then
               MAKE_CMDS="$arg"
           else
               MAKE_REST="$MAKE_REST $arg"
           fi
           ;;
    esac
done
export MAKE_OPTS
export MAKE_CMDS
export MAKE_REST


commands=(${MAKE_CMDS//,/ })
shift
if [ -n "$_in_self_" ] ; then
    : # re-enter
else    
    export MAKE_ARGS="$@"
fi    

case "${#commands[@]}" in
    0)
        exit_usage
        ;;
    1)
        do_make "${commands[0]}"
        ;;
    *)
        do_list "${commands[@]}"
        ;;
esac    

exit $rc


}

main $@

#}}} \\\


