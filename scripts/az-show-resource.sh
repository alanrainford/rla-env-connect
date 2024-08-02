#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Show details of a specific resource."
  echo
  echo "Syntax: $0 [env code] [resource group] [resource]"
  echo
  echo "Example: $0"
  echo "Example: $0 d1"
  echo "Example: $0 d1 compute"
  echo "Example: $0 d1 compute agic"
  echo
}

check_help "$@"

echo "Querying list of subscriptions..."
SUB_NAME=$(select_subscription "$1")
exit_if_empty "$SUB_NAME"

echo "Querying list of Resource Groups in ${SUB_NAME}..."
RG=$(select_resource_group "$SUB_NAME" "$2")
exit_if_empty "$RG"

echo "Querying list of Resources in ${RG}..."
RSC=$(select_resource_name_in_group "$SUB_NAME" "$RG" "$3")
exit_if_empty "$RSC"

echo "Query Resource Id for ${RSC}..."
RID=$(resource_id_for_resource "$SUB_NAME" "$RSC")

az resource show --ids "$RID" | less