#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Get access credentials for an AKS cluster."
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

echo "Querying list of AKS in ${SUB_NAME}..."
AKS_NAME=$(select_resource_name_of_type "$SUB_NAME" "Microsoft.ContainerService/managedClusters" "Select AKS cluster: ")
exit_if_empty "$AKS_NAME"

echo "Querying resource group of ${AKS_NAME}..."
RG=$(resource_group_for_resource "$SUB_NAME" "$AKS_NAME")
exit_if_empty "$RG"

echo "Getting credentials for ${AKS_NAME} in ${RG}..."
az aks get-credentials \
--name "$AKS_NAME" \
--resource-group "$RG" \
--subscription "$SUB_NAME" \
--overwrite-existing \
--admin \
--public-fqdn