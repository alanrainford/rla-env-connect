#!/usr/bin/env bash

NAMESPACE=$1
FEATURE=$2
SUB_NAME=$3

if [ -n "$FEATURE" ]; then
    echo "Registering $FEATURE feature..."
    az feature register --namespace "$NAMESPACE" --name "$FEATURE" --subscription "$SUB_NAME"
fi

echo "Registering provider $NAMESPACE..."
az provider register --namespace "$NAMESPACE" --subscription "$SUB_NAME"

if [ -n "$FEATURE" ]; then
    echo "Showing $FEATURE feature..."
    az feature show --namespace "$NAMESPACE" --name "$FEATURE" --subscription "$SUB_NAME"
fi