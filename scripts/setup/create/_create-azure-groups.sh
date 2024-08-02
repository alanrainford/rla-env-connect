#!/usr/bin/env bash

ENV_TYPE=$1

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

GROUP_TYPES="Readers Developers DevOps"

for GROUP_TYPE in $GROUP_TYPES
do

  GROUP_NAME="${PRODUCT_CODE^^}-Cloud-$GROUP_TYPE-$ENV_TYPE"
  echo "Creating group $GROUP_NAME"

  az ad group create --display-name "$GROUP_NAME" --mail-nickname "$GROUP_NAME"

  for OWNER_NAME in $GROUP_OWNERS
  do
    $REPO_ROOT/scripts/setup/_add-azure-group-owner.sh "$ENV_TYPE" "$GROUP_TYPE" "$OWNER_NAME"
    $REPO_ROOT/scripts/setup/_add-azure-group-member.sh "$ENV_TYPE" "$GROUP_TYPE" "$OWNER_NAME"
  done

done
