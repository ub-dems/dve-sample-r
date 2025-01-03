#!/bin/bash

##
# install_ubs-commons.sh: install common tools and libraries
#


set -e

## build ARGs
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

    setenv_rehash

    install_commons
    setenv_rehash

    check_commons

    clean_up


}
    

main $@
 
