#!/usr/bin/env bash

REPO_ROOT=$(git rev-parse --show-toplevel)
source $REPO_ROOT/scripts/util/_functions.sh

show_help() {
  echo
  echo "Find Windows DNS server addresses and add them to /etc/resolv.conf."
  echo
  echo "Syntax: $0"
  echo
  echo "Example: $0"
  echo
}

check_help "$@"
set -x
powershell.exe -Command '(Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses | Sort-Object -Descending -Unique | ForEach-Object { "nameserver $_" } |  Out-File "~resolv.conf" -Encoding UTF8'
tail -c +4 '~resolv.conf' | tr -d '\r' | sudo tee -a /etc/resolv.conf
rm '~resolv.conf'