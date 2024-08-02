#!/usr/bin/env bash

CMD="plan"

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Run terragrunt apply and then import any missing resources"
  echo
  echo "Syntax: $0 [path]"
  echo
  echo "Example: $0 build/env0/role"
  echo
}

check_help "$@"
check_env_file

WORKING_DIR="${1:-$(pwd)}"
shift

TG_OUT=$(terragrunt run-all apply --terragrunt-non-interactive --terragrunt-source-update --terragrunt-working-dir "$WORKING_DIR" 2>&1)

readarray -d "~" lines <<< "$(echo "$TG_OUT" | sed 's/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g' | grep -A 2 'Error.*A resource with the ID' | sed 's/--/~/g')"

for l in "${lines[@]}"
do
  readarray -d "$" -t parts <<< $(echo "$l" | sed -z 's/^\n//g' | sed -z 's/\n/$/g')
  RSC_ID=$(echo "${parts[0]}" | grep -o '\"/[^\"]*\"' | sed 's/\"//g' | sed 's@/providers/microsoft.insights/diagnosticSettings/@\|@g')
  if [ -z "${RSC_ID}" ]; then
    RSC_ID=$(echo "${parts[0]}" | grep -o '\"https://[^\"]*\"' | sed 's/\"//g')
  fi
  RSC_NAME=$(echo "${parts[2]}" | grep -o '\swith\s[^,]*' | sed 's/with //')
  echo "resource name=$RSC_NAME"
  echo "resource id=$RSC_ID"
  terragrunt import "$RSC_NAME" "$RSC_ID" \
  --terragrunt-non-interactive \
  --terragrunt-working-dir "$WORKING_DIR"
done