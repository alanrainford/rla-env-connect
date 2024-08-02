#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

$REPO_ROOT/scripts/setup/create/_create-tf-storage.sh \
"${P0_LOCATION,,}" \
"${P0_TF_RESOURCE_GROUP,,}" \
"${P0_TF_ST_ACCOUNT,,}" \
"${P0_TF_ST_CONTAINER,,}" \
"${P0_TF_LOCK_NAME,,}" \
"${P0_SUB_NAME,,}" \
"${P0_TAGS,,}"