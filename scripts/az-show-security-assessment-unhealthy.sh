#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Show unhealthy resources from the security assessment."
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

echo "Querying list of security assessments for ${SUB_NAME}..."
az security assessment list \
--subscription "$SUB_NAME" \
--output json \
--query "[]|[?@.status.code=='Unhealthy'].{name:displayName, resource:resourceDetails.Id}" \
| less