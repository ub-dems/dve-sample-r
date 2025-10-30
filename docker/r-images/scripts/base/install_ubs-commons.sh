#!/bin/bash

##
# install_ubs-commons.sh: install common tools and libraries
#


set -e

## build ARGs
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}

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
LOG_WHO="${IMG_TYPE:-'----'}"
LOG_LEVEL=""
function _log() {

    local mess
    local llev
    lwho="$LOG_WHO"
    lcat="$LOG_LOGGER"
    llev=$(printf '%-5s' ${LOG_LEVEL:-'LOG'})
    mess="${C_IGreen}$(date '+%Y-%m-%d %H:%M:%S %s') ${C_OFF}${CLOG}| $lwho | $lcat | $llev | ${LCTX} | $$ | $* ${C_OFF}"

    echo -e ${mess}
    
}
debug() { LOG_LEVEL='DEBUG' CLOG="$C_Green"   _log $*; }
info()  { LOG_LEVEL='INFO.'  CLOG="$C_BICyan"  _log $*; }
warn()  { LOG_LEVEL='WARN.'  CLOG="$C_BYellow" _log $*; }
error() { LOG_LEVEL='ERROR' CLOG="$C_IRed"    _log $*; }
fatal() { LOG_LEVEL='FATAL' CLOG="$C_BIRed"   _log $*; }
log()   { LOG_LEVEL='_LOG_'   CLOG="$C_BBlue"   _log $*; }
die ()  { fatal $*; exit 1; }

# ---(env)------------------------------------------------
function env_dump() {

    [ "$Y_DEBUG_ENV" = 1 ] || return 0
    
    echo "+++> #ENV($0): $@"
    echo "+++: #ENV($0): set"
    set | grep '^Y_' | sort
    echo "+++: #ENV($0): env"
    env | sort
    echo "+++: #ENV($0): path"
    echo "PATH=$PATH"
    echo "+++<  #ENV($0): $@"
    
}

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

function install_commons_sys() {

    [ "$Y_BASE_COMMONS_SYS" = 1 ] || return 0
    
    apt_install \
        libgsl-dev \
        libzmq3-dev \
        default-libmysqlclient-dev \
        parallel \
        hwloc \
        tasksel \
        numactl \
        inxi \
        htop
    
}

function install_commons_latex() {

    [ "$Y_BASE_COMMONS_LATEX" = 1 ] || return 0
    
    apt_install \
        texlive-latex-extra \
        texlive-xetex
        
#    tlmgr install \
#        unicode-math
        
#    tlmgr update --self --all
}

function install_commons_cran() {
    
    [ "$Y_BASE_COMMONS_CRAN" = 1 ] || return 0
    
    install2.r --error --skipmissing --skipinstalled -n $NCPUS \
               remotes \
               renv \
               devtools \
               usethis \
               cli \
               here \
               logging \
               logger
    
}



function install_commons() {
    
    install_commons_sys
    install_commons_cran
    
}



function setenv_rehash() {

    set +e
    env_dump "setenv_commons::pre"
    export PS1='# '; source /etc/bash.bashrc
    env_dump "setenv_commons::post"
    set -e
    
}


function check_commons() {
    
    [ "$Y_BASE_COMMONS_CHECK" = 1 ] || return 0
    
    inxi    -v 1   || true
    numactl -H     || true
    numactl -s     || true
    
    
}


function clean_up() {
    :
}



function main() {

    env_dump $@
    
    [ "$Y_BASE_COMMONS_INSTALL" = 1 ] || return 0

    info "> script($0) -- STARTED, ..."
    
    setenv_rehash

    install_commons
    setenv_rehash

    check_commons

    clean_up

    info "> script($0) -- DONE."

}
    

main $@
 
