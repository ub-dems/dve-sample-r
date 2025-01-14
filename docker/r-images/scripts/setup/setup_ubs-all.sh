#!/bin/bash

## setup entry point
##

## build ARGs
# set -e
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}

#set -x
# ------------------------------------------------------
[ -f /etc/profile ] && source /etc/profile
[ -f ~/.profile ] && source ~/.profile
# ------------------------------------------------------
#set +x


set -a
# ------------------------------------------------------

: ${X_DRY:='0'}
: ${X_PID:=$$}
: ${X_SSH_OPTS:='-x'}
: ${APT_Y:='-y'}
: ${T:=$(date +%F-%H%M%S)}

: ${X_VERBOSE:=''}
: ${X_FULL_MODE:=''}
: ${X_CACHE_MODE:=''}
: ${X_DOTS_MODE:=''}
: ${X_ALL_MODE:=''}
: ${X_PYTHON_MODE:=''}
: ${X_R_MODE:=''}

# ------------------------------------------------------
case "$0" in
    -*)
        X_SRC_NAME='setup_ubs-all.sh'
        X_SRC_SCRIPT="/rocker_scripts/setup_ubs-all.sh"
    ;;
    *)
        X_SRC_NAME="$(basename $0)"
        X_SRC_SCRIPT="$(realpath $0)"
    ;;
esac
XS=${X_SRC_SCRIPT}
# ------------------------------------------------------
X_LOC_NAME="$X_SRC_NAME"
X_LOC_SCRIPT="$X_SRC_SCRIPT"
# ------------------------------------------------------

export PAGER=cat

# ------------------------------------------------------


: ${B:=/var/lib/ans/box/init}

X_TIME="$(date '+%Y%m%d-%H%M%S.%N')"
X_TS="$(date '+%Y%m%d-%H%M')"
X_USER="$(whoami)"
X_HOST="$(hostname)"
X_PID="${X_HOST}_${BASHPID}"
X_TL="$(date '+%Y-%m-%d')"
X_TS="$(date '+%s')"
X_TM="$(date --rfc-3339=seconds)"

#X_NAME="$(basename $X_SRC_SCRIPT .sh)"
X_NAME="setup"

X_TEMP="/tmp/$(id -u)"
X_WORK="$(pwd)"
X_SAVB="./temp/_setup_"
X_SAVE="${X_SAVB}/${X_TL}"
X_LOGB="./logs/sys"
X_LOGS="${X_LOGB}/${X_TL}"
X_LOGFILE="${X_LOGS}/${X_NAME}-${X_TS}-$(id -u).log"
X_DUMPFILE="${X_LOGS}/${X_NAME}-${X_TS}-$(id -u).yml"



: ${LC_ALL:='en_US.UTF-8'}
: ${LANG:='en_US.UTF-8'}
: ${TZ:='Europe/Rome'}

# --------------------------------------------------------------
set +a

exit_usage() {

echo "$XS -- illegal args: $*"    
echo ""    

cat <<EOF
 
Usage: $XS <command> [args] ...

where command is:

  --status: dump virtuaenv info
  --upgrade: force poetry lock/renv snapshot
  --help: 

EOF

  exit 1
}


sl() {
    cat | sed 's/^/      %\t/' | sed 's/\t$//'
}

sk() {
    cat | sed 's/^/       %\t/' | sed 's/\t$//'
}




dump_header_status() {
    cat <<EOF
#vim: set foldmethod=marker:foldlevel=0
---
title: "setup status - project environment"
project: "${REV_ID_PROJECT}"
package: "${REV_ID_PACKAGE}"
branch: "${REV_BRANCH_NAME}"
commit: "${REV_TAG}"
hostname: "$(hostname)"
date: "$(date)"
---
EOF

}

dump_global_status() {
    cat <<EOF
# {{{ --- [setup-globals] ----------------------------------

##
# setup global status: ${args}.
#


- meta:
   version: 1.0.0
   script:
    name: "${X_SRC_NAME}"
    file: "$XS"  

- revision:
   source:
    info: |
$(env | grep ^REV_ | sl)

- workspce:
   paths:
    curr: "$(pwd)"
    work: "${X_WORK}"
    logs: "${X_LOGS}"
    temp: "${X_TEMP}"
   contents: |
$(ls -l pyproject.toml poetry.lock DESCRIPTION renv.lock package.json yarn.lock | sl)

- host:
   hostname: "$(hostname)"
   release: |
$(lsb_release -a 2>/dev/null | sl)
 
- user:
   userid: "${USER}"
   home: "${HOME}"
   shell: "${SHELL}"
   id: |
$(id | sl)

- system-env:
   path: |
$(echo "${PATH}" | tr ':' '\n' | sl)
   library_path: |
$(echo "${LD_LIBRARY_PATH}" | tr ':' '\n' | sl)
   python: "$(which python)"
   python-version: "$(which python >/dev/null && python --version | head -n1)"

- mount:
   df: |
$(df -h | sl)


# }}} -----
   
EOF

}

dump_extras_status() {
    cat <<EOF
# {{{ --- [setup-extras] ----------------------------------

##
# setup extra languge and tools: ${args}
#

- rust:
   environ:
    CARGO_HOME: "${CARGO_HOME}"
    RUSTUP_HOME: "${RUSTUP_HOME}"
   binaries:
    cargo:
     path: |
$(which cargo  2>/dev/null || echo "NOCARGO" | sk)
     vers: |
$(cargo --version || echo "NOCARGO" | sk)
    rustup:
     path: |
$(which rustup  2>/dev/null || echo "NOCARGO" | sk)
     vers: |
$(rustup --version || echo "NOCARGO" | sk)
    rustc:
     path: |
$(which rustc  2>/dev/null || echo "NOCARGO" | sk)
     vers: |
$(rustc --version || echo "NOCARGO" | sk)


- node:
   environ:
    NODE_VERSION: "${NODE_VERSION}"
    FNM_DIR: "${FNM_DIR}"
   binaries:
    fnm:
     path: |
$(which fnm  2>/dev/null || echo "NOFNM" | sk)
     vers: |
$(fnm --version || echo "NOFNM" | sk)
    node:
     path: |
$(which node  2>/dev/null || echo "NONODE" | sk)
     vers: |
$(node --version || echo "NONODE" | sk)
    npm:
     path: |
$(which npm 2>/dev/null || echo "NONPM" | sk)
     vers: |
$(npm --version || echo "NONPM" | sk)

 

# }}} -----
   
EOF

}


dump_venv_status() {
    cat <<EOF
# {{{ --- [setup-venv] ----------------------------------
    
##
# setup python venv status: ${args}
#

- virtual-env:
   paths:
    path: |
$(echo "${PATH}" | tr ':' '\n' | sl)
    library_path: |
$(echo "${LD_LIBRARY_PATH}" | tr ':' '\n' | sl)
    python: "$(which python || )"
    python-version: "$(python --version || echo "NOPYTHON")"
    poetry: "$(which poetry)"
    poetry-version: "$(poetry --version)"
    jupyter: "$(which jupyter)"
    jupyter-version: "$(jupyter --version)"
   poetry-venv: |
$(poetry env info | sl)

- r-bindings:
   config:
     reticulate: |
$(R -e "reticulate::py_config()" | sl)

- jupyter:
   paths:
    jupyter-version: "$(which jupyter 2>/dev/null && jupyter --version)"
   config:
     lab-extensions: |
$(jupyter labextension list || echo "NOJUPYTER" | sl)
     kernels: |
$(jupyter kernelspec list || echo "NOJUPYTER" | sl)

- python-deps
   list: |
$(poetry show | sl)
   project: |
$(ls -l pyproject.toml poetry.lock | sl)
 

# }}} -----
   
EOF

}

dump_renv_status() {
    cat <<EOF
# {{{ --- [setup-renv] ----------------------------------
    
##
# setup R renv status: ${args}
#

- renv:
   paths:
    path: |
$(echo "${PATH}" | tr ':' '\n' | sl)
    library_path: |
$(echo "${LD_LIBRARY_PATH" | tr ':' '\n' | sl)
    R: "$(which R)"
    R-version: "$(which R >/dev/null && R --version | tr '"' '\'' | head -n1)"

- rdeps
   project: |
$(ls -l DESCRIPTION renv.lock | sl)
 

# }}} -----
   
EOF

}





dump_status_full() {
    
    dump_header_status
    dump_global_status
    dump_extras_status
    
    if poetry env list > /dev/null; then
        ( source $(poetry env info --path)/bin/activate

            dump_venv_status
            dump_renv_status

            
          which python
          python --version

          R -q -e 'reticulate::py_discover_config(required_module = NULL, use_environment = NULL)'

          R -e "reticulate::py_config()"
          
          
        )
    else
        (
            dump_renv_status
        )
    fi
}

dump_status() {

    mkdir -p $X_LOGS
    X_DUMPFILE="${X_LOGS}/${X_NAME}-${X_TS}-$(id -u).yml"

    (dump_status_full) 2>&1 | tee -a $X_DUMPFILE 

    ls -l "$X_DUMPFILE"
    echo  "$X_DUMPFILE"
    
}

exit_status() {
    
    dump_status
    exit 0
}

# --------------------------------------------------------------

docs_renv_refs() {
    cat <<'EOF'
---
# R config

## R environment settings

* [Managing R with .Rprofile, .Renviron, Rprofile.site, Renviron.site, rsession.conf, and repos.conf](https://support.posit.co/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf)

> R will source only one .Rprofile file.
> So if you have both a project-specific .Rprofile file and a user .Rprofile file
> that you want to use, you explicitly source the user-level .Rprofile
> at the top of your project-level .Rprofile with source("~/.Rprofile").


* [Setting same R library order in RStudio Server and command-line R](https://forum.posit.co/t/setting-same-r-library-order-in-rstudio-server-and-command-line-r/169545/3)

> Then R searches for the site-wide startup profile file of R code
> unless the command line option ‘--no-site-file’ was given.  The
> path of this file is taken from the value of the ‘R_PROFILE’
> environment variable (after tilde expansion).  If this variable is
> unset, the default is ‘R_HOME/etc/Rprofile.site’, which is used if
> it exists (which it does not in a ‘factory-fresh’ installation).

EOF

}



docs_refs() {
    docs_renv_refs
}

# --------------------------------------------------------------
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
C_Cyan='\033[0;36m'
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

CLOG=""
LCTX="-"
LOG_LEVEL=""
: ${X_ASK:="0"}

ask_exit() {
    if [ "$X_ASK" != "1" ]; then
	return 0
    fi
    printf "\n${C_BIYellow}+++ ??? $* ... [Y/n]${C_OFF}\n"
    read -t 10 z
    case "$z" in
        Y|y) return 0;;
        N|n) exit ${exit_rc:-1};;
    esac
    return 1
}
show() {
    if [ -z "${X_LOGFILE}" ]; then
        cat
    else
        cat | tee -a ${X_LOGFILE} 1>&2
    fi
}
_log() {
    local mess
    local llev
    local lwho
    llev=$(printf '%-5s' ${LOG_LEVEL:-'LOG'})
    lwho=$(printf '%s@%s' ${USER} $(hostname))
    mess="${CLOG}$(date '+%Y-%m-%d %H:%M:%S %s') | $lwho | $llev | ${LCTX} | $$ | $* ${C_OFF}"
    if [ -z "${X_LOGFILE}" ]; then
        echo -e "${mess}"
    else
        echo -e "${mess}" | tee -a ${X_LOGFILE} 1>&2
    fi
}
trace() { [ "${EX_TRACE}" = "1" ] && LOG_LEVEL='TRACE' CLOG="$C_Black" _log $*; }
dump()  { LOG_LEVEL='DUMP.' CLOG="$C_Cyan"     _log $*; }
debug() { LOG_LEVEL='DEBUG' CLOG="$C_Green"    _log $*; }
info()  { LOG_LEVEL='INFO.' CLOG="$C_BIBlue"   _log $*; }
warn()  { LOG_LEVEL='WARN.' CLOG="$C_BYellow"  _log $*; }
error() { LOG_LEVEL='ERROR' CLOG="$C_IRed"     _log $*; }
fatal() { LOG_LEVEL='FATAL' CLOG="$C_BIRed"    _log $*; }
log()   { LOG_LEVEL='_LOG_' CLOG="$C_BBlue"    _log $*; }
die ()  { fatal $*; ask_exit; }
fail () { fatal $@; } # halt ...
todo () { warn "#TODO: " $*; }
# --------------------------------------------------------------
rc_init() {
    exit_rc=0
}
rc_exit() {
    rc=$?
    : ${exit_rc:='0'}
    [ "${exit_rc}" = '0' ] && exit_rc=$rc

    if [ "${rc}" != '0' ]; then
        echo "$(date) - ERROR: rc=($rc) -- $*"
    fi
    return $exit_rc
}
arg_defined () {
	if [ -z "$1" ]; then
	   shift
	   fatal "ARG/NULL: $*"
	   exit 1
	fi
}
arg_error () { fatal "ARG/ERROR: $*"; exit 1; }
env_defined () {
	name="$1"
	eval value="\$${name}"
	if [ -z "$value" ]; then
	   shift
	   fatal "ENV/NULL: ${name}"
	   exit 1
	fi
}
env_error () { fatal "ENV/ERROR: $*"; exit 1; }
# --------------------------------------------------------------
env_dump() {

	echo "#- ARGS/SCRIPT: $XS" >> ${X_WORK}/env-args.txt
	echo -n "#- ARGS/ENV:\n"      >> ${X_WORK}/env-args.txt
	env | sed -e's/&sig=[^ &]*//' | sort >> ${X_WORK}/env-args.txt

}
check_is_root()  { [ "$(id -u)" == "0" ] || die "must run as root: $(whoami)"; }
check_not_root() { [ "$(id -u)" == "0" ] && die "cannot run as root: $(whoami)"; }
# --------------------------------------------------------------
mk_public_dir() {
    [ -z "$1" ] && return 1
    if [ ! -d "$1" ]; then
        mk_public_dir $(dirname $1)
        mkdir -p $1  || die "cannot create public dir: $1"
        chmod 777 $1 || die "cannot chmod public dir: $1"
    fi
}

wk_init() {
    [ -z "$X_WORK" ] && return 0
    mk_public_dir "$X_WORK"
    cd "$X_WORK"
}

wk_exit() {
    [ -z "$X_WORK" ] && return 0
}

open_logs() {
    [ -z "${X_LOGFILE}" ] && return 0
    mk_public_dir "$(dirname ${X_LOGFILE})"
    touch "${X_LOGFILE}"
}

close_logs() {
    [ -z "${X_LOGFILE}" ] && return 0
    return 0
}

_init() {
    rc_init
    wk_init
    open_logs
    _INIT_=1
}

_exit() {
    close_logs
    wk_exit
}

enter_main() {
   _init
   env_dump
}

exit_main() {
    case "$exit_rc" in
        0)
            info "+++[${X_NAME}]: OK($RC) done."
            ;;
        *)
            error "+++[${X_NAME}]: KO($RC) failed!"
            ;;
    esac
    _exit
}


# ////////////////////////////////////////////////////////////////////////


deactivate () {
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




# ////////////////////////////////////////////////////////////////////////

do_py_init() {

    log ">(do_py_init):" "py - venv init, ..."
    
    if [ -n "$VIRTUAL_ENV" ]; then
        warn "+(do_py_init):" "py - venv active: VIRTUAL_ENV=$VIRTUAL_ENV, deactivating, ..."
        # unset irrelevant variables
        deactivate nondestructive
        warn "+(do_py_init):" "py - venv active: VIRTUAL_ENV=$VIRTUAL_ENV, deactivating, done."
    fi

    poetry env info
    poetry env list
    log "+(do_py_init):" "py - venv detected: (rc:$?)"

    log "<(do_py_init):" "py - venv init,  done."
    
}


do_py_remove() {

    log ">(do_py_remove):" "py - venv remove, ..."

    if poetry env list > /dev/null; then
        poetry env remove $(poetry env list)
    else
        warn "venv  not found, skip"
    fi

    log "<(do_py_remove):" "py - venv remove,  done."
    
}

do_py_dots() {

    log ">(do_py_dots):" "py - dots remove, ..."

    set -x

    [ -d ~/.ipython ] && rm -rf ~/.ipython
    [ -d ~/.jupyter ] && rm -rf ~/.jupyter

    set +x

    log "<(do_py_dots):" "py - dots remove,  done."
    
}

do_py_cache() {

    log ">(do_py_cache):" "py - cache remove, ..."

    set -x

    [ -d ~/.npm ] && rm -rf ~/.npm
    [ -d ~/.yarn ] && rm -rf ~/.yarn
    [ -d ~/.local/share/jupyter ] && rm -rf ~/.local/share/jupyter
    [ -d ~/.local/share/pipx ] && rm -rf ~/.local/share/pipx
    [ -d ~/.local/share/virtualenv ] && rm -rf ~/.local/share/virtualenv
    [ -d ~/.local/state/fnm_multishells ] && rm -rf ~/.local/state/fnm_multishells
    [ -d ~/.cache/pipx ] && rm -rf ~/.cache/pipx
    [ -d ~/.cache/pypoetry ] && rm -rf ~/.cache/pypoetry

    [ -d ./.yarn ] && rm -rf ./yarn
    [ -d ./node_modules ] && rm -rf ./node_modules/*

    set +x

    log "<(do_py_cache):" "py - cache remove,  done."
    
}



do_py_venv() {

    log ">(do_py_venv):" "py - venv define, ..."

    if ! poetry env list > /dev/null; then
        #poetry config virtualenvs.create true --local
        #poetry config virtualenvs.in-project false --local
        poetry env use $(which python)
        [ -L ./venv ] && rm ./venv
        ln -s "~/$(realpath $(poetry  env info -p) --relative-to=$HOME -s)" ./venv
        info "venv $(poetry env list) defined."
        poetry env info | show
    else
        warn "venv $(poetry env list) already defined, skip"
    fi

    
    log "<(do_py_venv):" "py - venv define,  done."
    
}


do_py_reset() {

    log ">(do_py_reset):" "py - unlock, ..."

    if [ -f ./poetry.lock ]; then
        rm ./poetry.lock
    else
        warn "./poetry.lock not found, skip"
    fi

    do_py_remove

    log "<(do_py_reset):" "py - unlock,  done."
    
}

do_py_clear() {

    log ">(do_py_clear):" "py - clear($X_DOTS_MODE$X_CACHE_MODE), ..."

    do_py_remove

    if [ "$X_DOTS_MODE" = "1" ]; then
        do_py_dots
    fi
       
    if [ "$X_CACHE_MODE" = "1" ]; then
        do_py_cache
    fi

    log "<(do_py_clear):" "py clear($X_DOTS_MODE$X_CACHE_MODE), done."
    
}

do_py_lock() {

    log ">(do_py_lock):" "py - lock, ..."

    if [ ! -f ./poetry.lock ]; then
        export PYTHON_KEYRING_BACKEND="keyring.backends.null.Keyring"
        poetry lock
        info "./poetry.lock created."
        poetry show | show
    else
        log "./poetry.lock found, skip"
    fi

    log "<(do_py_lock):" "py - lock,  done."
    
}

do_py_install() {

    log ">(do_py_install):" "py - install define, ..."

    export PYTHON_KEYRING_BACKEND="keyring.backends.null.Keyring"
    
    poetry install --no-interaction -vv
    
    info "poetry install -- (rc: $?) -- from $(ls -l poetry.lock)"
    
    log "<(do_py_install):" "py - install,  done."
    
}


do_py_reticulate() {

    log ">(do_py_reticulate):" "py - reticulate config, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      which python
      python --version

      # @see: docker/r-images/scripts/base/install_ubs-py_lang.sh
      
      # R - python
      # install2.r --error --skipmissing --skipinstalled -n $NCPUS  reticulate

      
      # @see: https://rstudio.github.io/reticulate/articles/versions.html#order-of-discovery

      eval "export X_ENV_PATH=$(bash --login -i -c 'printf \"%s\" "$PATH"' | tail -n1)"
      eval "export X_ENV_VENV=$(poetry env info --path)"

      export RETICULATE_PYTHON_ENV="$(poetry env info --path)"

      touch ~/.Rsession
      touch ~/.Renviron
    
      sed -i '/PATH=/d' \
          ~/.Renviron

      sed -i '/VIRTUAL_ENV=/d' \
          ~/.Renviron

      sed -i '/RETICULATE_PYTHON_ENV=/d' \
          ~/.Renviron

      cat <<EOR >> ~/.Renviron
PATH=${X_ENV_PATH}
#X_ENV_VENV=${X_ENV_VENV}
#VIRTUAL_ENV=${VIRTUAL_ENV}
RETICULATE_PYTHON_ENV=${RETICULATE_PYTHON_ENV}
_R_CHECK_SYSTEM_CLOCK_=0
EOR
    
      
      
      R -q -e 'reticulate::py_discover_config(required_module = NULL, use_environment = NULL)'

      R -e "reticulate::py_config()"
      
      
    )

    log "<(do_py_reticulate):" "py - reticulate config, done."
    
}


do_py_jupyter_build() {

    log ">(do_py_jupyter):" "py - jupyter prepare, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      [ -f ~/.jupyter/jupyter_server_config.py ] || \
          jupyter server --generate-config

      jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

      
      log "-(do_py_jupyter):" "py - jupyter node check, ..."
      set -x
      which -a node
      node --version
      which -a jlpm
      jlpm --version
      set +x
      log "-(do_py_jupyter):" "py - jupyter node check (node version: $(node --version)), don"
      
      if [ ! -f ./.yarnrc.yml ] ; then
          warn "jupyter ./.yarnrc.yml not found, ..."
          echo "nodeLinker: node-modules"  > ./.yarnrc.yml
          info "jupyter ./.yarnrc.yml created"
      fi

      if [ ! -f ./package.json ] ; then

          warn "jupyter ./package.json not found, ..."
          
          jlpm init

          jlpm add --dev  \
               bash-language-server \
               dockerfile-language-server-nodejs \
               pyright \
               sql-language-server \
               typescript-language-server \
               unified-language-server \
               vscode-css-languageserver-bin \
               vscode-html-languageserver-bin \
               vscode-json-languageserver-bin \
               yaml-language-server
          
          info "jupyter ./package.json created"
      fi
      
      if [ ! -f ./yarn.lock ] ; then

          warn "jupyter ./yarn.lock not found, ..."
          
          jlpm up
          
          info "jupyter ./yarn.lock created"
      fi

      jlpm install

      jupyter lab clean --all
      jupyter lab build --debug
      
      
    )

    log "<(do_py_jupyter):" "py - jupyter prepare,  done."
    
}

do_py_irkernel_reg() {

    log ">(do_py_irkernel):" "py - irkernel install, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate


      # @see: https://github.com/IRkernel/IRkernel

      R --quiet   -e 'IRkernel::installspec()'

      jupyter labextension install @techrah/text-shortcuts  # for RStudio’s shortcuts
      
    )

    log "<(do_py_irkernel):" "py - irkernel install,  done."
    
}



do_py_jupyter_show() {

    log ">(do_py_jupyter_show):" "py - jupyter show, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      which python
      which jupyter

      python --version
      jupyter --version

      jupyter --paths

      jupyter labextension list
      jupyter kernelspec list
      
      
    )

    log "<(do_py_jupyter_show):" "py - jupyter show,  done."
    
}

do_py_show() {

    log ">(do_py_show):" "py - show config, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      which python
      python --version

      case "$X_VERBOSE" in
          1*)
              poetry show
              ;;
          12*)
              poetry show --tree
              ;;
          *)
              ;;
      esac    

      R -e "reticulate::py_config()"
      
    )

    log "<(do_py_show):" "py - show config, done."
    
}




# ////////////////////////////////////////////////////////////////////////

do_re_remove() {

    log ">(do_re_remove):" "re - renv packages remove, ..."

    if [ -d ~/.cache/R/renv ]; then
        chmod -R a+w ~/.cache/R/renv
        rm -rf       ~/.cache/R/renv
    else
        warn "renv not found, skip"
    fi

    log "<(do_re_remove):" "re - renv packages remove, done."
    
}

do_re_dots() {

    log ">(do_re_dots):" "re - dots remove, ..."

    set -x

    [ -f ~/.Renviron ] && rm -rf ~/.Renviron
    
    # [ -f ./renv/activate.R ] && rm -rf ./renv/activate.R

    set +x

    log "<(do_re_dots):" "re - dots remove,  done."
    
}

do_re_cache() {

    log ">(do_re_cache):" "re - cache remove, ..."

    set -x

    [ -d ./renv/sandbox ] && rm -rf ./renv/sandbox
    [ -d ./renv/library ] && rm -rf ./renv/library
    [ -d ./renv/local ] && rm -rf ./renv/local
    [ -d ./renv/cellar ] && rm -rf ./renv/cellar
    [ -d ./renv/lock ] && rm -rf ./renv/lock
    [ -d ./renv/python ] && rm -rf ./renv/python
    [ -d ./renv/staging ] && rm -rf ./renv/staging

    set +x

    log "<(do_re_cache):" "re - cache remove,  done."
    
}




do_re_clear() {

    log ">(do_re_clear):" "re - clear($X_DOTS_MODE$X_CACHE_MODE), ..."

    do_re_remove

    if [ "$X_DOTS_MODE" = "1" ]; then
        do_re_dots
    fi
       
    if [ "$X_CACHE_MODE" = "1" ]; then
        do_re_cache
    fi

    log "<(do_re_clear):" "re clear($X_DOTS_MODE$X_CACHE_MODE), done."
    
}


do_renv_init() {

    log ">(do_renv_init):" "renv - init, ..."

    # run in poetry shell -- venv activated

    if [ -f ./renv/activate.R ]; then
        log "-(do_renv_init):" "renv - init, ./renv/activate.R found: skip"
        return 0
    fi
    

    X_SAVE_RENV="${X_SAVE}/renv"
    X_SAVE_RENV_PRE="${X_SAVE_RENV}/init-pre"
    X_SAVE_RENV_POST="${X_SAVE_RENV}/init-post"

    mkdir -p $X_SAVE_RENV_PRE
    mkdir -p $X_SAVE_RENV_POST

    [ -f ./.Rprofile ]          && mv ./.Rprofile          $X_SAVE_RENV_PRE
    [ -f ./renv.lock ]          && mv ./renv.lock          $X_SAVE_RENV_PRE
    [ -f ./renv/settings.json ] && mv ./renv/settings.json $X_SAVE_RENV_PRE
    [ -f ./renv/activate.R ]    && mv ./renv/activate.R    $X_SAVE_RENV_PRE

    R -q -e 'renv::init(bare=TRUE, load=FALSE)' ; rc_renv_init=$?
    
    case "$rc_renv_init" in
        0) info "=(do_renv_init):" "renv - init => ok" ;;
        *) error "#(do_renv_init):" "renv - init => KO -- (rc:$rc_renv_init)" ;;
    esac    
    
    [ -f ./.Rprofile ]          && cp ./.Rprofile          $X_SAVE_RENV_POST
    [ -f ./renv.lock ]          && cp ./renv.lock          $X_SAVE_RENV_POST
    [ -f ./renv/settings.json ] && cp ./renv/settings.json $X_SAVE_RENV_POST
    [ -f ./renv/activate.R ]    && cp ./renv/activate.R    $X_SAVE_RENV_POST

    cp -pv $X_SAVE_RENV_PRE/.Rprofile      ./.Rprofile
    # cp -pv $X_SAVE_RENV_PRE/renv.lock    ./renv.lock
    cp -pv $X_SAVE_RENV_PRE/settings.json  ./renv/settings.json
    cp -pv $X_SAVE_RENV_POST/activate.R    ./renv/activate.R

    set -x

    [ -f $X_SAVE_RENV_PRE/.Rprofile ] && [ -f $X_SAVE_RENV_POST/.Rprofile ] && \
        diff $X_SAVE_RENV_PRE/.Rprofile $X_SAVE_RENV_POST/.Rprofile

    [ -f $X_SAVE_RENV_PRE/settings.json ] && [ -f $X_SAVE_RENV_POST/settings.json ] && \
        diff $X_SAVE_RENV_PRE/settings.json $X_SAVE_RENV_POST/settings.json


    set +x

    log "<(do_renv_install):" "renv - install, done."
    
    return $rc_renv_install
}


do_renv_install() {

    log ">(do_renv_install):" "renv - install, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      R -q -e 'renv::install(dependencies = TRUE)' ; rc_renv_install=$?

      case "$rc_renv_install" in
          0) info "=(do_renv_install):" "renv - install => ok" ;;
          *) error "#(do_renv_install):" "renv - install => KO -- (rc:$rc_renv_install)" ;;
      esac    
      
    )

    log "<(do_renv_install):" "renv - install, done."
    
    return $rc_renv_install
}

do_renv_upgrade() {

    log ">(do_renv_upgrade):" "renv - upgrade, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      R -q -e 'renv::upgrade()' ; rc_renv_upgrade=$?

      case "$rc_renv_upgrade" in
          0) info "=(do_renv_upgrade):" "renv - upgrade => ok" ;;
          *) error "#(do_renv_upgrade):" "renv - upgrade => KO -- (rc:$rc_renv_upgrade)" ;;
      esac    
      
    )

    log "<(do_renv_upgrade):" "renv - upgrade, done."
    
    return $rc_renv_upgrade
}

do_renv_snapshot() {

    log ">(do_renv_snapshot):" "renv - snapshot, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      R -q -e 'renv::snapshot()' ; rc_renv_snapshot=$?

      case "$rc_renv_snapshot" in
          0) info "=(do_renv_snapshot):" "renv - snapshot => ok" ;;
          *) error "#(do_renv_snapshot):" "renv - snapshot => KO -- (rc:$rc_renv_snapshot)" ;;
      esac    
      
    )

    log "<(do_renv_snapshot):" "renv - snapshot, done."
    
    return $rc_renv_snapshot
}

do_renv_restore() {

    log ">(do_renv_restore):" "renv - restore, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      R -q -e 'renv::restore()' ; rc_renv_restore=$?

      case "$rc_renv_restore" in
          0) info "=(do_renv_restore):" "renv - restore => ok" ;;
          *) error "#(do_renv_restore):" "renv - restore => KO -- (rc:$rc_renv_restore)" ;;
      esac    
      
    )

    log "<(do_renv_restore):" "renv - restore, done."

    return $rc_renv_restore
    
}

do_renv_show() {

    log ">(do_renv_show):" "renv - show status, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      R -q -e 'renv::status()'

      log ":(do_renv_show):" "Project::DESCRIPTION: $(ls -l DESCRIPTION)"
      log ":(do_renv_show):" "Project::renv.lock:   $(ls -l renv.lock)"

    )

    log "<(do_renv_show):" "renv - show status, done."
    
}


do_renv_reset() {

    log ">(do_renv_reset):" "renv - reset, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate
      
      if [ -f ./renv.lock ]; then
          rm ./renv.lock
      else
          warn "./renv.lock not found, skip"
      fi
      
    )

    log "<(do_renv_reset):" "renv - reset, done."
    
}

do_re_setup() {

    log ">(do_re_setup):" "renv - setup, ..."

    do_renv_init
    do_renv_show
    
    if [ "$RUN_RE_RESTORE" = "1" ] && \
           [ -f ./renv.lock ]; then

        do_renv_restore ; rc_renv_restore=$?
    
        case "$rc_renv_restore" in
            0) ;;
            *) return $rc_renv_restore
               ;;
        esac
        
    else

        do_renv_install ; rc_renv_install=$?
    
        case "$rc_renv_install" in
            0) ;;
            *) return $rc_renv_install
               ;;
        esac

        if [ "$RUN_RE_UPGRADE" = "-1" ] ; then
        
            do_renv_upgrade ; rc_renv_upgrade=$?
    
            case "$rc_renv_upgrade" in
                0) ;;
                *) return $rc_renv_upgrade
                   ;;
            esac    
        
        fi
        
        do_renv_snapshot
        
    fi
    do_renv_show

    log "<(do_re_setup):" "renv - setup, done."
    
}

do_re_force() {

    log ">(do_re_upgrade):" "renv - upgrade, ..."

    do_renv_reset
    do_renv_setup
    
    log "<(do_re_upgrade):" "renv - upgrade, done."
    
}

# ////////////////////////////////////////////////////////////////////////

do_js_code() {

    log ">(do_js_code):" "js - code server config, ..."

    if [ -f ~/.config/code-server/config.yaml ] && \
       grep -q '#@setup:' ~/.config/code-server/config.yaml; then
        log ".(do_js_code):" "js - code server already configured, skip."
    else

        X_SAVE_CODE="${X_SAVE}/code"
        X_SAVE_CODE_PRE="${X_SAVE_CODE}/init-pre"
        X_SAVE_CODE_POST="${X_SAVE_CODE}/init-post"

        mkdir -p $X_SAVE_CODE_PRE
        mkdir -p $X_SAVE_CODE_POST

        

        [ -f ~/.config/code-server/config.yaml ] && \
            mv ~/.config/code-server/config.yaml    $X_SAVE_CODE_PRE

        if [ -f ~/.config/code-server/custom.yaml ]; then
            cp -pv ~/.config/code-server/custom.yaml ~/.config/code-server/config.yaml
        else

            mkdir -p    ~/.config/code-server
            cat <<EOF > ~/.config/code-server/config.yaml
#@setup: $(date)
bind-addr: 127.0.0.1:8686
auth: password
password: ${PASSWORD}
cert: false
EOF

        fi    

        [ -f ~/.config/code-server/config.yaml ] && \
            cp ~/.config/code-server/config.yaml    $X_SAVE_CODE_POST
    fi

    log "<(do_js_code):" "js - code server config, done."
    
}



# ////////////////////////////////////////////////////////////////////////

parse_args_run() {
    
    if [ $# -lt 1 ];then
        set -- $@ --status
    fi
    
    args="$@"
    log ">(args.run):" "$args"

    set -x
    
    RUN_PY_CLEAR=0
    RUN_PY_RESET=0
    RUN_PY_VENV=0
    RUN_PY_INSTALL=0
    RUN_PY_SHOW=0
    RUN_JS_CODE=0
    RUN_RE_CLEAR=0
    RUN_RE_RESET=0
    RUN_RE_SETUP=0
    RUN_RE_UPGRADE=0
    RUN_RE_RESTORE=0
    RUN_RE_SHOW=0
    
    X_ALL_MODE=1
    X_PYTHON_MODE=0
    X_R_MODE=0
    cmds=""

    while [ $# -gt 0 ]; do
        case "$1" in
            
            --clear)
                RUN_PY_CLEAR=1
                RUN_RE_CLEAR=1
                cmds="$cmds --clear"
                ;;
            
            --upgrade)
                RUN_PY_RESET=1
                RUN_RE_RESET=1
                RUN_RE_UPGRADE="$Y_RE_RENV_UPGRADE"
                RUN_RE_RESTORE="$Y_RE_RENV_RESTORE"
                cmds="$cmds --upgrade"
                ;;
            
            --all)
                RUN_PY_VENV=1
                RUN_PY_INSTALL=1
                RUN_PY_BIND=1
                RUN_PY_JUPYTER=1
                RUN_PY_SHOW=1
                RUN_JS_CODE=1
                RUN_RE_SETUP=1
                RUN_RE_UPGRADE="$Y_RE_RENV_UPGRADE"
                RUN_RE_RESTORE="$Y_RE_RENV_RESTORE"
                cmds="$cmds --install --all"
                ;;
            
            --status|-s)
                RUN_STATUS=1
                RUN_PY_SHOW=1
                RUN_RE_SHOW=1
                cmds="$cmds --status"
                ;;
            
            --python|-P)
                X_ALL_MODE:='0'
                X_PYTHON_MODE:='1'
                cmds="$cmds -P"
                ;;
            
            --r|-R)
                X_ALL_MODE:='0'
                X_R_MODE:='1'
                cmds="$cmds -R"
                ;;
            
            --full|-F)
                X_FULL_MODE='1'
                X_CACHE_MODE='1'
                X_DOTS_MODE='1'
                cmds="$cmds -F"
                ;;
            
            --dots|-D)
                X_DOTS_MODE:='1'
                cmds="$cmds -D"
                ;;
            
            --cache|-C)
                X_CACHE_MODE:='1'
                cmds="$cmds -C"
                ;;
            
            --verbose|-v)
                X_VERBOSE:='1'
                cmds="$cmds -v"
                ;;
            
            -vv)
                X_VERBOSE:='12'
                cmds="$cmds -vv"
                ;;
            
            -vvv)
                X_VERBOSE:='123'
                cmds="$cmds -vvv"
                ;;
            
            *)
                exit_usage $@
                ;;
        esac
        shift
    done

    PY_OPTS=""
    PY_OPTS="$PY_OPTS:$Y_PY_SYSTEM_SUPPORT"
    PY_OPTS="$PY_OPTS:$Y_PY_PYENV_SUPPORT"
    PY_OPTS="$PY_OPTS:$Y_PY_POETRY_SUPPORT"
    
    case "$PY_OPTS" in
        :1:*|:*:0:*|:*:*:0)
            RUN_PY_CLEAR=0
            RUN_PY_RESET=0
            RUN_PY_VENV=0
            RUN_PY_INSTALL=0
            RUN_PY_SHOW=0
            ;;
        *)
            ;;
    esac

    RE_OPTS=""
    RE_OPTS="$RE_OPTS:$Y_RE_ANY_SUPPORT"
    RE_OPTS="$RE_OPTS:$Y_RE_RENV_SUPPORT"
    RE_OPTS="$RE_OPTS:$Y_RE_RENV_INSTALL"
    
    case "$RE_OPTS" in
        :0:*|:*:0:*|:*:*:0)
            RUN_RE_CLEAR=0
            RUN_RE_RESET=0
            RUN_RE_SETUP=0
            RUN_RE_RESTORE=0
            RUN_RE_UPGRADE=0
            RUN_RE_SHOW=0
            ;;
        *)
            ;;
    esac

    case "$X_ALL_MODE" in
        1)
            X_PYTHON_MODE="1"
            X_R_MODE="1"
            X_CODE_MODE="1"
            ;;
        *)  ;;
    esac


    case "$X_PYTHON_MODE" in
        0)
            RUN_PY_CLEAR=0
            RUN_PY_RESET=0
            RUN_PY_VENV=0
            RUN_PY_INSTALL=0
            RUN_PY_SHOW=0
            ;;
        *)  ;;
    esac

    case "$X_R_MODE" in
        0)
            RUN_RE_CLEAR=0
            RUN_RE_RESET=0
            RUN_RE_SETUP=0
            RUN_RE_RESTORE=0
            RUN_RE_UPGRADE=0
            RUN_RE_SHOW=0
            ;;
        *)  ;;
    esac

    case "$X_CODE_MODE" in
        0)
            RUN_JS_CODE=0
            ;;
        *)  ;;
    esac

    set +x

    debug "#(args): {\n $(set | sort | grep -e ^PY_OPTS -e ^RE_OPTS -e ^RUN_  -e ^X_  -e ^Y_ ) \n} ###"
    dump  "#(args): {\n $(set | sort | grep -e ^PY_OPTS -e ^RE_OPTS -e ^RUN_  -e ^X_  -e ^Y_ ) \n} ###"

    env_defined RUN_PY_CLEAR
    env_defined RUN_PY_RESET
    env_defined RUN_PY_INSTALL
    env_defined RUN_PY_VENV
    env_defined RUN_PY_SHOW

    env_defined RUN_RE_CLEAR
    env_defined RUN_RE_RESET
    env_defined RUN_RE_SETUP
    env_defined RUN_RE_RESTORE
    env_defined RUN_RE_UPGRADE
    env_defined RUN_RE_SHOW
    
    env_defined RUN_JS_CODE
    

    log "<(args):" "cmds: $cmds"
    
}

main_run() {

    export X_MODE='run'

    parse_args_run $@

    #check_is_remote

    do_py_init
    do_renv_init
    
    log ">(main.run):" "args:$args -- cmds: $cmds, ..."
    
    if [ "$RUN_PY_CLEAR" = '1' ]; then
        do_py_clear $@
        rc_exit $?
    fi

    if [ "$RUN_PY_RESET" = '1' ]; then
        do_py_reset $@
        rc_exit $?
    fi

    if [ "$RUN_PY_VENV" = '1' ]; then
        do_py_venv $@
        rc_exit $?
    fi

    if [ "$RUN_PY_INSTALL" = '1' ]; then
        do_py_lock $@
        do_py_install $@
        rc_exit $?
    fi

    if [ "$RUN_PY_BIND" = '1' ]; then
        do_py_reticulate $@
        rc_exit $?
    fi

    if [ "$RUN_PY_JUPYTER" = '1' ]; then
        do_py_jupyter_build $@
        do_py_irkernel_reg $@
        do_py_jupyter_show $@
        rc_exit $?
    fi

    if [ "$RUN_PY_SHOW" = '1' ]; then
        do_py_show $@
        rc_exit $?
    fi

    if [ "$RUN_RE_CLEAR" = '1' ]; then
        do_re_clear $@
        rc_exit $?
    fi

    if [ "$RUN_RE_RESET" = '1' ]; then
        do_re_force $@
        rc_exit $?
    fi

    if [ "$RUN_RE_SETUP" = '1' ]; then
        do_re_setup $@
        rc_exit $?
    fi

    if [ "$RUN_RE_SHOW" = '1' ]; then
        do_re_show $@
        rc_exit $?
    fi

    if [ "$RUN_JS_CODE" = '1' ]; then
        do_js_code $@
        rc_exit $?
    fi

    log "<(main.run):" "rc($exit_rc) -- cmds: $cmds, done."
    return $exit_rc
}



# ////////////////////////////////////////////////////////////////////////

main() {

    case "$1" in
        
        --help|-h)
            shift
            exit_usage $@
            ;;
        --status|-s)
            shift
            exit_status $@
            ;;
        *)
            ;;
    esac
    

    enter_main
    
    args="$@"
    log ">(main):" "args: $args, ..."
    
    case "$1" in
        
        *)
            main_run $@
            ;;
    esac

    log "<(main):" "rc($exit_rc) -- args: $args, done."
    
    exit_main
    exit $exit_rc
    
}

case "${X_DRY}" in
    0) main $@ ;;
    *) echo "# skip: main $@"
esac       

