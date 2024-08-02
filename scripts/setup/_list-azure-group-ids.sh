#!/usr/bin/env bash

ENV_TYPE=$1

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

GROUP_TYPES="Readers Developers DevOps"

for GROUP_TYPE in $GROUP_TYPES
do

  GROUP_NAME="${PRODUCT_CODE^^}-Cloud-$GROUP_TYPE-$ENV_TYPE"
  GENERIC_NAME="Cloud_${GROUP_TYPE}_${ENV_TYPE//[-]/_}"

  GID=$(az ad group show \
  --group "$GROUP_NAME" \
  --output tsv \
  --query "id" \
  | tr -d '\r')

  echo "${GENERIC_NAME^^}=\"$GID\""
done