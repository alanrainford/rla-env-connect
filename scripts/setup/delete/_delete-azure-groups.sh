#!/usr/bin/env bash

ENV_TYPE=$1

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

GROUP_TYPES="Readers Developers DevOps"

read -p "Are you sure you want to DELETE Azure ${ENV_TYPE} groups? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

for GROUP_TYPE in $GROUP_TYPES
do

  GROUP_NAME="${PRODUCT_CODE^^}-Cloud-$GROUP_TYPE-$ENV_TYPE"

  echo "Deleting group $GROUP_NAME"
  az ad group delete --group "$GROUP_NAME"

done
