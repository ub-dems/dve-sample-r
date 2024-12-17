#!/bin/bash

###
## Install fnm, node, npm
##

## @see: https://nodejs.org/en/download/package-manager

## build ARGs
set -e
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}

set -a
# ------------------------------------------------------
: "${VSCODE_SERVER_DIR:=/opt/vscode-server}"
: "${VSCODE_SERVER_VERSION:=latest}"
# ------------------------------------------------------
set +a


function env_dump() {
    
    [ "$Y_DEBUG_ENV" = 1 ] || return 0
    
    echo "+++> #ENV($0): $@"
    echo "+++: #ENV($0): set"
    set | grep -e '^Y_' | sort
    echo "+++: #ENV($0): env"
    env | sort
    echo "+++: #ENV($0): path"
    echo "PATH=$PATH"
    echo "+++< #ENV($0): $@"
    
}




function setenv_rehash() {
    
    set +e
    env_dump "setenv_rehash::pre"

    export PS1='# '

    case "${SHELL:-/bin/bash}" in
        */zsh)
            [ -f /etc/zprofile ] && source /etc/zprofile
            [ -f ~/.zprofile ] && source ~/.zprofile
            [ -f ~/.zshrc ] && source ~/.zshrc
            ;;
        */bash|*/sh|*)
            [ -f /etc/profile ] && source /etc/profile
            # [ -f ~/.profile ] && source ~/.profile
            # [ -f ~/.bashrc ] && source ~/.bashrc
            ;;
    esac    
    env_dump "setenv_rehash::post"
    set -e
    
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


function install_build_deps() {

    [ "$Y_PY_PYENV_INSTALL" = 1 ] || return 0

    apt_install \
        fonts-liberation \
        libsecret-1-dev \
        libgtk-3-dev \
        libatk1.0-0 \
        libcairo2-dev \
        libpango-1.0-0 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcursor-dev \
        libxcomposite-dev \
        libxdamage-dev \
        libxrandr-dev \
        libnss3-dev \
        libxss1 \
        libxtst6 \
        libgtk-3-0
    
}


function config_code() {

    [ "$Y_JS_CODE_CONFIG" = 1 ] || return 0

    # save example config.yaml

    if [ -f ~/.config/code-server ]; then
        mkdir -p /usr/local/doc
        mv ~/.config/code-server /usr/local/doc
    fi

    echo "# +++ code-server(config.yaml): /usr/local/doc/code-server/config.yaml"

}


function check_code() {
    
    [ "$Y_JS_CODE_CHECK" = 1 ] || return 0

    echo "Verifying node and npm installation..."

    echo "PATH=${PATH}"
    echo "SHELL=${SHELL}"
    
    set -x
    
    which -a code-server  || true
    code-server --version || false
    
    set +x
    
}


function install_code() {

    [ "$Y_JS_CODE_INSTALL" = 1 ] || return 0

    # Install Visual Studio Code Server
    echo "Installing Visual Studio Code Server..."

    curl -fsSL https://code-server.dev/install.sh | sh -s -- --prefix /usr/local
    
    # mkdir -p "$VSCODE_SERVER_DIR"
    # npm install -g code-server@"$VSCODE_SERVER_VERSION"

    # # Create symlink for global access
    # ln -sf "$(npm root -g)/code-server/dist/bin/code-server" /usr/local/bin/code-server


}



function clean_up() {
    :
}



function main() {
    
    [ "$Y_JS_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@

    [ "$Y_JS_CODE_SUPPORT" = 1 ] || return 0

    install_code $@
    config_code $@

    setenv_rehash    
    
    check_code $@

    clean_up

}

main $@
