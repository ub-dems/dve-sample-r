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
: "${Y_JS_NODE_VERSION:=22.12}"
: "${FNM_ROOT:=/opt/fnm}"
: "${NODE_ROOT:=/opt/nodejs}"
: "${FNM_DIR:=$NODE_ROOT/.fnm}"
: "${NODE_VERSION:=$Y_JS_NODE_VERSION}"
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


function config_node() {

    [ "$Y_JS_NODE_CONFIG" = 1 ] || return 0

#    sed -i 's!PATH="!PATH="/opt/rust/bin:/opt/cargo/bin:!' \
#        "/etc/environment"

    cat <<EOF >>"/etc/environment"
NODE_VERSION=${NODE_VERSION}
FNM_DIR=${FNM_DIR}
EOF
    
    
    cat <<EOF >>"${R_HOME}/etc/Renviron.site"
NODE_VERSION=${NODE_VERSION}
FNM_DIR=${FNM_DIR}
EOF
    

    cat <<"EOF" >>"/etc/profile.d/Z92-node.sh"
##
# node/fnm
#

if command -v fnm &> /dev/null; then
    eval "$(fnm env --shell=bash)"
fi
EOF
    
    echo "# +++ node: PATH=${PATH}"

}


function check_node() {
    
    [ "$Y_JS_NODE_CHECK" = 1 ] || return 0

    echo "Verifying node and npm installation..."

    echo "PATH=${PATH}"
    echo "SHELL=${SHELL}"
    
    set -x
    
    which -a node     || true
    node --version    || false

    which -a npm      || true
    npm --version     || false
    
    set +x
    
}


function purge_node() {

    [ "$Y_JS_NODE_PURGE" = 1 ] || return 0

    sudo apt-get purge -y \
         nodejs \
         libnode-dev || true

    sudo apt-get autoremove -y  || true
    

}


function install_node() {

    [ "$Y_JS_NODE_INSTALL" = 1 ] || return 0


    # installs fnm (Fast Node Manager)
    curl -fsSL https://fnm.vercel.app/install | \
        bash -s -- --install-dir "$FNM_ROOT" --skip-shell    

    # fnm
    FNM_PATH="$FNM_ROOT"
    ln -sf "$FNM_ROOT/fnm" /usr/local/bin/fnm

    export FNM_DIR=$NODE_ROOT/.fnm
    #export PATH=$NODE_ROOT/bin:$PATH
    
    
    if [ -d "$FNM_PATH" ]; then
        #export PATH="$FNM_PATH:$PATH"
        eval "$(fnm --fnm-dir ${FNM_DIR} env)"
    fi

    echo "export FNM_DIR=$NODE_ROOT/.fnm" >> /etc/environment
    # echo "export PATH=$NODE_ROOT/bin:\$PATH" >> /etc/environment
    source /etc/environment


    # download and install Node.js
    fnm use --fnm-dir ${FNM_DIR} --install-if-missing ${NODE_VERSION}
    fnm default ${NODE_VERSION}

    # ln -sf "$NODE_ROOT/.fnm/node-versions/$NODE_VERSION/installation/bin/node" /usr/local/bin/node
    # ln -sf "$NODE_ROOT/.fnm/node-versions/$NODE_VERSION/installation/bin/npm" /usr/local/bin/npm


}



function clean_up() {
    :
}



function main() {
    
    [ "$Y_JS_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@

    [ "$Y_JS_NODE_SUPPORT" = 1 ] || return 0

    purge_node $@
    install_node $@
    config_node $@

    setenv_rehash    
    
    check_node $@

    clean_up

}

main $@
