#!/bin/bash

source ${Y_BUILD_CONF:-/etc/build.conf}

## build ARGs
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
    echo "+++<  #ENV($0)"
    
}

function setenv_rehash() {
    
    set +e
    env_dump "setenv_rehash::pre"
    export PS1='# '; source /etc/bash.bashrc
    env_dump "setenv_rehash::post"
    set -e
    
}


function install_jupyter_system() {

    [ "$Y_PY_JUPYTER_SYSTEM" = 1 ] || return 0
    
    python3 -m pip install --no-cache-dir \
            jupyter-rsession-proxy \
            notebook \
            jupyterlab

    [ "$Y_PY_JUPYTER_HUB" = 1 ] || return 0

    python3 -m pip install --no-cache-dir \
            jupyterhub
    
}

function install_jupyter_venv() {

    echo "#<jupyter>: SETUP:"
    echo "#<jupyter>:  to install jupyter, in container shell run 'poetry install'"
    echo "#<jupyter>:  then in 'poetry shell', run 'jlpm up; jupyter lab build' "
    echo "#<jupyter>: RUNTIME:"
    echo "#<jupyter>:  internal: jupyter lab --notebook-dir=notebooks --no-browser --ip=0.0.0.0 --port=8888 --ServerApp.allow_remote_access=true"
    echo "#<jupyter>:  external: ./runtime.sh lab"

    
}

function install_jupyter() {

    [ "$Y_PY_JUPYTER_INSTALL" = 1 ] || return 0
    
    if [ "$Y_PY_JUPYTER_SYSTEM" = 1 ]; then
        install_jupyter_system
    else    
        install_jupyter_venv
    fi    
       
   
}

function install_irkernel() {
    
    [ "$Y_PY_JUPYTER_IRKERNEL" = 1 ] || return 0

      R --quiet   -e 'remotes::install_github("IRkernel/IRkernel@*release")'
    
}

function install_langserver() {
    
    [ "$Y_PY_JUPYTER_LANGSERV" = 1 ] || return 0

    # R --vanilla -e 'install.packages("languageserver")'
    
    install2.r --error --skipmissing --skipinstalled -n $NCPUS \
               languageserver
    
    
}



function config_jupyter_system() {

    echo -e "Check jupyter availability...\n"

    which jupyter || true
    which jupyter || true
    
    python --version  || true
    jupyter --version || true

    
    R --quiet -e 'IRkernel::installspec(user = FALSE)'
    
}

function config_jupyter_venv() {
    
    echo "#<jupyter>:  to enable IRkernel in jupyter, in container shell run:"
    echo "#<jupyter>:  R --quiet -e 'IRkernel::installspec(user = TRUE)'"
    
}



function config_jupyter() {

    [ "$Y_PY_JUPYTER_CONFIG" = 1 ] || return 0

    if [ "$Y_PY_JUPYTER_SYSTEM" = 1 ]; then
        config_jupyter_system
    else    
        config_jupyter_venv
    fi    
    
}

function config_jupyter() {

    [ "$Y_PY_JUPYTER_CONFIG" = 1 ] || return 0
    
    if [ "$Y_PY_JUPYTER_SYSTEM" = 1 ]; then
        config_jupyter_system
    else    
        config_jupyter_venv
    fi    
    
}


function check_jupyter_system() {

    # Check jupyter
    echo -e "Check jupyter version...\n"

    jupyter --version

    echo -e "Check the avalable jupyter kernels...\n"

    jupyter kernelspec list

    echo -e "\nInstall jupyter, done!"
    
}

function check_jupyter_venv() {
    
    echo "#<jupyter>:  to ckeck jupyter, in container shell run:"
    echo "#<jupyter>:  jupyter --version"
    echo "#<jupyter>:  jupyter --paths"
    echo "#<jupyter>:  jupyter labextension list"
    echo "#<jupyter>:  jupyter kernelspec list"
    
}


function check_jupyter() {

    [ "$Y_PY_JUPYTER_CHECK" = 1 ] || return 0
    
    if [ "$Y_PY_JUPYTER_SYSTEM" = 1 ]; then
        check_jupyter_system
    else    
        check_jupyter_venv
    fi    
    
}



function clean_up() {
    :
}




function main() {

    [ "$Y_PY_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@
    
    [ "$Y_PY_JUPYTER_SUPPORT" = 1 ] || return 0

    info "> script($0) -- STARTED, ..."

    setenv_rehash    

    install_jupyter

    install_irkernel
    
    install_langserver
    
    config_jupyter
    
    setenv_rehash    

    check_jupyter

    clean_up

    info "> script($0) -- DONE."

}

main $@
