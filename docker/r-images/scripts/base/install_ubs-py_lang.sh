#!/bin/bash

# @see: https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_python.sh

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
    echo "+++<  #ENV($0)"
    
}



## build ARGs
NCPUS=${NCPUS:--1}


## R - python
install2.r --error --skipmissing --skipinstalled -n $NCPUS \
    reticulate


# Check Python version
# echo -e "Check the Python to use with reticulate...\n"

# R -q -e 'reticulate::py_discover_config(required_module = NULL, use_environment = NULL)'

# echo -e "\nInstall Python, done!"


 rm -rf /tmp/downloaded_packages
