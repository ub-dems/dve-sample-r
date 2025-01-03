#!/bin/bash

##
# taken from /opt/nvidia/nvidia_entrypoint.sh
#
set -a
[ -f ~/.env ] && source ~/.env || true
[ -f ./.env ] && source ./.env || true
set +a

[ "$X_DEBUG_ENV" = '1' ] && set -x

### printenv | grep ^X_
### set -x

export X_ENTRYPOINT="$0" 

# Gather parts in alpha order
shopt -s nullglob extglob
_SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
declare -a _PARTS=( "${_SCRIPT_DIR}/entrypoint.d"/*@(.txt|.sh) )
shopt -u nullglob extglob

print_repeats() {
  local -r char="$1" count="$2"
  local i
  for ((i=1; i<=$count; i++)); do echo -n "$char"; done
  echo
}

print_banner_text() {
  # $1: Banner char
  # $2: Text
  local banner_char=$1
  local -r text="$2"
  local pad="${banner_char}${banner_char}"
  print_repeats "${banner_char}" $((${#text} + 6))
  echo "${pad} ${text} ${pad}"
  print_repeats "${banner_char}" $((${#text} + 6))
}

# Execute the entrypoint parts
for _file in "${_PARTS[@]}"; do
  case "${_file}" in
    *.txt) cat "${_file}";;
    *.sh)  source "${_file}";;
  esac
done

if [ "$X_DEBUG_ENV" = '1' ]; then

    echo
    echo "### ..."
    echo "### wd=$(pwd)"
    echo "### PATH=$PATH"
    echo "### args=$@"
    echo "### ..."

fi


### set +x

# This script can either be a wrapper around arbitrary command lines,
# or it will simply exec bash if no arguments were given
if [[ $# -eq 0 ]]; then
  exec "/bin/bash"
else
  exec "$@"
fi


[ "$X_DEBUG_ENV" = '1' ] && set +x
