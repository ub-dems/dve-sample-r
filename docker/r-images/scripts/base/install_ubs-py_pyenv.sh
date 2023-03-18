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

#echo "PYTHON_CONFIGURE_OPTS=${PYTHON_CONFIGURE_OPTS}" >>"${R_HOME}/etc/R_environ"

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
    python3-pip

python3 -m pip --no-cache-dir install --upgrade --ignore-installed pipenv

    
}

function install_pyenv() {

# consider a version-stable alternative for the installer?
    curl https://pyenv.run | \
        env PYENV_ROOT=/opt/pyenv bash

    
}

function config_pyenv() {

# pipenv requires ~/.local/bin to be on the path...
cat <<"EOR" >>"${R_HOME}/etc/Renviron.site"
PYENV_ROOT=/opt/pyenv
PATH=$PYENV_ROOT/bin:~/.local/bin:$PATH
EOR

cat <<"EOF" >>/etc/bash.bashrc
PYENV_ROOT=/opt/pyenv
PATH=$PYENV_ROOT/bin:~/.local/bin:$PATH
export PYENV_ROOT
export PATH
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
EOF
    
}

function setenv_reload() {

    env_dump "setenv_reload::pre"
    export PS1='# '; source /etc/bash.bashrc
    # env_dump "setenv_pyenv::src"
    
    # export PYENV_ROOT=/opt/pyenv
    # export PATH=$PYENV_ROOT/bin:~/.local/bin:$PATH
    # eval "$(pyenv init --path)"
    # eval "$(pyenv virtualenv-init -)"

    env_dump "setenv_reload::post"
    
}

function update_system_python() {

    if [ -e /usr/bin/python ]; then
        return 0
    fi

    if [ -e /usr/bin/python3 ]; then
        ln -s /usr/bin/python3 /usr/bin/python
    fi
    
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

function clean_up() {
    rm -rf /var/lib/apt/lists/*
}



function main() {

    env_dump $@

    update_system_python
    
    [ "$Y_PY_PYENV_INSTALL" = 1 ] || return 0

    install_build_deps

    install_pyenv    
    config_pyenv    
    setenv_reload    

    install_pyenv_python
    config_pyenv_python

    clean_up


}

main $@
