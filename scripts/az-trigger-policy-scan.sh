#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Trigger policy scan for a subscription."
  echo
  echo "Syntax: $0 [env code]"
  echo
  echo "Example: $0"
  echo "Example: $0 d1"
  echo
}

check_help "$@"

echo "Querying list of subscriptions..."
SUB_NAME=$(select_subscription "$1")
exit_if_empty "$SUB_NAME"

echo "Triggering scan of ${SUB_NAME}..."
az policy state trigger-scan --subscription "$SUB_NAME"