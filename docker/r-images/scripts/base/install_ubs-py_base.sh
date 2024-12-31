#!/bin/bash

## Disable inherited VIRTUAL_ENV environment settings from anchor image
##

## @see: https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/ml_devel.Dockerfile

## build ARGs
set -e
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}


set -a
# ------------------------------------------------------

: ${GLOBAL_VENV:="${PYVENVS_ROOT}/global"}

# ${VIRTUAL_ENV:="/opt/venv"}
# ${VIRTUAL_IMG:="/opt/venv.img"}

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



function debug_pybase() {
    
    [ "$Y_PY_BASE_DEBUG" = 1 ] || return 0


    echo "### >> PY-BASE::DEBUG($@)"
    
    echo "PATH=${PATH}"
    echo "SHELL=${SHELL}"
    echo "VIRTUAL_ENV=${VIRTUAL_ENV}"
    
    set -x
    
    which python      || true
    which -a python3  || true

    python --version  || true

    set +x
    
    echo "### << PY-BASE::DEBUG($@)"
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

function undo_image_venv() {
    
    [ "$Y_PY_BASE_UNDO" = 1 ] || return 0

    debug_pybase "py_base_undo_venv::pre"


    if [ -n "$VIRTUAL_ENV" ]; then
        if [ -d "$VIRTUAL_ENV" ]; then
            mv "${VIRTUAL_ENV}" "${VIRTUAL_ENV}.img"
        fi

        debug_pybase "py_base_undo_venv::defined"

    fi    

    debug_pybase "py_base_undo_venv::post"

}


function undo_image_environ() {

    [ "$Y_PY_BASE_VANILLA" = 1 ] || return 0
    
    debug_pybase "py_base_undo_image::pre"

    sed -i '/VIRTUAL_ENV=/d' \
        "/etc/environment"

    sed -i '/VIRTUAL_ENV=/d' \
        "${R_HOME}/etc/Renviron.site"
    
    cat <<"EOF" >>/etc/profile.d/Z93-pybase.sh
##
# py-base
#

### -> inhrited from container ENV
### VIRTUAL_ENV=/opt/venv

deactivate_init () {
    # reset old environment variables
    if [ -n "${_OLD_VIRTUAL_PATH:-}" ] ; then
        PATH="${_OLD_VIRTUAL_PATH:-}"
        export PATH
        unset _OLD_VIRTUAL_PATH
    fi
    if [ -n "${_OLD_VIRTUAL_PYTHONHOME:-}" ] ; then
        PYTHONHOME="${_OLD_VIRTUAL_PYTHONHOME:-}"
        export PYTHONHOME
        unset _OLD_VIRTUAL_PYTHONHOME
    fi

    # This should detect bash and zsh, which have a hash command that must
    # be called to get it to forget past commands.  Without forgetting
    # past commands the $PATH changes we made may not be respected
    if [ -n "${BASH:-}" -o -n "${ZSH_VERSION:-}" ] ; then
        hash -r 2> /dev/null
    fi

    if [ -n "${_OLD_VIRTUAL_PS1:-}" ] ; then
        PS1="${_OLD_VIRTUAL_PS1:-}"
        export PS1
        unset _OLD_VIRTUAL_PS1
    fi

    unset VIRTUAL_ENV
    unset VIRTUAL_ENV_PROMPT
    if [ ! "${1:-}" = "nondestructive" ] ; then
    # Self destruct!
        unset -f deactivate
    fi
}


py_base_clear() {

   if [ -n "$VIRTUAL_ENV" ]; then
      deactivate_init nondestructive
   fi

}

py_base_environ() {

[ "$X_DEBUG_ENV" = '1' ] && set -x

if [ -n "$BASH_VERSION" ]; then
   [ -f /etc/bash.aliases ] && source /etc/bash.aliases || true
   [ -f ~/.bash_aliases ] && source ~/.bash_aliases  || true
fi

[ "$X_DEBUG_ENV" = '1' ] && set +x

}

py_base_init() {
  py_base_clear
  py_base_environ
}

py_base_init


export X_RC_Z93_PYBASE=1
EOF

    cat <<"EOA" >>/etc/bash.aliases
##
# py-base: /etc/bash.aliases
#

alias ll='ls -lhF --color=auto --group-directories-first'
alias gst='git status'
alias gss='git status -s'

EOA

    cat <<"EOC" >>/etc/bash.bashrc
[ -f /etc/bash.aliases ] && source /etc/bash.aliases || true
[ -f ~/.bash_aliases ] && source ~/.bash_aliases  || true
EOC

    debug_pybase "py_base_undo_image::post"

}



function check_base() {
    
    [ "$Y_PY_BASE_CHECK" = 1 ] || return 0

    set -x

    echo "PATH=${PATH}"
    echo "SHELL=${SHELL}"
    echo "VIRTUAL_ENV=${VIRTUAL_ENV}"

    which python      || true
    which -a python3  || true

    python3 --version  || false
    
    set +x
    
}




function clean_up() {
    :
}



function main() {
    
    [ "$Y_PY_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@

    [ "$Y_PY_BASE_SUPPORT" = 1 ] || return 0

    undo_image_venv    
    undo_image_environ    
    setenv_rehash    

    check_base

    clean_up


}

main $@
