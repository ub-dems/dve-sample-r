#!/bin/bash

## Install pyenv, to facilitate installation of different python versions
## Allows users to do things like:
##     pyenv install 3.7.9 # install python 3.7.9; e.g. for tensorflow 1.15.x
##     pyenv global 3.7.9  # activate as the default python
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
    echo "+++< #ENV($0): $@"
    
}

function setenv_rehash() {
    
    set +e
    env_dump "setenv_rehash::pre"
    source /etc/profile
    #export PS1='# '; source /etc/bash.bashrc
    env_dump "setenv_rehash::post"
    set -e
    
}

PYTHON_CONFIGURE_OPTS=${PYTHON_CONFIGURE_OPTS:-"--enable-shared"}

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

function install_build_deps() {

    [ "$Y_PY_PYENV_INSTALL" = 1 ] || return 0

    apt_install \
        curl \
        build-essential \
        gdb \
        lcov \
        pkg-config \
        libbz2-dev \
        libffi-dev \
        libgdbm-dev \
        libgdbm-compat-dev \
        liblzma-dev \
        libncurses5-dev \
        libreadline6-dev \
        libsqlite3-dev \
        libmysqlclient-dev \
        libssl-dev \
        lzma \
        lzma-dev \
        tk-dev \
        uuid-dev \
        zlib1g-dev

#       libmysqlclient-dev # required for mysql native support


}

function install_pyenv() {

    [ "$Y_PY_PYENV_INSTALL" = 1 ] || return 0

    #export PYENV_ROOT=/opt/pyenv
    #export PATH=$PYENV_ROOT/bin:$PATH

    : ${PYENV_ROOT:=/opt/pyenv}

    [ -d "$PYENV_ROOT" ] && rm -rf $PYENV_ROOT
    
# consider a version-stable alternative for the installer?
    curl https://pyenv.run | \
        env PYENV_ROOT=${PYENV_ROOT} bash

    
}

function config_pyenv() {

    [ "$Y_PY_PYENV_CONFIG" = 1 ] || return 0

    sed -i 's!PATH="!PATH="/opt/pyenv/bin:!' \
        "/etc/environment"


    : ${PYTHON_CONFIGURE_OPTS:="--enable-shared"}

    cat <<EOP >/etc/profile.d/Z93-pyenv.sh
##
# pyenv
#

PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS}"

EOP

    cat <<"EOF" >>/etc/profile.d/Z93-pyenv.sh
PYTHON_CONFIGURE_OPTS=${PYTHON_CONFIGURE_OPTS:-"--enable-shared"}

### -> inhrited from container ENV
### PYENV_ROOT=/opt/pyenv
### PATH=~/.local/bin:$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PYENV_ROOT/plugins/pyenv-virtualenv/shims:$PATH

eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

PATH=$(P=$(echo -n $PATH | awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print $0}'); echo -n ${P:0:-1})

export PYENV_ROOT
export PATH

export X_RC_Z93_PYENV=1
EOF

    cat <<"EOB" >>/etc/bash.bashrc
if [ "$X_RC_SYSPROFILE_INCLUDED" = "1" ]; then
   [ "$X_DEBUG_ENV" = 1 ] && echo "### /etc/bash.bashrc(pyenv) {"
   [ "$X_DEBUG_ENV" = 1 ] && echo $PATH
   [ "$X_DEBUG_ENV" = 1 ] && which pyenv
   eval "$(pyenv init -)"
   eval "$(pyenv virtualenv-init -)"
   [ "$X_DEBUG_ENV" = 1 ] && echo "### /etc/bash.bashrc(pyenv) }"
fi
EOB

    eval "export X_ENV_PATH=$(bash --login -i -c 'printf \"%s\" "$PATH"' | tail -n1)"
    
    sed -i '/PATH=/d' \
        "${R_HOME}/etc/Renviron.site"

    cat <<EOR >>"${R_HOME}/etc/Renviron.site"
PYTHON_CONFIGURE_OPTS="${PYTHON_CONFIGURE_OPTS}"
PYENV_ROOT=${PYENV_ROOT}
PYENV_SHELL=bash
PATH=${X_ENV_PATH}
EOR
    
    echo "# +++ pyenv: PATH=${PATH}"

}




function install_pyenv_python() {

    [ "$Y_PY_PYENV_PYTHON" = 1 ] || return 0

    # python setup

    : ${PYTHON_CONFIGURE_OPTS:="--enable-shared"}
    
    env PYTHON_CONFIGURE_OPTS=${PYTHON_CONFIGURE_OPTS}  \
        pyenv install $Y_PY_PYTHON_VERSION

}


function config_pyenv_python() {

    [ "$Y_PY_PYENV_PYTHON" = 1 ] || return 0

    # python global default

    Y_PY_PYTHON_REVISION="$(pyenv versions | grep $Y_PY_PYTHON_VERSION | cut -c3- | cut -d' ' -f1)"
    export Y_PY_PYTHON_REVISION
    
    pyenv global $Y_PY_PYTHON_REVISION

}

function upgrade_pyenv_python() {
    
    [ "$Y_PY_PYENV_UPGRADE" = 1 ] || return 0
    
    python3 -m pip --no-cache-dir install --upgrade --ignore-installed \
            pip \
            setuptools \
            wheel \
            pipenv \
            numpy

}



function check_pyenv() {
    
    [ "$Y_PY_PYENV_CHECK" = 1 ] || return 0

    set -x
    
    which python      || true
    which -a python3  || true

    python --version  || true

    which    pip      || true
    which -a pip3     || true

    pyenv --version   || true
    pyenv   versions  || true
    pyenv   version   || true
    
    set +x
    
}


function clean_up() {
    :
}



function main() {
    
    [ "$Y_PY_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@

    [ "$Y_PY_PYENV_SUPPORT" = 1 ] || return 0

    install_build_deps

    install_pyenv    
    config_pyenv    
    setenv_rehash    

    install_pyenv_python
    config_pyenv_python

    upgrade_pyenv_python
    
    check_pyenv    

    clean_up


}

main $@
