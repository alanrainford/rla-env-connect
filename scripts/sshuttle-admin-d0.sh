#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Start tunnel to non-production environments."
  echo
  echo "Syntax: $0 [region] [local port]"
  echo
  echo "Options:"
  echo "-h This message."
  echo "-r Remove [localhost]:2022 from /root/.ssh/known_hosts."
  echo
  echo "Example: $0"
  echo "Example: $0 -r"
  echo "Example: $0 centralus"
  echo "Example: $0 eastus 2022"
  echo
}

check_help "$@"

kill_children() {

  local list=""

  for child in $(ps -o pid= --ppid $$)
  do
    kill -0 "${child}" 2>/dev/null && kill -TERM "${child}" && list="${list} ${child}" || true
  done

  if [ -n "${list}" ]; then
    kill -9 ${list} 2>/dev/null || true
  fi
}

trap 'kill_children' TERM INT HUP EXIT

sudo echo "---"

if [ "${1}" = "-r" ]; then
  shift
  echo "--- Removing [localhost]:2022 From /root/.ssh/known_hosts"
  sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "[localhost]:2022"
fi

CON_LOCATION=${1:-"${D0_LOCATION,,}"}
LOCAL_PORT=${2:-"2022"}

CON_ENV="${CON_LOCATION,,}-${D0_ENV_CODE}${GENERATION_CODE,,}-${PRODUCT_CODE,,}"
ADMIN_RG="rg-${CON_ENV}-admin"
VM="vm-${CON_ENV}-linux-admin"

select_bastion BASTION_NAME BASTION_RESOURCE_GROUP BASTION_SUBSCRIPTION "${CON_LOCATION}"

CFG_DIR="/tmp/az_ssh_config"
CFG_FILE="$CFG_DIR/sshconfig"

echo "--- Removing non-UTF-8 characters from /etc/hosts"
sudo iconv -f utf-8 -t utf-8 /etc/hosts -o /tmp/cleaned_hosts
sudo mv -f /tmp/cleaned_hosts /etc/hosts

echo "--- Finding Private DNS entries"
HOSTS=$($REPO_ROOT/scripts/_az-list-private-dns-entries.sh "$D0_ENV_CODE" true true)

echo "--- Checking for existing tunnel"
# Cleanup if existing process running
TUN_PID_FROM_LOCAL_PORT=$(sudo netstat -lntp | grep ":${LOCAL_PORT}" | tr -s " " | cut -f7 -d" " | cut -f1 -d"/")
if [[ ! -z "$TUN_PID_FROM_LOCAL_PORT" ]]; then
   kill "$TUN_PID_FROM_LOCAL_PORT"
   pkill -P $$
   echo "--- Killed existing tunnel that was running as process $TUN_PID_FROM_LOCAL_PORT"
fi;

echo "--- Starting tunnel to ${PRODUCT_CODE,,} ${D0_ENV_CODE}-${CON_LOCATION,,} on local port $LOCAL_PORT"
echo "---"

set -x

az network bastion tunnel \
--name "${BASTION_NAME}" \
--resource-group "${BASTION_RESOURCE_GROUP}" \
--target-resource-id "/subscriptions/${D0_SUBSCRIPTION_ID}/resourceGroups/${ADMIN_RG}/providers/Microsoft.Compute/virtualMachines/${VM}" \
--subscription "${BASTION_SUBSCRIPTION}" \
--resource-port 22 \
--port "$LOCAL_PORT" \
&

sleep 1s

mkdir -p /tmp/az_ssh_config
rm -f /tmp/az_ssh_config/id_rsa

az ssh config \
--file "$CFG_FILE" \
--keys-destination-folder "$CFG_DIR" \
--resource-group "$ADMIN_RG" \
--name "$VM" \
--subscription "${D0_SUB_NAME}" \
--prefer-private-ip \
--overwrite

sed -r -i 's/([0-9]{1,3}\.){3}[0-9]{1,3}/localhost/g' "$CFG_FILE"

sudo mkdir -p /root/.ssh

sudo sshuttle \
-v \
-l 0.0.0.0 \
-r "${ADMIN_RG}-${VM}" \
-e "ssh -p $LOCAL_PORT -F $CFG_FILE" \
--seed-hosts "$HOSTS" \
"$PRODUCT_CIDR"

pkill -P $$
