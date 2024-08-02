#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_variables.sh

num_items() { echo $#; }

exit_if_empty() {
  if [ -z "$1" ]
  then
    echo "Not found"
    exit
  fi
}

check_help() {
  if [ "$1" = "-h" ]
  then
    show_help "$@"
    exit
  fi
}

check_env_file() {
  if [ -z "$env_file" ]
  then
    echo
    echo "The environment variable 'env_file' is not set."
    echo
    echo "Run: export env_file=<env>"
    echo
    echo "Example: export env_file=d0-eastus"
    echo
    exit
  fi
}

select_item() {

  local lines=$1
  local msg=$2

  readarray -t items <<< $lines

  if [ -z "$lines" ]
  then
    echo ""
  elif [ ${#items[@]} -eq 1 ]
  then
    echo "${items[0]}"
  else
    PS3="$msg"
    select _local_item in "${items[@]}"; do
        echo "$_local_item"
        break
    done
  fi
}

product_subscriptions() {

  local env="$1"
  local prd="${PRODUCT_CODE,,}"
  local bunit="${BUNIT_CODE,,}"
  local query_prefix="sort_by([], &name)|[?contains(@.name, '${bunit}-${prd}-')"
  local query_env=""
  if [ "$env" ]
  then
    query_env=" && contains(@.name, '-${env,,}-')"
  fi
  local query_val="$query_prefix${query_env}].name"

  local subs
  subs=$(az account list \
  --only-show-errors \
  --output tsv \
  --query "$query_val" \
  | tr -d '\r')

  echo "$subs"
}

select_subscription() {

  local sub=$(select_item "$(product_subscriptions "$@")" "Select Subscription: ")
  echo "$sub"
}

resource_groups() {

  local sub="$1"
  local extra="$2"
  local query="sort_by([], &name)|[*].name"

  if [ "$extra" ]
  then
    query="sort_by([], &name)|[?contains(@.name, '${extra,,}')].name"
  fi

  local names=$(az group list \
    --subscription "$sub" \
    --output tsv \
    --query "$query" \
    | tr -d '\r')

    echo "$names"
}

select_resource_group() {

  local sub="$1"
  local extra="$2"
  local rg=$(select_item "$(resource_groups "$sub" "$extra")" "Select Resource Group: ")
  echo "$rg"
}

resource_names_in_group() {

  local sub="$1"
  local rg="$2"
  local extra="$3"
  local query="sort_by([], &name)|[*].name"

    if [ "$extra" ]
    then
      query="sort_by([], &name)|[?contains(@.name, '${extra}')].name"
    fi

  local names=$(az resource list \
  --resource-group "$rg" \
  --subscription "$sub" \
  --output tsv \
  --query "$query" \
  | tr -d '\r')

  echo "$names"
}

select_resource_name_in_group() {

  local sub="$1"
  local rg="$2"
  local extra="$3"
  local name=$(select_item "$(resource_names_in_group "$sub" "$rg" "$extra")" "Select Resource: ")
  echo "$name"
}

resource_names_of_type() {

  local sub="$1"
  local type="$2"
  local extra="$3"
  local query="sort_by([], &name)|[*].name"

      if [ "$extra" ]
      then
        query="sort_by([], &name)|[?contains(@.name, '${extra}')].name"
      fi

  local names=$(az resource list \
  --resource-type "$type" \
  --subscription "$sub" \
  --output tsv \
  --query "$query" \
  | tr -d '\r')

  echo "$names"
}

select_resource_name_of_type() {

  local sub="$1"
  local type="$2"
  local msg="$3"
  local extra="$4"
  local name=$(select_item "$(resource_names_of_type "$sub" "$type" "$extra")" "$msg")
  echo "$name"
}

resource_group_for_resource() {

  local sub="$1"
  local name="$2"

  local rg=$(az resource list \
  --name "$name" \
  --subscription "$sub" \
  --output tsv \
  --query "[0].resourceGroup" \
  | tr -d '\r' \
  | sed -z 's/\n/ /g' \
  | xargs)

  echo "$rg"
}

resource_id_for_resource() {

  local sub="$1"
  local name="$2"

  local rg=$(az resource list \
  --name "$name" \
  --subscription "$sub" \
  --output tsv \
  --query "[0].id" \
  | tr -d '\r' \
  | sed -z 's/\n/ /g' \
  | xargs)

  echo "$rg"
}

vmss_instance_number() {

  local sub="$1"
  local vmss_name="$2"
  local rg="$3"

  local num=$(az vmss list-instances \
  --name "$vmss_name" \
  --resource-group "$rg" \
  --subscription "$sub" \
  --output tsv \
  --query "[0].instanceId" \
  | tr -d '\r' \
  | sed -z 's/\n/ /g' \
  | xargs)

  echo "$num"
}

select_bastion() {

  local -n name="$1"
  local -n resource_group="$2"
  local -n subscription="$3"
  local region="$4"

  case ${region,,} in

  eastus)
    name="bas-us1-lot-shd-p1-eastus-001"
    resource_group="rg-us1-lot-shd-bastion-p1-eastus"
    subscription="lot-cloudops-shd-p0-global"
    ;;

  centralus)
    name="bas-us1-lot-shd-p1-centralus-001"
    resource_group="rg-us1-lot-shd-bastion-p1-centralus"
    subscription="lot-cloudops-shd-p0-global"
    ;;

  esac
}


