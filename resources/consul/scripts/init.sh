#!/usr/bin/env bash

set -e
exec >> /var/log/consul_setup.log 2>&1

logger() {
  echo "$(date '+%Y/%m/%d %H:%M:%S') init.sh: $1"
}

logger "Updating and patching system"
apt-get update
apt-get upgrade -y

logger "Installing basic tools"
apt-get install -y vim curl gpg
