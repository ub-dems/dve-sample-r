#!/bin/bash

## build ARGs
NCPUS=${NCPUS:--1}

set -e
apt-get update -qq && apt-get -y --no-install-recommends install \
    less \
    ssh \
    vim \
    zsh \
    mc \
    ranger \
    silversearcher-ag \
    parallel \
    hwloc \
    tasksel \
    numactl \
    inxi \
    htop && \
  rm -rf /var/lib/apt/lists/*

## R benchmarks
install2.r --error --skipmissing --skipinstalled -n $NCPUS \
    remotes \
    renv \
    devtools \
    cli \
    logging \
    logger \
    pak \
    ps \
    benchmarkme \
    benchmarkmeData \
    rbenchmark \
    microbenchmark \
    ragg \
    reprex \
    styler

## a bridge to far? -- brings in another 60 packages
# install2.r --error --skipinstalled -n $NCPUS tidymodels

 rm -rf /tmp/downloaded_packages




set -e

source /etc/build.conf

function env_dump() {

    [ "$Y_DEBUG" = 1 ] || return 0
    
    echo "+++> #ENV($0): $@"
    echo "+++: #ENV($0): /etc/build.conf"
    cat /etc/build.conf
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
        parallel \
        hwloc \
        tasksel \
        numactl \
        inxi \
        htop && \
    rm -rf /var/lib/apt/lists/*
    
}

function install_commons_cran() {
    
    [ "$Y_BASE_COMMONS_CRAN" = 1 ] || return 0
    
    install2.r --error --skipmissing --skipinstalled -n $NCPUS \
               remotes \
               renv \
               devtools \
               cli \
               logging \
               logger
    
}


function install_commons() {
    
    install_commons_sys
    install_commons_cran
    
}



function setenv_reload() {

    env_dump "setenv_commons::pre"
    export PS1='# '; source /etc/bash.bashrc
    env_dump "setenv_commons::post"
    
}


function check_commons() {
    
    [ "$Y_BASE_COMMONS_CHECK" = 1 ] || return 0
    
    inxi    -v 1   || true
    numactl -H     || true
    numactl -s     || true
    
    
}


function clean_up() {
    rm -rf /var/lib/apt/lists/*
    rm -rf /tmp/downloaded_packages
}



function main() {

    env_dump $@
    
    [ "$Y_BASE_CLEAN_ALL" = 1 ] || return 0

    clean_up


}
    

main $@
 
