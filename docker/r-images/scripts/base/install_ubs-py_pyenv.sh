#!/bin/bash

## Install pyenv, to facilitate installation of different python versions
## Allows users to do things like:
##     pyenv install 3.7.9 # install python 3.7.9; e.g. for tensorflow 1.15.x
##     pyenv global 3.7.9  # activate as the default python
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

function setenv_reload() {
    env_dump "setenv_reload::pre"
    export PS1='# '; source /etc/profile
    env_dump "setenv_reload::post"
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
    libssl-dev \
    lzma \
    lzma-dev \
    tk-dev \
    uuid-dev \
    zlib1g-dev \
    python3-dev \
    python3-pip

python3 -m pip --no-cache-dir install --upgrade --ignore-installed \
        pip \
        setuptools \
        wheel \
        pipenv 

    
}

function install_pyenv() {

    [ "$Y_PY_PYENV_INSTALL" = 1 ] || return 0
    
# consider a version-stable alternative for the installer?
    curl https://pyenv.run | \
        env PYENV_ROOT=/opt/pyenv bash

    
}

function config_pyenv() {

    [ "$Y_PY_PYENV_CONFIG" = 1 ] || return 0

PYTHON_CONFIGURE_OPTS=${PYTHON_CONFIGURE_OPTS:-"--enable-shared"}
#echo "PYTHON_CONFIGURE_OPTS=${PYTHON_CONFIGURE_OPTS}" >>"${R_HOME}/etc/R_environ"
    
# pipenv requires ~/.local/bin to be on the path...
cat <<"EOR" >>"${R_HOME}/etc/Renviron.site"
PYTHON_CONFIGURE_OPTS="--enable-shared"
PYENV_ROOT=/opt/pyenv
PYENV_SHELL=bash
PATH=~/.local/bin:/opt/pyenv/bin:/opt/pyenv/shims:/opt/pyenv/plugins/pyenv-virtualenv/shims:${PATH}
EOR

cat <<"EOF" >>/etc/profile.d/Z93-pyenv.sh
PYTHON_CONFIGURE_OPTS=${PYTHON_CONFIGURE_OPTS:-"--enable-shared"}
PYENV_ROOT=/opt/pyenv
PATH=$PYENV_ROOT/bin:~/.local/bin:$PATH

eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

export PYENV_ROOT
export PATH

export X_RC_Z93_PYENV=1
EOF
    
}

function update_system_python() {

    if [ -e /usr/bin/python ]; then
        return 0
    fi

    if [ -e /usr/bin/python3 ]; then
        ln -s /usr/bin/python3 /usr/bin/python
    fi

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
    libssl-dev \
    lzma \
    lzma-dev \
    tk-dev \
    uuid-dev \
    zlib1g-dev 

    
}

function install_pyenv_python() {

    [ "$Y_PY_PYENV_PYTHON" = 1 ] || return 0

    # python setup

    env PYTHON_CONFIGURE_OPTS="--enable-shared"  \
        pyenv install $Y_PY_PYTHON_VERSION

}


function config_pyenv_python() {

    [ "$Y_PY_PYENV_PYTHON" = 1 ] || return 0

    # python global default

    Y_PY_PYTHON_REVISION="$(pyenv versions | grep $Y_PY_PYTHON_VERSION | cut -c3- | cut -d' ' -f1)"
    export Y_PY_PYTHON_REVISION
    
    pyenv global $Y_PY_PYTHON_REVISION

}

function upgrade_active_python() {
    
    [ "$Y_PY_PYENV_UPGRADE" = 1 ] || return 0
    
    python3 -m pip --no-cache-dir install --upgrade --ignore-installed \
            pip \
            setuptools \
            wheel \
            pipenv 

    which -a python3 || true
    python --version  || true

    python3 -m pip --version || true

    
}

function upgrade_pyenv_python() {
    
    [ "$Y_PY_PYENV_PYTHON" = 1 ] || return 0

    upgrade_active_python    
    
    
}

function upgrade_system_python() {
    
    #   [ "$Y_PY_PYENV_PYTHON" = 1 ] && return 0

    apt_install \
        python3-dev \
        python3-numpy \
        python3-pip

    upgrade_active_python    
    
    
}



function check_pyenv() {
    
    [ "$Y_PY_PYENV_CHECK" = 1 ] || return 0
    
    which python || true
    which pyenv  || true

    python --version  || true
    pyenv  --version  || true

    pyenv  versions  || true
    which -a python3 || true
    
}


function clean_up() {
    rm -rf /var/lib/apt/lists/*
}



function main() {
    
    [ "$Y_PY_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@

    update_system_python
    upgrade_system_python
    
    [ "$Y_PY_PYENV_SUPPORT" = 1 ] || return 0

    install_build_deps

    install_pyenv    
    config_pyenv    
    setenv_reload    

    install_pyenv_python
    config_pyenv_python

    upgrade_pyenv_python
    
    check_pyenv    

    clean_up


}

main $@
