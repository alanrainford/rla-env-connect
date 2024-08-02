#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/config/_product_parameters.sh
source $REPO_ROOT/scripts/config/_group_ids.sh
source $REPO_ROOT/scripts/config/_npm_registries.sh

D0_ENV_CODE="d0"
D0_SUB_NAME="${BUNIT_CODE,,}-${PRODUCT_CODE,,}-${SITE_CODE,,}-${D0_ENV_CODE,,}-${GEO_CODE,,}"
D0_TAGS="business-unit=${BUNIT_NAME,,} cost-center=${COST_CODE,,} environment=${D0_ENV_CODE,,} generation=${GENERATION_CODE,,} notification-team=${TEAM_MAIL,,} owner-name=${TEAM_MAIL,,} product-id=${PRODUCT_CODE,,} site-code=${SITE_CODE,,}"
D0_TF_RESOURCE_GROUP="rg-${D0_LOCATION,,}-${D0_ENV_CODE,,}${GENERATION_CODE,,}-${PRODUCT_CODE,,}-tf-state"
D0_TF_ST_ACCOUNT="st${D0_LOCATION,,}${D0_ENV_CODE,,}${GENERATION_CODE,,}${PRODUCT_CODE,,}tfigtcom"
D0_TF_ST_CONTAINER="tf-${PRODUCT_CODE,,}-shd"
D0_TF_LOCK_NAME="lock-${D0_LOCATION,,}-${D0_ENV_CODE,,}${GENERATION_CODE,,}-${PRODUCT_CODE,,}-tf-state"
D0_CR_NAME="cr${D0_LOCATION,,}${D0_ENV_CODE,,}${GENERATION_CODE,,}${PRODUCT_CODE,,}igtcom"

D1_ENV_CODE="d1"
D1_SUB_NAME="${BUNIT_CODE,,}-${PRODUCT_CODE,,}-${SITE_CODE,,}-${D1_ENV_CODE,,}-${GEO_CODE,,}"

P0_ENV_CODE="p0"
P0_SUB_NAME="${BUNIT_CODE,,}-${PRODUCT_CODE,,}-${SITE_CODE,,}-${D0_ENV_CODE,,}-${GEO_CODE,,}"
P0_TAGS="business-unit=${BUNIT_NAME,,} cost-center=${COST_CODE,,} environment=${D0_ENV_CODE,,} generation=${GENERATION_CODE,,} notification-team=${TEAM_MAIL,,} owner-name=${TEAM_MAIL,,} product-id=${PRODUCT_CODE,,} site-code=${SITE_CODE,,}"
P0_TF_RESOURCE_GROUP="rg-${P0_LOCATION,,}-${P0_ENV_CODE,,}${GENERATION_CODE,,}-${PRODUCT_CODE,,}-tf-state"
P0_TF_ST_ACCOUNT="st${P0_LOCATION,,}${P0_ENV_CODE,,}${GENERATION_CODE,,}${PRODUCT_CODE,,}tfigtcom"
P0_TF_ST_CONTAINER="tf-${PRODUCT_CODE,,}-shd"
P0_TF_LOCK_NAME="lock-${P0_LOCATION,,}-${P0_ENV_CODE,,}${GENERATION_CODE,,}-${PRODUCT_CODE,,}-tf-state"



