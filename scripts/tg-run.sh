#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Run \"terragrunt [command] --terragrunt-non-interactive --terragrunt-source-update --terragrunt-working-dir [path] [..extra options]\"."
  echo
  echo "Syntax: $0 [command] [path] [extra options]"
  echo
  echo "Example: $0 init build/env0/role/role-assignment-team"
  echo
}

check_help "$@"
check_env_file

CMD="$1"
shift
WORKING_DIR="${1:-$(pwd)}"
shift

set -x
terragrunt "$CMD" --terragrunt-non-interactive --terragrunt-source-update --terragrunt-working-dir "$WORKING_DIR" "$@"
