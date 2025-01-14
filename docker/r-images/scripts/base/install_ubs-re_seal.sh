#!/bin/bash

## Set manual package install USER path
##

## @see: https://support.posit.co/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf?_gl=1*io95qh*_ga*NTgzMDQyNDM3LjE3MzY3ODcwMzQ.*_ga_2C0WZ1JHG0*MTczNjc4NzAzNC4xLjEuMTczNjc4NzkxNy4wLjAuMA..

## build ARGs
set -e
source ${Y_BUILD_CONF:-/etc/build.conf}

NCPUS=${NCPUS:--1}


set -a
# ------------------------------------------------------

: ${Y_RE_PKGS_USER:="local"}

: ${R_HOME_USER:="/root"}
: ${R_BASE_USER:="${R_HOME_USER}/.cache/R"}
: ${R_PKGS_USER:="${Y_RE_PKGS_USER}"}
: ${R_LIBS_USER:="${R_BASE_USER}/${R_PKGS_USER}"}

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



function debug_reseal() {
    
    [ "$Y_RE_SEAL_DEBUG" = 1 ] || return 0

    echo "### >> RE-SEAL::DEBUG($@)"
    
    echo "R_HOME_USER=${R_HOME_USER}"
    echo "R_BASE_USER=${R_BASE_USER}"
    echo "R_PKGS_USER=${R_PKGS_USER}"
    echo "R_LIBS_USER=${R_LIBS_USER}"
    
    echo "### << RE-SEAL::DEBUG($@)"
}



function setenv_rehash() {
    
    set +e
    env_dump "setenv_rehash::pre"

    export PS1='# '

    case "${SHELL:-/bin/bash}" in
        */zsh)
            [ -f /etc/zprofile ] && source /etc/zprofile
            #[ -f ~/.zprofile ] && source ~/.zprofile
            #[ -f ~/.zshrc ] && source ~/.zshrc
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

function re_user_environ() {

    [ "$Y_RE_SEAL_ENVIRON" = 1 ] || return 0
    
    debug_reseal "re_seal_environ::pre"

    sed -i '/R_HOME_USER=/d' \
        "${R_HOME}/etc/Renviron.site"
    sed -i '/R_BASE_USER=/d' \
        "${R_HOME}/etc/Renviron.site"
    sed -i '/R_LIBS_USER=/d' \
        "${R_HOME}/etc/Renviron.site"
    
cat <<EOF >>"${R_HOME}/etc/Renviron.site"
R_HOME_USER="${R_HOME_USER}"
R_BASE_USER="${R_BASE_USER}"
R_PKGS_USER="${R_PKGS_USER}"
R_LIBS_USER="${R_LIBS_USER}"
EOF

cat <<EOF >>"${R_HOME}/etc/Rprofile.site"
# ubs(re_seal): #AUTO
# ubs(re_seal): begin ----------------------------

# project_name <- basename(getwd())
project_name <- "${R_PKGS_USER}"
project_lib_path <- file.path(Sys.getenv("R_LIBS_USER"))
dir.create(project_lib_path, recursive = TRUE, showWarnings = FALSE)
.libPaths(c(file.path(project_lib_path), .libPaths()))

# ubs(re_seal): end ------------------------------
EOF

    debug_reseal "re_seal_environ::post"

}


function check_seal() {
    
    [ "$Y_RE_SEAL_CHECK" = 1 ] || return 0

    set -x

    cat "${R_HOME}/etc/Renviron.site" | grep '^R_'
    
    set +x
    
}




function clean_up() {
    :
}




function main() {
    
    [ "$Y_RE_ANY_SUPPORT" = 1 ] || return 0

    env_dump $@

    [ "$Y_RE_SEAL_SUPPORT" = 1 ] || return 0
    
    re_user_environ
    setenv_rehash    

    check_seal

    clean_up


}

main $@
