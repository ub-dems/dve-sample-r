#!/bin/bash


##
# taken from /opt/nvidia/nvidia_entrypoint.sh
#
 
# Gather parts in alpha order
shopt -s nullglob extglob
_NV_SCRIPT_DIR="/opt/nvidia"
declare -a _NV_PARTS=( "${_NV_SCRIPT_DIR}/entrypoint.d"/*@(.txt|.sh) )
shopt -u nullglob extglob

# print_repeats() {
#   local -r char="$1" count="$2"
#   local i
#   for ((i=1; i<=$count; i++)); do echo -n "$char"; done
#   echo
# }

# print_banner_text() {
#   # $1: Banner char
#   # $2: Text
#   local banner_char=$1
#   local -r text="$2"
#   local pad="${banner_char}${banner_char}"
#   print_repeats "${banner_char}" $((${#text} + 6))
#   echo "${pad} ${text} ${pad}"
#   print_repeats "${banner_char}" $((${#text} + 6))
# }

nv_run_parts() {

    # Execute the entrypoint parts
    for _file in "${_NV_PARTS[@]}"; do
        case "${_file}" in
            *.txt) cat "${_file}";;
            *.sh)  source "${_file}";;
        esac
    done

echo

}

if [ -x /opt/nvidia/nvidia_entrypoint.sh ]; then

   nv_run_parts

fi


     
