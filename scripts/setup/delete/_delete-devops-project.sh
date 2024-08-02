#!/usr/bin/env bash

ENV_TYPE=$1

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

PNAME="${PRODUCT_NAME} - ${ENV_TYPE}"
ID=$(az devops project show \
--project "$PNAME" \
--org "$DEVOPS_ORG" \
--output tsv \
--query "id")

az devops project delete \
--id "$ID" \
--org "$DEVOPS_ORG"