#!/bin/bash

source ${Y_BUILD_CONF:-/etc/build.conf}

## build ARGs
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
    echo "#<jupyter>:  jupyter jupyter labextension list"
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

    setenv_rehash    

    install_jupyter

    install_irkernel
    
    install_langserver
    
    config_jupyter
    
    setenv_rehash    

    check_jupyter

    clean_up


}

main $@
