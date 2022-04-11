#!/bin/bash

E_ROOT_DIR="$(dirname $0)"
E_DOCKER_DIR="${E_ROOT_DIR}/docker/r-images"
E_MAKE_FILE="${E_DOCKER_DIR}/Makefile"

# --------------------------------------------------------------
C_OFF='\033[0m'
C_Green='\033[0;32m'
C_IGreen='\033[0;92m'
C_Blue='\033[0;34m'
C_BBlue='\033[1;34m'
C_UBlue='\033[4;34m'
C_On_Blue='\033[44m'
C_IBlue='\033[0;94m'
C_On_IBlue='\033[0;104m'
C_BIBlue='\033[1;94m'
C_BCyan='\033[1;36m'
C_ICyan='\033[0;96m'
C_UCyan='\033[4;36m'
C_BICyan='\033[1;96m'
C_BYellow='\033[1;33m'
C_IYellow='\033[0;93m'
C_BIYellow='\033[1;93m'
C_BRed='\033[1;31m'
C_IRed='\033[0;91m'
C_URed='\033[4;31m'
C_BIRed='\033[1;91m'

CLOG=""
LCTX="-"
LOG_LEVEL=""
: ${X_ASK:="0"}

ask_exit() {
    if [ "$X_ASK" != "1" ]; then
	return 0
    fi
    printf "\n${C_BIYellow}+++ ??? $* ... [Y/n]${C_OFF}\n"
    read -t 10 z
    case "$z" in
        Y|y) return 0;;
        N|n) exit ${exit_rc:-1};;
    esac
    return 1
}
show() {
    if [ -z "${X_LOGFILE}" ]; then
        cat
    else
        cat | tee -a ${X_LOGFILE} 1>&2
    fi
}
_log() {
    local mess
    local llev
    local lwho
    llev=$(printf '%-5s' ${LOG_LEVEL:-'LOG'})
    lwho=$(printf '%s@%s' ${USER} $(hostname))
    mess="${C_BICyan}$(date '+%Y-%m-%d %H:%M:%S %s') ${C_OFF}${CLOG}| $lwho | $llev | ${LCTX} | $$ | $* ${C_OFF}"
    if [ -z "${X_LOGFILE}" ]; then
        echo -e ${mess}
    else
        echo -e ${mess} | tee -a ${X_LOGFILE} 1>&2
    fi
}
trace() { [ "${EX_TRACE}" = "1" ] && LOG_LEVEL='TRACE' CLOG="$C_Black" _log $*; }
debug() { LOG_LEVEL='DEBUG' CLOG="$C_Green"   _log $*; }
info()  { LOG_LEVEL='INFO.'  CLOG="$C_BIBlue"  _log $*; }
warn()  { LOG_LEVEL='WARN.'  CLOG="$C_BYellow" _log $*; }
error() { LOG_LEVEL='ERROR' CLOG="$C_IRed"    _log $*; }
fatal() { LOG_LEVEL='FATAL' CLOG="$C_BIRed"   _log $*; }
log()   { LOG_LEVEL='_LOG_'   CLOG="$C_BBlue"   _log $*; }
die ()  { fatal $*; ask_exit; }
fail () { fatal $@; } # halt ...
todo () { warn "#TODO: " $*; }
# --------------------------------------------------------------



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
    export _in_self_=1
    run_self $@
    unset _in_self_
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

EOF

run_make help | perl -ne 'print if /^TARGETS:/../EOF/' | sed '1d'

exit 1

}


if [ $# = '0' ]; then
    exit_usage
fi    


commands=(${1//,/ })
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

