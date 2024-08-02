#!/usr/bin/env bash

ENV_TYPE=$1
SUB=$2

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

az devops project create \
--name "${PRODUCT_NAME} - ${ENV_TYPE}" \
--description "${PRODUCT_NAME} ${ENV_TYPE}" \
--org "$DEVOPS_ORG" \
--subscription "$SUB"
