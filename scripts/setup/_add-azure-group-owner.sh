#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

ENV_TYPE=$1
GROUP_TYPE=$2
OWNER_NAME=$3

GROUP_NAME="${PRODUCT_CODE^^}-Cloud-${GROUP_TYPE^}-$ENV_TYPE"

OWNER_ID=$(az ad user show --id "$OWNER_NAME" --query id --output tsv | tr -d '\r')
echo "Assigning $OWNER_NAME $OWNER_ID as owner of group $GROUP_NAME"

az ad group owner add --group "$GROUP_NAME" --owner-object-id "$OWNER_ID"
