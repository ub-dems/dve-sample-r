#!/bin/bash

E_ROOT_DIR="$(dirname $0)"
#E_DOCKER_DIR="${E_ROOT_DIR}/docker/r-images"
E_MAKE_FILE="${E_ROOT_DIR}/Makefile"

. $(dirname $0)/functions.sh

# --------------------------------------------------------------
#}}} \\\



run_make() {
   make -f ${E_MAKE_FILE} $@
   rc=$?
   return $rc
}

run_self() {
   $0 $@
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
    run_self $@
    info "< exec $@ (rc: $rc)"

}

do_list() {
    info "> BUILD $@ -- ${E_MAKE_FILE}"
    cmds=("$@")
    for cmd in "${cmds[@]}";
    do
        do_self $cmd
        rc=$?
        [ $rc ] || die "exec cmd: $cmd failed! (rc=$rc)"
    done
    info "< BUILD $@ (rc: $rc)"

}



exit_usage() {

cat <<EOF    

usage $0 target[,target,target ...]

where "target" is one of:

$(run_make help/base | perl -ne 'print if /^TARGETS:/../EOF/' | sed '1d')


CONTAINERS (podman)
-------------------

$(run_make help/build | perl -ne 'print if /^TARGETS:/../EOF/' | sed '1d')


CUSTOMIZATION (once)
--------------------

$(run_make help/custom | perl -ne 'print if /^TARGETS:/../EOF/' | sed '1d')

EOF




exit 1

}


if [ $# = '0' ]; then
    exit_usage
fi

case "$1" in
    help|--help)
        exit_usage
        ;;
    *) ;;
esac
        

commands=(${1//,/ })

case "${#commands[@]}" in
    0)
        exit_usage
        ;;
    1)
        do_make $@
        ;;
    *)
        do_list "${commands[@]}"
        ;;
esac    

exit $rc

# vim: set foldmethod=marker :
