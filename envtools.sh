#!/usr/bin/env bash

load_env() {
  local env=${1:?no env set}
  shift

  # Fuzzy filtering that removes the trailing .env if you do specify it
  if [[ ${env} =~ .*.env$ ]]; then
    local env="${env%'.env'}"
  fi

  if [ -r ${HOME}/.env/${env}.env ]; then
    . ${HOME}/.env/${env}.env
    echo "Loading ENV: ${env}"
    export LOAD_ENV="${env} ${LOAD_ENV}"
  else
    echo "Could not find ENV: ${env}"
    return 1
  fi

  for var in "$@";do
    if [[ ! -v ${var} ]]; then
      echo "Could not find required ENV variable: ${var}"
    fi
  done
}

_load_env()
{
  COMPREPLY=($(cd ${HOME}/.env; compgen -f ${COMP_WORDS[COMP_CWORD]}))
}
complete -o nospace -F _load_env load_env

get_env() {
  echo ${LOAD_ENV:?no env loaded}
}

unload_credentials() {
  local env=${1:?no env set}

  # Fuzzy filtering to make sure we're only dealing with credentials
  # even if you're not specific about it
  if [[ ! ${env} =~ ^credentials/.* ]]; then
    local env="credentials/${env}"
  fi

  # Fuzzy filtering that removes the trailing .env if you do specify it
  if [[ ${env} =~ .*.env$ ]]; then
    local env="${env%'.env'}"
  fi

  local envfile="${HOME}/.env/${env}.env"
  if [ -r ${envfile} ]; then
    echo "Unloading ENV: ${env}"
    local envvars=$(awk -F" |=" '/^export/ {printf $2" "}' ${envfile})
    for envvar in ${envvars}; do
      unset ${envvar}
    done
    export LOAD_ENV="${LOAD_ENV//${env}/}"
  fi
}

_unload_credentials() {
  COMPREPLY=($(compgen -W "$(echo ${LOAD_ENV} | tr ' ' '\n' | egrep ^credentials)" -- ${COMP_WORDS[COMP_CWORD]}))
}
complete -o nospace -F _unload_credentials unload_credentials
