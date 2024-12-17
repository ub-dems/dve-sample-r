#!/bin/bash

##
# install_ubs-utils.sh: install utility tools and libraries
#


set -e

## build ARGs
source /etc/build.conf

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

function install_utils_sys() {

    [ "$Y_BASE_UTILS_SYS" = 1 ] || return 0
    
    apt_install \
        less \
        ssh \
        vim \
        zsh \
        mc \
        ranger \
        silversearcher-ag \
        ripgrep \
        iputils-ping \
        iputils-tracepath \
        iputils-clockdiff \
        tmux
    
}

function install_utils_cran() {
    
    [ "$Y_BASE_UTILS_CRAN" = 1 ] || return 0
    
    install2.r --error --skipmissing --skipinstalled -n $NCPUS \
               pak \
               ps \
               benchmarkme \
               benchmarkmeData \
               rbenchmark \
               microbenchmark \
               ragg \
               reprex \
               styler
    
}


function install_utils() {
    
    install_utils_sys
    install_utils_cran
    
}



function setenv_rehash() {

    set +e
    env_dump "setenv_utils::pre"
    export PS1='# '; source /etc/bash.bashrc
    env_dump "setenv_utils::post"
    set -e
    
}


function check_utils() {
    
    [ "$Y_BASE_UTILS_CHECK" = 1 ] || return 0
    
    ssh -V   || true
    
    
}


function clean_up() {
    :
}



function main() {

    env_dump $@
    
    [ "$Y_BASE_UTILS_INSTALL" = 1 ] || return 0

    setenv_rehash

    install_utils
    setenv_rehash

    check_utils

    clean_up


}
    

main $@
 
