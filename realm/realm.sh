#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

RElEASE=""
NAMESPACE=""
APPLICATION=""
WORKSPACE=$PWD

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-r] [-s] [-a]  param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help      Print this help and exit
-r, --release   Set release name
-s, --namespace Set namespace name
-a, --application  Set application name
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
  rm -rf /tmp/$RElEASE
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params

  while :; do
    case "${1-}" in
    -r | --release) # example named parameter
      RElEASE="${2-}"
      shift
      ;;
    -s | --name) # example named parameter
      NAMESPACE="${2-}"
      shift
      ;;
    -a | --app) # example named parameter
      APPLICATION="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ -z "${RElEASE}" ]] && die "Missing required parameter: release"
  [[ -z "${NAMESPACE}" ]] && die "Missing required parameter: namespace"
  [[ -z "${APPLICATION}" ]] && die "Missing required parameter: application"


  return 0
}

parse_params "$@"
setup_colors

# script logic here


# RElEASE="realm-cia"
# NS="cia"
# APPLICATION="seer"
HELM_PLUGINS=`helm env HELM_PLUGINS`
cp -r $HELM_PLUGINS/realm/template/foo /tmp/$RElEASE
cd /tmp/$RElEASE
mv charts/APPLICATION charts/$APPLICATION
sed  -i "" -e "s/REALM_RELEASE/$RElEASE/" Makefile
sed  -i "" -e "s/REALM_NAMESPACE/$NAMESPACE/" Makefile
find  /tmp/$RElEASE -type f -name "*.yaml" | while read e
     do
        sed  -i "" -e "s/REALM_RELEASE/$RElEASE/" $e
        sed  -i "" -e "s/REALM_APPLICATION/$APPLICATION/" $e
        sed  -i "" -e "s/REALM_NAMESPACE/$NAMESPACE/" $e
     done
mv /tmp/$RElEASE $WORKSPACE