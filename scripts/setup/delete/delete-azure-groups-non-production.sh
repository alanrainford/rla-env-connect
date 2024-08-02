#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)

$REPO_ROOT/scripts/setup/delete/_delete-azure-groups.sh "Non-Production"