#!/bin/bash

## setup entry point
##

## build ARGs
# set -e
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}


set -a
# ------------------------------------------------------

: ${X_DRY:='0'}
: ${X_PID:=$$}
: ${X_SSH_OPTS:='-x'}
: ${APT_Y:='-y'}
: ${T:=$(date +%F-%H%M%S)}


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

X_NAME="$(basename $X_SRC_SCRIPT .sh)"

X_TEMP="/tmp/$(id -u)"
X_WORK="${X_TEMP}/${X_NAME}"
X_LOGB="$X_WORK"
X_LOGS="${X_LOGB}/${X_TL}"
X_LOGFILE="${X_LOGS}/${X_NAME}-${X_TS}-$(id -u).log"

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


dump_venv_status() {
    cat <<EOF
#vim: set foldmethod=marker :

# {{{ --- setup-venv: [$(hostname)] - $(date) -------------
    
##
# setup python venv status: ${args}
#

- env:
   paths:
    path: "${PATH}"
    library_path: "${LD_LIBRARY_PATH}"
    python: "$(which python)"
    python-version: "$(which python >/dev/null && python --version)"
    poetry: "$(which poetry)"
    poetry-version: "$(which poetry >/dev/null && poetry --version)"
    jupyter: "$(which jupyter)"
    jupyter-version: "$(which jupyter >/dev/null && jupyter --version)"
   venv: |
        $(poetry env info)

- r-bindings:
   config:
     reticulate: |
        $(  -e "reticulate::py_config()")

- jupyter:
   paths:
    jupyter-version: "$(which jupyter >/dev/null && jupyter --version)"
   config:
     lab-extensions: |
        $(jupyter labextension list)
     kernels: |
        $(jupyter kernelspec list)

- deps
   tree: |
$(poetry show --tree)
   list: |
$(poetry show)
   project: |
$(ls -l pyproject.toml poetry.lock)
 

# }}} -----
   
EOF

}

dump_renv_status() {
    cat <<EOF
#vim: set foldmethod=marker :

# {{{ --- setup-renv: [$(hostname)] - $(date) -------------
    
##
# setup R renv status: ${args}
#

- env:
   paths:
    path: "${PATH}"
    library_path: "${LD_LIBRARY_PATH}"
    R: "$(which R)"
    R-version: "$(which R >/dev/null && R --version)"

- deps
   project: |
$(ls -l DESCRIPTION renv.lock)
 

# }}} -----
   
EOF

}



dump_global_status() {
    cat <<EOF
# {{{ --- setup-globals: [$(hostname)] - $(date) -------------
    
##
# setup global status: ${args}
#


- meta:
   version: 1.0.0
   script:
     name: "${X_SRC_NAME}"
     path: "$XS"  
     info: |
        $(ls -l $XS)

- revision:
   source:
     info: |
        $(env | grep ^REV_)

- host:
   hostname: "$(hostname)"
   release: |
$(lsb_release -a 2>/dev/null)
 
- user:
   userid: "${USER}"
   home: "${HOME}"
   shell: "${SHELL}"
   id: |
$(id)

- env:
   path: "${PATH}"
   library_path: "${LD_LIBRARY_PATH}"
   python: "$(which python)"
   python-version: "$(which python >/dev/null && python --version)"

- login:
    who: |
$(who)
    last: |
$(last -n 10)




- mount:
   df: |
$(df -h)


# }}} -----
   
EOF

}



dump_header_status() {
    cat <<EOF
---
#vim: set foldmethod=marker :

title: "setup status - project environment"
project: "${REV_ID_PROJECT}"
package: "${REV_ID_PACKAGE}"
hostname: "$(hostname)"
version: "${REV_BRANCH_NAME}#${REV_TAG}"
date: "$(date -Idate)"

---
EOF

}



exit_status() {
    
    dump_header_status
    dump_global_status

    if poetry env list > /dev/null; then
        ( source $(poetry env info --path)/bin/activate

            dump_venv_status
            dump_renv_status

            
          which python
          python --version

          # install2.r --error --skipmissing --skipinstalled -n $NCPUS \
              #           reticulate
      
          R -q -e 'reticulate::py_discover_config(required_module = NULL, use_environment = NULL)'

          R -e "reticulate::py_config()"
          
          
        )
    else
        (
            dump_renv_status
        )
    fi
    
    exit 0
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
        echo -e ${mess}
    else
        echo -e ${mess} | tee -a ${X_LOGFILE} 1>&2
    fi
}
trace() { [ "${EX_TRACE}" = "1" ] && LOG_LEVEL='TRACE' CLOG="$C_Black" _log $*; }
debug() { LOG_LEVEL='DEBUG' CLOG="$C_Green"   _log $*; }
info()  { LOG_LEVEL='INFO.'  CLOG="$C_BIBlue"  _log $*; }
warn()  { LOG_LEVEL='WARN.'  CLOG="$C_BYellow" _log $*; }
error() { LOG_LEVEL='ERROR' CLOG="$C_IRed"    _log $*; }
fatal() { LOG_LEVEL='FATAL' CLOG="$C_BIRed"   _log $*; }
log()   { LOG_LEVEL='_LOG_'   CLOG="$C_BBlue"   _log $*; }
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

do_py_remove() {

    log ">(do_py_remove):" "py - venv remove, ..."

    if poetry env list > /dev/null; then
        poetry env remove $(poetry env list)
    else
        warn "venv  not found, skip"
    fi

    log "<(do_py_remove):" "py - venv remove,  done."
    
}

do_py_venv() {

    log ">(do_py_venv):" "py - venv define, ..."

    if ! poetry env list > /dev/null; then
        poetry config virtualenvs.create true --local
        poetry config virtualenvs.in-project true --local
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
    
    log "<(do_py_install):" "py - install,  done."
    
}


do_py_reticulate() {

    log ">(do_py_reticulate):" "py - reticulate config, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      which python
      python --version

      # install2.r --error --skipmissing --skipinstalled -n $NCPUS \
      #           reticulate
      
      R -q -e 'reticulate::py_discover_config(required_module = NULL, use_environment = NULL)'

      R -e "reticulate::py_config()"
      
      
    )

    log "<(do_py_reticulate):" "py - reticulate config, done."
    
}




do_py_jupyter() {

    log ">(do_py_jupyter):" "py - jupyter prepare, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      which python
      which jupyter

      python --version
      jupyter --version

      jupyter --paths
      jupyter server --generate-config

      jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

      which -a node
      node --version
      which -a jlpm
      jlpm --version
      
      jupyter --version

      R --quiet   -e 'remotes::install_github("IRkernel/IRkernel@*release")'
      R --vanilla -e 'install.packages("languageserver")'      
      
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
      
      jupyter labextension list
      jupyter kernelspec list
      
      
    )

    log "<(do_py_jupyter):" "py - jupyter prepare,  done."
    
}

do_py_show() {

    log ">(do_py_reticulate):" "py - reticulate config, ..."

    # run in poetry shell -- venv activated

    ( source $(poetry env info --path)/bin/activate

      which python
      python --version

      poetry show --tree

      
    )

    log "<(do_py_reticulate):" "py - reticulate config, done."
    
}




# ////////////////////////////////////////////////////////////////////////

parse_args_run() {


    
    if [ $# -lt 1 ];then
        set -- $@ --status
    fi
    
    args="$@"
    log ">(args.run):" "$args"

    set -x
    
    RUN_PY_RESET=0
    RUN_PY_VENV=1
    RUN_PY_INSTALL=1
    RUN_PY_SHOW=1
    cmds=""

    while [ $# -gt 0 ]; do
        case "$1" in
            
            --upgrade)
                RUN_PY_RESET=1
                cmds="$cmds --upgrade"
                ;;
            
            --all)
                RUN_PY_VENV=1
                RUN_PY_INSTALL=1
                RUN_PY_SHOW=1
                cmds="$cmds --install"
                ;;
            
            --status|-s)
                RUN_STATUS=1
                RUN_PY_SHOW=1
                cmds="$cmds --status"
                ;;
            
            *)
                exit_usage $@
                ;;
        esac
        shift
    done

    PY_OPTS=":"
    PY_OPTS="$PY_OPTS:$Y_PY_SYSTEM_SUPPORT"
    PY_OPTS="$PY_OPTS:$Y_PY_PYENV_SUPPORT"
    PY_OPTS="$PY_OPTS:$Y_PY_POETRY_SUPPORT"
    
    case "$PY_OPTS" in
        :0:*|:*:0:*|:*:0)
            RUN_PY_RESET=0
            RUN_PY_VENV=0
            RUN_PY_INSTALL=0
            RUN_PY_SHOW=0
            ;;
        *)
            ;;
    esac

    set +x

    debug "#(args): {\n $(set | sort | grep -e ^PY_OPTS -e ^RUN_  -e ^X_  -e ^Y_ ) \n} ###"

    env_defined RUN_PY_RESET
    env_defined RUN_PY_INSTALL
    env_defined RUN_PY_VENV
    env_defined RUN_PY_SHOW

    log "<(args):" "cmds: $cmds"
    
}

main_run() {

    export X_MODE='run'

    parse_args_run $@

    #check_is_remote
    
    log ">(main.run):" "args:$args -- cmds: $cmds, ..."
    
    if [ "$RUN_PY_RESET" = '1' ]; then
        do_py_reset $@
        rc_exit $?
    fi

    if [ "$RUN_PY_VENV" = '1' ]; then
        do_py_venv $@
        do_py_lock $@
        do_py_install $@
        rc_exit $?
    fi

    if [ "$RUN_PY_INSTALL" = '1' ]; then
        do_py_venv $@
        do_py_lock $@
        do_py_install $@
        rc_exit $?
    fi

    if [ "$RUN_PY_SHOW" = '1' ]; then
        do_py_show $@
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

