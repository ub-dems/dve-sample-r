#!/bin/bash

function load_profile() {
    
    #set +e

    export PS1='# '

    case "${SHELL:-/bin/bash}" in
        */zsh)
            [ -f /etc/zprofile ] && source /etc/zprofile
            [ -f ~/.zprofile ] && source ~/.zprofile
            [ -f ~/.zshrc ] && source ~/.zshrc
            ;;
        */bash|*/sh|*)
            [ -f /etc/profile ] && source /etc/profile
            [ -f ~/.profile ] && source ~/.profile
            [ -f ~/.bashrc ] && source ~/.bashrc
            ;;
    esac    
    #set -e
    
}


load_profile
