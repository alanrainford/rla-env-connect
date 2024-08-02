#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)

show_help() {
  echo
  echo "Set Terraform source module version in terragrunt.hcl files."
  echo
  echo "Syntax: $0 [new version] [old version]"
  echo
  echo "Example: $0 v2.0.0"
  echo "Example: $0 v2.0.0 v1.0.0"
  echo
}

if [ "$1" = "-h" ]
then
  show_help "$@"
  exit
fi

NEW_VERSION="$1"
OLD_VERSION="${2:-.*}"

FILES=( $(find "${REPO_ROOT}" -type f -name "terragrunt.hcl") )

for FILE in "${FILES[@]}"
do

  if grep -q "\?ref=${OLD_VERSION}" ${FILE}
  then
    echo "Set version ${NEW_VERSION} in ${FILE}"
    sed -i "s/\?ref=${OLD_VERSION}\"/?ref=${NEW_VERSION}\"/g" "${FILE}"
  fi
done

