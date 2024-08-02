#!/usr/bin/env bash

CMD="destroy"

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Run \"terragrunt run-all $CMD --terragrunt-non-interactive --terragrunt-source-update --terragrunt-working-dir [path] [..extra options]\"."
  echo
  echo "Syntax: $0 [path] [extra options]"
  echo
  echo "Example: $0 build/env0/role"
  echo
}

check_help "$@"
check_env_file

WORKING_DIR="${1:-$(pwd)}"
shift

set -x
terragrunt run-all "$CMD" --terragrunt-non-interactive --terragrunt-source-update --terragrunt-working-dir "$WORKING_DIR" "$@"