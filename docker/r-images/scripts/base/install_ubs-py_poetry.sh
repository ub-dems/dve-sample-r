#!/bin/bash

## Install poetry, with current python version
##

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

function install_poetry() {
    
    curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3 -
    
}

function config_poetry() {

### PYTHON_CONFIGURE_OPTS=${PYTHON_CONFIGURE_OPTS:-"--enable-shared"}
    
# poetry requires $POETRY_HOME/bin to be on the path...
echo 'PYTHON_KEYRING_BACKEND="keyring.backends.null.Keyring"' >>"${R_HOME}/etc/Renviron.site"
    
cat <<"EOF" >>/etc/bash.bashrc
PYTHON_KEYRING_BACKEND="keyring.backends.null.Keyring"
POETRY_HOME=/opt/poetry
PATH=/opt/poetry/bin:~/.local/bin:$PATH
export PYTHON_KEYRING_BACKEND
export POETRY_HOME
export PATH 
EOF
    
}


function setenv_reload() {

    env_dump "setenv_poetry::pre"
    export PS1='# '; source /etc/bash.bashrc
    # env_dump "setenv_poetry::src"
    # export PATH="/opt/poetry/bin:$PATH"
    env_dump "setenv_poetry::post"
    
}


function check_poetry() {
    
    which python || true
    which pyenv  || true
    which poetry || true

    python --version  || true
    pyenv  --version  || true
    poetry --version  || true
    
}


function clean_up() {
    rm -rf /var/lib/apt/lists/*
}



function main() {

    env_dump $@
    
    [ "$Y_PY_POETRY_INSTALL" = 1 ] || return 0

    setenv_reload

    install_poetry
    config_poetry
    setenv_reload

    check_poetry

    clean_up


}
    

main $@
