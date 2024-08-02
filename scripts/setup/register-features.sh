#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Register Subscription features."
  echo
  echo "Syntax: $0 [env code]"
  echo
  echo "Example: $0"
  echo "Example: $0 d0"
  echo
}

check_help "$@"

echo "Querying list of subscriptions..."
SUB_NAME=$(select_subscription "$1")
exit_if_empty "$SUB_NAME"

$REPO_ROOT/scripts/setup/_register-feature.sh "Microsoft.Compute" "EncryptionAtHost" "$SUB_NAME"
$REPO_ROOT/scripts/setup/_register-feature.sh "Microsoft.Network" "BypassCnameCheckForCustomDomainDeletion" "$SUB_NAME"
$REPO_ROOT/scripts/setup/_register-feature.sh "Microsoft.Network" "AllowGlobalTagsForStorage" "$SUB_NAME"
$REPO_ROOT/scripts/setup/_register-feature.sh "Microsoft.Storage" "AllowSFTP" "$SUB_NAME"
$REPO_ROOT/scripts/setup/_register-feature.sh "Microsoft.ContainerService" "EnablePodIdentityPreview" "$SUB_NAME"
$REPO_ROOT/scripts/setup/_register-feature.sh "Microsoft.ContainerService" "AKS-AzureDefender" "$SUB_NAME"
$REPO_ROOT/scripts/setup/_register-feature.sh "Microsoft.ContainerService" "EnablePrivateClusterPublicFQDN" "$SUB_NAME"
$REPO_ROOT/scripts/setup/_register-feature.sh "Microsoft.ContainerService" "AKS-KedaPreview" "$SUB_NAME"
$REPO_ROOT/scripts/setup/_register-feature.sh "Microsoft.AppConfiguration" "" "$SUB_NAME"

echo "Registering provider Microsoft.PolicyInsights..."
az provider register --name "Microsoft.PolicyInsights" --subscription "$SUB_NAME"