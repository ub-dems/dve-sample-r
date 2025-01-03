#!/bin/bash

# @see: https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_python.sh

## build ARGs
set -e
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}


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
    env_dump "setenv_lang::pre"
    source /etc/profile
    #export PS1='# '; source /etc/bash.bashrc
    env_dump "setenv_lang::post"
    set -e
    
}


function install_reticulate() {
    
    [ "$Y_PY_RETICULATE_INSTALL" = 1 ] || return 0

    eval "export X_ENV_PATH=$(bash --login -i -c 'printf \"%s\" "$PATH"' | tail -n1)"
 #   eval "export X_ENV_VENV=$(poetry env info --path)"
    
    sed -i '/PATH=/d' \
        "${R_HOME}/etc/Renviron.site"

    sed -i '/VIRTUAL_ENV=/d' \
        "${R_HOME}/etc/Renviron.site"

    cat <<EOR >>"${R_HOME}/etc/Renviron.site"
PATH=${X_ENV_PATH}
#VIRTUAL_ENV=${X_ENV_VENV}
EOR

    
    ## R - python
    install2.r --error --skipmissing --skipinstalled -n $NCPUS \
               reticulate
    
}


function clean_up() {
    rm -rf /var/lib/apt/lists/*
}



 function main() {

    [ "$Y_PY_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@
    
    [ "$Y_PY_RETICULATE_INSTALL" = 1 ] || return 0

    setenv_rehash

    install_reticulate
    
    setenv_rehash

    clean_up


}
    

main $@
