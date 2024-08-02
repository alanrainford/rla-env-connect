#!/usr/bin/env bash

CMD="output"

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Run \"terragrunt $CMD -json --terragrunt-working-dir [path] [..extra options]\"."
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
terragrunt "$CMD" -json --terragrunt-working-dir "$WORKING_DIR" "$@"
