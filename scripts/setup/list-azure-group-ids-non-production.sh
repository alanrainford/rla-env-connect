#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)

$REPO_ROOT/scripts/setup/_list-azure-group-ids.sh "Non-Production"