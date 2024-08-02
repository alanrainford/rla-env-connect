#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

$REPO_ROOT/scripts/setup/delete/_delete-devops-pipelines.sh "non-production"