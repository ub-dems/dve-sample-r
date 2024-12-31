#!/bin/bash

###
## Install rustup, cargo, rustc
##

## @see: https://doc.rust-lang.org/cargo/getting-started/installation.html

## build ARGs
set -e
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}


set -a
# ------------------------------------------------------
: "${RUST_ROOT:=/opt/rust}"
: "${CARGO_HOME:=/opt/cargo}"
: "${RUSTUP_HOME:=/opt/rust}"
: "${RUSTUP_URL:=https://sh.rustup.rs}"
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


function config_rust() {

    [ "$Y_RS_RUST_CONFIG" = 1 ] || return 0

    sed -i 's!PATH="!PATH="/opt/rust/bin:/opt/cargo/bin:!' \
        "/etc/environment"

    cat <<EOF >>"/etc/environment"
RUSTUP_HOME=/opt/rust
CARGO_HOME=/opt/cargo
EOF
    
    
    cat <<EOF >>"${R_HOME}/etc/Renviron.site"
RUSTUP_HOME=/opt/rust
CARGO_HOME=/opt/cargo
EOF
    

    cat <<"EOF" >>"/etc/profile.d/Z91-rust.sh"
##
# rust/cargo environmnet
#
set -a
# ------------------------------------------------------
: "${RUST_ROOT:=/opt/rust}"
: "${CARGO_HOME:=/opt/cargo}"
: "${RUSTUP_HOME:=/opt/rust}"
: "${RUSTUP_URL:=https://sh.rustup.rs}"
# ------------------------------------------------------
set +a

[ -f "${CARGO_HOME}/env" ] && source "${CARGO_HOME}/env"
EOF

    
    echo "# +++ rust: PATH=${PATH}"

}






function check_rust() {
    
    [ "$Y_RS_RUST_CHECK" = 1 ] || return 0

    echo "Verifying Rust and Cargo installation..."
    
    echo "PATH=${PATH}"
    echo "SHELL=${SHELL}"
    
    set -x

    which -a cargo  || true
    cargo --version  || true

    which -a rustup  || true
    rustup --version  || true

    which -a rustc  || true
    rustc --version  || true
    
    set +x
    
}


function install_rust() {

    [ "$Y_RS_RUST_INSTALL" = 1 ] || return 0

    curl --proto '=https' --tlsv1.2  -sSf "$RUSTUP_URL" | \
        sh -s -- \
           -y \
           --default-toolchain stable \
           --profile default \
           --no-modify-path


}



function clean_up() {
    :
}



function main() {
    
    [ "$Y_RS_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@

    [ "$Y_RS_RUST_SUPPORT" = 1 ] || return 0

    install_rust $@
    config_rust $@

    setenv_rehash    
    
    check_rust $@

    clean_up

}

main $@
