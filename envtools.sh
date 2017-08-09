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
