#!/bin/bash

## Install poetry, with current python version
##

## build ARGs
set -e
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}

set -a
# ------------------------------------------------------

: ${POETRY_HOME:="/opt/poetry"}

: ${PYTHON_KEYRING_BACKEND:="keyring.backends.null.Keyring"}

# ------------------------------------------------------
set +a



# ---(colors)------------------------------------------------
C_OFF='\033[0m'
C_Green='\033[0;32m'
C_IGreen='\033[0;92m'
C_Blue='\033[0;34m'
C_BBlue='\033[1;34m'
C_UBlue='\033[4;34m'
C_On_Blue='\033[44m'
C_IBlue='\033[0;94m'
C_On_IBlue='\033[0;104m'
C_BIBlue='\033[1;94m'
C_BCyan='\033[1;36m'
C_ICyan='\033[0;96m'
C_UCyan='\033[4;36m'
C_BICyan='\033[1;96m'
C_BYellow='\033[1;33m'
C_IYellow='\033[0;93m'
C_BIYellow='\033[1;93m'
C_BRed='\033[1;31m'
C_IRed='\033[0;91m'
C_URed='\033[4;31m'
C_BIRed='\033[1;91m'
C_BWhite='\033[1;37m'
C_IWhite='\033[0;97m'
C_UWhite='\033[4;37m'
C_BIWhite='\033[1;97m'

# ---(logs)------------------------------------------------
CLOG=""
LCTX="-"
LOG_LOGGER="$(basename $0 .sh)"
LOG_WHO="${IMG_TYPE:-'----'}"
LOG_LEVEL=""
function _log() {

    local mess
    local llev
    lwho="$LOG_WHO"
    lcat="$LOG_LOGGER"
    llev=$(printf '%-5s' ${LOG_LEVEL:-'LOG'})
    mess="${C_IGreen}$(date '+%Y-%m-%d %H:%M:%S %s') ${C_OFF}${CLOG}| $lwho | $lcat | $llev | ${LCTX} | $$ | $* ${C_OFF}"

    echo -e ${mess}
    
}
debug() { LOG_LEVEL='DEBUG' CLOG="$C_Green"   _log $*; }
info()  { LOG_LEVEL='INFO.'  CLOG="$C_BICyan"  _log $*; }
warn()  { LOG_LEVEL='WARN.'  CLOG="$C_BYellow" _log $*; }
error() { LOG_LEVEL='ERROR' CLOG="$C_IRed"    _log $*; }
fatal() { LOG_LEVEL='FATAL' CLOG="$C_BIRed"   _log $*; }
log()   { LOG_LEVEL='_LOG_'   CLOG="$C_BBlue"   _log $*; }
die ()  { fatal $*; exit 1; }

# ---(env)------------------------------------------------
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

    [ "$Y_PY_POETRY_INSTALL" = 1 ] || return 0
    
    debug "> install poetry, ..."

    pipx install --global poetry
    pipx upgrade --global poetry
    pipx inject  --global poetry poetry-plugin-shell

    debug "> install poetry, done."
    
    
}

function config_poetry() {

    [ "$Y_PY_POETRY_CONFIG" = 1 ] || return 0
    

cat <<EOP >/etc/profile.d/Z94-poetry.sh
##
# poetry 
#

# interpolate build environment

PYTHON_KEYRING_BACKEND=${PYTHON_KEYRING_BACKEND}

EOP

cat <<"EOF" >>/etc/profile.d/Z94-poetry.sh
#
### -> inhrited from container ENV
### POETRY_HOME=/opt/poetry
### PATH=~/.local/bin:/opt/poetry/bin:$PATH
export PYTHON_KEYRING_BACKEND
### export POETRY_HOME
### export PATH


set -a
# ------------------------------------------------------

: ${POETRY_HOME:="/opt/poetry"}
: ${PYTHON_KEYRING_BACKEND:="keyring.backends.null.Keyring"}

: "${X_AUTO_ENV:=1}"

# ------------------------------------------------------
set +a


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


py_clear_env() {

   if [ -n "$VIRTUAL_ENV" ]; then
      deactivate_init nondestructive
   fi

}

py_auto_env() {

   [ "$X_AUTO_ENV" = "1" ] || return 0
   [ -n "$X_WORK_DIR" ]    || return 0

   ### X_POETRY_VENV="$(cd $X_WORK_DIR && poetry env info --path)"
   X_POETRY_VENV="$(poetry env info --path)"
   [ -f "$X_POETRY_VENV/bin/activate" ]    || return 0

   source "$X_POETRY_VENV/bin/activate"

}


py_poetry_init() {
  py_clear_env
  py_auto_env
}

py_poetry_init

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

function check_pipx() {
    
    [ "$Y_PY_POETRY_CHECK" = 1 ] || return 0
    
    which python || true
    which pyenv  || true
    which pipx   || true

    python --version  || false
    pyenv  --version  || false
    pipx   --version  || false

    
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
    
    [ "$Y_PY_POETRY_SUPPORT" = 1 ] || return 0

    info "> script($0) -- STARTED, ..."
    
    setenv_rehash

    check_pipx
    
    install_poetry
    config_poetry
    setenv_rehash

    check_poetry
    debug_poetry
    
    clean_up

    info "> script($0) -- DONE."

}

main $@
