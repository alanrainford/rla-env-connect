#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "SSH into the D0 admin VM."
  echo
  echo "Syntax: $0 [region]"
  echo
  echo "Example: $0"
  echo "Example: $0 centralus"
  echo
}

check_help "$@"

CON_LOCATION=${1:-"${D0_LOCATION,,}"}

ENV_CODE="${D0_ENV_CODE,,}"
ENV="${CON_LOCATION,,}-${ENV_CODE}${GENERATION_CODE,,}-${PRODUCT_CODE,,}"

select_bastion BASTION_NAME BASTION_RESOURCE_GROUP BASTION_SUBSCRIPTION "${CON_LOCATION}"

set -x

az network bastion ssh \
--name "${BASTION_NAME}" \
--resource-group "${BASTION_RESOURCE_GROUP}" \
--auth-type AAD \
--target-resource-id "/subscriptions/${D0_SUBSCRIPTION_ID}/resourceGroups/rg-${ENV}-admin/providers/Microsoft.Compute/virtualMachines/vm-${ENV}-linux-admin" \
--subscription "${BASTION_SUBSCRIPTION}"