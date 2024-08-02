#!/usr/bin/env bash

ENV_CODE=$1
LOCATION=$2
GEN_CODE=$3
PRD=$4
SUB_NAME=$5

RESOURCE_GROUP="rg-$LOCATION-$ENV_CODE$GEN_CODE-$PRD-tf-state"
ST_ACCOUNT="st$LOCATION$ENV_CODE$GEN_CODE${PRD}tfigtcom"
LOCK_NAME="lock-$LOCATION-$ENV_CODE$GEN_CODE-$PRD-tf-state"

echo "Unlocking Resource Group"
az group lock delete --name "$LOCK_NAME" --resource-group "$RESOURCE_GROUP" --subscription "$SUB_NAME"

echo "Deleting Storage Account $ST_ACCOUNT"
az storage account delete \
--name "$ST_ACCOUNT" \
--resource-group "$RESOURCE_GROUP" \
--subscription "$SUB_NAME"

echo "Deleting Resource Group $RESOURCE_GROUP"
az group delete -n "$RESOURCE_GROUP" --subscription "$SUB_NAME"

