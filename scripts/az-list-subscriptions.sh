#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Show list of subscriptions."
  echo
  echo "Syntax: $0 [product code]"
  echo
  echo "Example: $0"
  echo "Example: $0 cpt"
  echo "Example: $0 all"
  echo
}

check_help "$@"

PRD="${1:-$PRODUCT_CODE}"

QUERY="sort_by([], &name)|[?contains(@.name, '${BUNIT_CODE,,}-${PRD,,}-')].{name:name, subscriptionId:id, tenantId:tenantId}"

if [ "$PRD" = "all" ]
then
  QUERY="sort_by([], &name)|[].{name:name, subscriptionId:id, tenantId:tenantId}"
fi

az account list \
  --only-show-errors \
  --output table \
  --query "$QUERY"