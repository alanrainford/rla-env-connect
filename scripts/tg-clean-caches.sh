#!/usr/bin/env bash

CURRENT_DIR=$(pwd)
REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Deletes all ..terragrunt-cache and .terraform.lock.hcl files."
  echo
  echo "Syntax: $0"
  echo
  echo "Example: $0"
  echo
}

check_help "$@"


cd $REPO_ROOT

echo "Removing .terragrunt-cache files..."
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
echo "Removing .terraform.lock.hcl files..."
find . -type f -name ".terraform.lock.hcl" -prune -exec rm -rf {} \;

cd $CURRENT_DIR