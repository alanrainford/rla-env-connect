#!/usr/bin/env bash

LOCATION=$1
RESOURCE_GROUP=$2
ST_ACCOUNT=$3
ST_CONTAINER=$4
LOCK_NAME=$5
SUB_NAME=$6
TAGS=$7

echo "Creating Resource Group $RESOURCE_GROUP"
az group create -l "$LOCATION" -n "$RESOURCE_GROUP" --subscription "$SUB_NAME" --tags $TAGS

echo "Creating Storage Account $ST_ACCOUNT"
az storage account create \
--name "$ST_ACCOUNT" \
--resource-group "$RESOURCE_GROUP" \
--location "$LOCATION" \
--subscription "$SUB_NAME" \
--kind StorageV2 \
--sku Standard_GZRS \
--allow-blob-public-access false \
--allow-shared-key-access true \
--https-only true \
--min-tls-version TLS1_2 \
--public-network-access Enabled \
--require-infrastructure-encryption true \
--allow-shared-key-access false \
--assign-identity \
--identity-type SystemAssigned \
--tags $TAGS

echo "Enabling Soft Delete"
az storage account blob-service-properties update \
--account-name "$ST_ACCOUNT" \
--enable-delete-retention true \
--delete-retention-days 7 \
--enable-container-delete-retention true \
--container-delete-retention-days 7 \
--subscription "$SUB_NAME"

echo "Create Container $ST_CONTAINER"
az storage container create \
--name "$ST_CONTAINER" \
--account-name "$ST_ACCOUNT" \
--subscription "$SUB_NAME" \
--auth-mode login

echo "Locking Resource Group"
az group lock create \
--lock-type CanNotDelete \
--name "$LOCK_NAME" \
--resource-group "$RESOURCE_GROUP" \
--subscription "$SUB_NAME"

