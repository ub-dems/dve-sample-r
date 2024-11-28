#!/bin/bash

## Install poetry, with current python version
##

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
    echo "+++<  #ENV($0): $@"
    
}

function debug_poetry() {
    
    [ "$Y_PY_POETRY_DEBUG" = 1 ] || return 0


    echo "### >> POETRY::DEBUG($@)"
    
    echo "PATH=${PATH}"
    echo "SHELL=${SHELL}"
    echo "PYTHON_CONFIGURE_OPTS=${PYTHON_CONFIGURE_OPTS}"
    
    set -x
    
    which python      || true
    which -a python3  || true

    python --version  || true

    which    pip      || true
    which -a pip3     || true

    pyenv --version   || true
    pyenv   versions  || true
    pyenv   version   || true

    which   pipx      || true
    pipx  --version   || true
    pipx    list      || true

    which   poetry      || true
    poetry  --version   || true
    poetry  env info    || true
    
    set +x

    echo "--- project.env //"
    echo "pwd=$(pwd)"
    echo "Y_WORD_DIR=${Y_WORK_DIR}"
    echo "Y_POETRY_LOAD=${Y_POETRY_LOAD}"
    echo "// project.env ---"
    
    
    echo "### << POETRY::DEBUG($@)"
}



function setenv_rehash() {

    set +e
    env_dump "setenv_poetry::pre"
    source /etc/profile
    #export PS1='# '; source /etc/bash.bashrc
    env_dump "setenv_poetry::post"
    set -e
    
}


function install_poetry() {

    pipx install --global poetry

    pipx upgrade --global poetry
    
    
}

function config_poetry() {

    [ "$Y_PY_POETRY_CONFIG" = 1 ] || return 0

    
: ${PYTHON_KEYRING_BACKEND:="keyring.backends.null.Keyring"}

cat <<EOP >/etc/profile.d/Z94-poetry.sh
##
# poetry 
#

PYTHON_KEYRING_BACKEND="${PYTHON_KEYRING_BACKEND}"

EOP

cat <<"EOF" >>/etc/profile.d/Z94-poetry.sh
#
### -> inhrited from container ENV
### POETRY_HOME=/opt/poetry
### PATH=~/.local/bin:/opt/poetry/bin:$PATH
export PYTHON_KEYRING_BACKEND
### export POETRY_HOME
### export PATH

export X_RC_Z94_POETRY=1
EOF

eval "export PATH=$(bash --login -i -c 'printf \"%s\" "$PATH"' | tail -n1)"

sed -i '/PATH=/d' \
    "${R_HOME}/etc/Renviron.site"

cat <<EOR >>"${R_HOME}/etc/Renviron.site"
PYTHON_KEYRING_BACKEND="${PYTHON_KEYRING_BACKEND}"
PATH=${PATH}
EOR

echo "# +++ poetry: PATH=${PATH}"

}

function check_poetry() {
    
    [ "$Y_PY_POETRY_CHECK" = 1 ] || return 0
    
    which python || true
    which pyenv  || true
    which poetry || true

    python --version  || true
    pyenv  --version  || true
    poetry --version  || true

    #poetry env list || true
    #poetry env info || true
    
}


function clean_up() {
    :
}

function main() {

    [ "$Y_PY_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@
    
    [ "$Y_PY_POETRY_INSTALL" = 1 ] || return 0

    setenv_rehash

    install_poetry
    config_poetry
    setenv_rehash

    check_poetry
    debug_poetry
    
    clean_up


}

main $@
