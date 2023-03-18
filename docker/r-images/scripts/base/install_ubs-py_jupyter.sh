#!/bin/bash

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

# python3 -m pip install --no-cache-dir jupyter-rsession-proxy notebook jupyterlab

## R benchmarks
install2.r --error --skipmissing --skipinstalled -n $NCPUS \
    IRkernel


# R --quiet -e 'remotes::install_github("IRkernel/IRkernel@*release")'
# R --quiet -e 'IRkernel::installspec(user = FALSE)'


 rm -rf /tmp/downloaded_packages


# Check jupyter
# echo -e "Check the avalable jupyter kernels...\n"

# jupyter kernelspec list

# echo -e "\nInstall jupyter, done!"
