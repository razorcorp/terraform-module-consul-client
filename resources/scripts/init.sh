#!/usr/bin/env bash

echo "Updating and patching system"
apt-get update
apt-get upgrade -y

echo "Installing basic tools"
apt-get install -y vim curl gpg
