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

    env_dump "setenv_lang::pre"
    source /etc/profile
    #export PS1='# '; source /etc/bash.bashrc
    env_dump "setenv_lang::post"
    
}


function install_reticulate() {
    
    [ "$Y_PY_RETICULATE_INSTALL" = 1 ] || return 0
    
    ## R - python
    install2.r --error --skipmissing --skipinstalled -n $NCPUS \
               reticulate
    
}

function config_reticulate() {

    [ "$Y_PY_RETICULATE_CONFIG" = 1 ] || return 0
    
    echo -e "Check the Python to use with reticulate...\n"
#    poetry run \
           R -q -e 'reticulate::py_discover_config(required_module = NULL, use_environment = NULL)'
    echo -e "\nInstall Python, done!"
    
}




function check_reticulate() {
    
    [ "$Y_PY_RETICULATE_CHECK" = 1 ] || return 0
    
    which python || true
    which pyenv  || true
    which poetry || true

    python --version  || true
    pyenv  --version  || true
    poetry --version  || true

#    poetry env info   || true

#    poetry run \
           R -e "reticulate::py_config()" \
                      || true
    
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
    config_reticulate
    
    setenv_rehash

    check_reticulate

    clean_up


}
    

main $@
