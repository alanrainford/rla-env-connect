#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

$REPO_ROOT/scripts/setup/create/_create-tf-storage.sh \
"${D0_LOCATION,,}" \
"${D0_TF_RESOURCE_GROUP,,}" \
"${D0_TF_ST_ACCOUNT,,}" \
"${D0_TF_ST_CONTAINER,,}" \
"${D0_TF_LOCK_NAME,,}" \
"${D0_SUB_NAME,,}" \
"${D0_TAGS,,}"