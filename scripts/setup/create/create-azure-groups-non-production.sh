#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)

$REPO_ROOT/scripts/setup/create/_create-azure-groups.sh "Non-Production"