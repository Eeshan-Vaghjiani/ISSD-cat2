#!/usr/bin/env bash
set -euo pipefail
role="${1:-unknown}"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq ca-certificates curl iproute2 iputils-ping net-tools openssh-server
if [ "$role" = "ubuntu" ]; then
  apt-get install -y -qq nginx
  systemctl enable --now nginx
elif [ "$role" = "debian" ]; then
  apt-get install -y -qq apache2
  systemctl enable --now apache2
else
  echo "Unknown role $role" >&2; exit 1
fi
echo "Provisioned $role on $(hostname). No vulnerability agent has been installed yet."
