#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

ENV_ARG="$1"
PRIVATE_ONLY="${2:-false}"
NAME_ONLY="${3:-false}"

SUB_NAME=$(select_subscription "$ENV_ARG")
exit_if_empty "$SUB_NAME"

ZLIST=$(az resource list \
--resource-type "Microsoft.Network/privateDnsZones" \
--subscription "$SUB_NAME" \
--out tsv \
--query "[].{Name:name, RG:resourceGroup}" \
| tr -d '\r')

readarray -t ZONES <<< $ZLIST

DOMAINS=""

for ZONE in "${ZONES[@]}"
do
  ZONE_NAME=$(echo $ZONE | cut -f 1 -d ' ')
  ZONE_RG=$(echo $ZONE | cut -f 2 -d ' ')

  if [[ $PRIVATE_ONLY == "false" || $ZONE_NAME =~ "private" ]]; then

    readarray -t ENTRIES < <(az network private-dns record-set list \
    --zone-name "$ZONE_NAME" \
    --resource-group "$ZONE_RG" \
    --subscription "$SUB_NAME" \
    --out tsv \
    --query "[?name != '@'].{Name:name, Address:aRecords[0].ipv4Address}" \
    | tr -d '\r')

    for ENTRY in "${ENTRIES[@]}"
    do
      HOST=$(echo "$ENTRY" | cut -f 1)
      IP=$(echo "$ENTRY" | cut -f 2)

      #we need both domain names: with 'privatelink.' part in it and not

      #add domain without .privatelink.:
      DOMAIN="${HOST}.$(echo "$ZONE_NAME" | sed -z 's/privatelink\.//g' | sed -z 's/vaultcore/vault/g')"

      if [[ $NAME_ONLY == "false" ]]; then
        if [ -z "$DOMAINS" ]; then
          DOMAINS="${DOMAIN}\t${IP}"
        else
          DOMAINS="${DOMAINS}\n${DOMAIN}\t${IP}"
        fi
      else
        if [ -z "$DOMAINS" ]; then
          DOMAINS="$DOMAIN"
        else
          DOMAINS="${DOMAINS}, ${DOMAIN}"
        fi
      fi

      #add domain with .privatelink.:
      DOMAIN="${HOST}.$(echo "$ZONE_NAME" | sed -z 's/vaultcore/vault/g')"

      if [[ $NAME_ONLY == "false" ]]; then
        if [ -z "$DOMAINS" ]; then
          DOMAINS="${DOMAIN}\t${IP}"
        else
          DOMAINS="${DOMAINS}\n${DOMAIN}\t${IP}"
        fi
      else
        if [ -z "$DOMAINS" ]; then
          DOMAINS="$DOMAIN"
        else
          DOMAINS="${DOMAINS}, ${DOMAIN}"
        fi
      fi

    done
  fi
done

if [[ $NAME_ONLY == "true" ]]; then
  readarray -t ALL_SUBS < <(product_subscriptions)

  for SUB in "${ALL_SUBS[@]}"
  do
    DBLIST=$(az resource list \
    --resource-type "Microsoft.DBforPostgreSQL/flexibleServers" \
    --subscription "$SUB" \
    --out tsv \
    --query "[].name" \
    | tr -d '\r')

    readarray -t DBS <<< $DBLIST

    for DB in "${DBS[@]}"
    do
      if [[ ! -z "$DB" ]]; then
        DOMAINS="${DOMAINS}, ${DB}.postgres.database.azure.com"
      fi
    done
  done
fi

echo -e "$DOMAINS"


