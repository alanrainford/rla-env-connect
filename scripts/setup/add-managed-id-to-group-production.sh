#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

ID=$1
GROUP_TYPE="DevOps"
GROUP_NAME="${PRODUCT_CODE^^}-Cloud-${GROUP_TYPE^}-Production"

echo "Adding $ID as member of group $GROUP_NAME"
az ad group member add --group "$GROUP_NAME" --member-id "$ID"