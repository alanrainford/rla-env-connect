#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

update_file() {
echo "Initializing $1..."

sed -i "s|@NPM_SNAPSHOT_REGISTRY@|${NPM_SNAPSHOT_REGISTRY}|g" "$1"
sed -i "s|@NPM_RELEASE_REGISTRY@|${NPM_RELEASE_REGISTRY}|g" "$1"

}

for f in $(find $REPO_ROOT/.azuredevops/scripts -name .npmrc)
do
  update_file "$f"
done