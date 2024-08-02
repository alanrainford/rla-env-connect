#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

update_file() {
echo "Initializing $1..."

sed -i "s/@CLOUD_READERS_NON_PRODUCTION@/${CLOUD_READERS_NON_PRODUCTION}/g" "$1"
sed -i "s/@CLOUD_DEVELOPERS_NON_PRODUCTION@/${CLOUD_DEVELOPERS_NON_PRODUCTION,,}/g" "$1"
sed -i "s/@CLOUD_DEVOPS_NON_PRODUCTION@/${CLOUD_DEVOPS_NON_PRODUCTION,,}/g" "$1"
}

for f in $(find $REPO_ROOT/terraform/envs -name *.hcl)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/.azuredevops -name *.yaml)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/.azuredevops/non-production -name *.yaml)
do
  update_file "$f"
done

for f in $(find $REPO_ROOT/scripts -name *.ps1)
do
  update_file "$f"
done