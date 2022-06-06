#!/bin/bash

#{{{ [ OPTIONS ] /////////////////////////////////////////////////////////////////

# ---(logging)------------------------------------------------

: ${LOG_ACTIVE="DEBUG"}
: ${X_ASK:="0"}

# ---(user)------------------------------------------------

: ${PAGER:="less"}

# --------------------------------------------------------------
#}}} \\\
#{{{ [ UTILS ] /////////////////////////////////////////////////////////////////

# ---(colors)------------------------------------------------
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
C_BWhite='\033[1;37m'
C_IWhite='\033[0;97m'
C_UWhite='\033[4;37m'
C_BIWhite='\033[1;97m'

# ---(logs)------------------------------------------------

CLOG=""
LCTX="-"
LOG_LOGGER="$(basename $0 .sh)"
LOG_LEVEL=""


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
    local lhost
    local luser
    lcat="$LOG_LOGGER"
    llev=$(printf '%-5s' ${LOG_LEVEL:-'LOG'})
    luser="${USER}"
    lhost="${HOSTNAME:-$(hostname)}"
    lwho=$(printf '%s@%s' ${luser} ${lhost})
    mess="${C_BICyan}$(date '+%Y-%m-%d %H:%M:%S %s') ${C_OFF}${CLOG}| $lwho | $lcat | $llev | ${LCTX} | $$ | $* ${C_OFF}"
    case "$LOG_LEVEL" in
        OFF*)  LOG_NLEVEL=0;;
        FATAL) LOG_NLEVEL=1;;
        ERROR) LOG_NLEVEL=2;;
        WARN*) LOG_NLEVEL=3;;
        INFO*) LOG_NLEVEL=4;;
        DEBUG) LOG_NLEVEL=5;;
        TRACE) LOG_NLEVEL=6;;
        ALL*)  LOG_NLEVEL=9;;
        *)     LOG_NLEVEL=9;;
    esac
    case "$LOG_ACTIVE" in
        OFF*)  LOG_NACTIVE=0;;
        FATAL) LOG_NACTIVE=1;;
        ERROR) LOG_NACTIVE=2;;
        WARN*) LOG_NACTIVE=3;;
        INFO*) LOG_NACTIVE=4;;
        DEBUG) LOG_NACTIVE=5;;
        TRACE) LOG_NACTIVE=6;;
        ALL*)  LOG_NACTIVE=9;;
        *)     LOG_NACTIVE=9;;
    esac

    if [ "$LOG_NLEVEL" -gt "$LOG_NACTIVE" ]; then
        return
    fi
    
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
#}}} \\\
