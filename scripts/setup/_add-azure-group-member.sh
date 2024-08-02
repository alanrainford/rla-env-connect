#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

ENV_TYPE=$1
GROUP_TYPE=$2
OWNER_NAME=$3

GROUP_NAME="${PRODUCT_CODE^^}-Cloud-${GROUP_TYPE^}-$ENV_TYPE"

USER_ID=$(az ad user show --id "$OWNER_NAME" --query id --output tsv | tr -d '\r')
echo "Adding $OWNER_NAME $USER_ID as member of group $GROUP_NAME"

az ad group member add --group "$GROUP_NAME" --member-id "$USER_ID"