#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Run command on first instance of a VMSS."
  echo
  echo "Syntax: $0 [env code] [vmss name] command"
  echo
  echo "Example: $0 'nc -vz xxmaven.gtk.gtech.com 4443'"
  echo "Example: $0 d0 'nc -vz xxmaven.gtk.gtech.com 4443'"
  echo "Example: $0 d0 agent-pool 'nc -vz xxmaven.gtk.gtech.com 4443'"
  echo
}

check_help "$@"

if [ $# -eq 0 ]
then
  show_help
  exit
fi

ENV_ARG=""
VMSS_ARG=""
CMD_ARG=""

if [ $# -eq 1 ]
then
  CMD_ARG="$1"
fi

if [ $# -eq 2 ]
then
  ENV_ARG="$1"
  CMD_ARG="$2"
fi

if [ $# -eq 3 ]
then
  ENV_ARG="$1"
  VMSS_ARG="$2"
  CMD_ARG="$3"
fi

echo "Querying list of subscriptions..."
SUB_NAME=$(select_subscription "$ENV_ARG")
exit_if_empty "$SUB_NAME"

echo "Querying list of VMSS in ${SUB_NAME}..."
VMSS_NAME=$(select_resource_name_of_type "$SUB_NAME" "Microsoft.Compute/virtualMachineScaleSets" "Select VMSS: " "$VMSS_ARG")
exit_if_empty "$VMSS_NAME"

echo "Querying resource group of ${VMSS_NAME}..."
RG=$(resource_group_for_resource "$SUB_NAME" "$VMSS_NAME")

echo "Querying first instance number of ${VMSS_NAME}..."
INST_NUM=$(vmss_instance_number "$SUB_NAME" "$VMSS_NAME" "$RG")

echo "Running command on ${VMSS_NAME} instance ${INST_NUM} in ${RG}..."
az vmss run-command invoke \
--name "$VMSS_NAME" \
--resource-group "$RG" \
--command-id RunShellScript \
--instance-id "$INST_NUM" \
--subscription "$SUB_NAME" \
--scripts " $CMD_ARG "

