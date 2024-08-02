#!/usr/bin/env bash

CMD="plan"

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Run terragrunt force-unlock -force twice, first to get the lock id, and second to unlock with id"
  echo
  echo "Syntax: $0 [path]"
  echo
  echo "Example: $0 build/env0/role"
  echo
}

check_help "$@"
check_env_file

WORKING_DIR="${1:-$(pwd)}"
shift

TG_OUT=$(terragrunt force-unlock -force "" --terragrunt-working-dir "$WORKING_DIR" 2>&1)
LOCK_ID=$(echo "$TG_OUT" | grep 'ID:' - | sed 's/\s*ID:\s*//' | tr -d '\n')

set -x
terragrunt force-unlock -force "$LOCK_ID" --terragrunt-working-dir "$WORKING_DIR"