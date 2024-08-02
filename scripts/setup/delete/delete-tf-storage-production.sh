#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

$REPO_ROOT/scripts/setup/delete/_delete-tf-storage.sh "${P0_ENV_CODE,,}" "${P0_LOCATION,,}" "${GENERATION_CODE,,}" "${PRODUCT_CODE,,}" "${P0_SUB_NAME,,}"