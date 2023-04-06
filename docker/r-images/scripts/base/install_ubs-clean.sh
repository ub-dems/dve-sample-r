#!/bin/bash

## build ARGs
NCPUS=${NCPUS:--1}

set -e

source ${Y_BUILD_CONF:-/etc/build.conf}

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
 
