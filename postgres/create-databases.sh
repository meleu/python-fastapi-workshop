#!/usr/bin/env bash

set -Eeo pipefail

createUserAndDatabase() {
  local database="$1"
  echo "Creating user and database '${database}'"
  psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" <<- EoSQL
    CREATE USER ${database} PASSWORD '${database}';
    CREATE DATABASE ${database};
    GRANT ALL PRIVILEGES ON DATABASE ${database} TO ${database};
EoSQL
}

main() {
  local db

  [[ -z "${POSTGRES_DBS}" ]] && return

  echo "Creating DBs: ${POSTGRES_DBS}"
  for db in $(tr ',' ' ' <<< "${POSTGRES_DBS}"); do
    createUserAndDatabase "${db}"
  done

  echo "Finished creating DBs"
}

main "$@"
