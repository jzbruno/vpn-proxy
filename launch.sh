#!/usr/bin/env bash

# Requires:
# - multipass
# - hostess
# - jq

set -euo pipefail

name="vpn"
domain="vpn.local"

if ! multipass ls | grep ${name} | grep Running; then
    echo "Creating VM"
    multipass launch -n ${name} --cloud-init cloud-config.yml

    # Cloud Init doesn't wait for package installs to complete by default.
    # Might be able to change this behavior but for now just wait.
    echo "Waiting for packages to install"
    multipass exec ${name} -- /bin/bash -c 'until which tinyproxy && which openconnect ; do printf "." sleep 10; done'
fi

echo "Setting up VPN"
multipass transfer vpn.env vpn.service ${name}:.
multipass exec ${name} -- sudo cp vpn.* /etc/systemd/system/

echo "Starting VPN"
multipass exec ${name} -- sudo systemctl daemon-reload
multipass exec ${name} -- sudo systemctl enable vpn
multipass exec ${name} -- sudo systemctl start vpn

echo "Setting up proxy"
multipass transfer tinyproxy.conf ${name}:.
multipass exec ${name} sudo cp tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

echo "Starting proxy"
multipass exec ${name} sudo service tinyproxy restart

echo "Adding vpn.local entry to /etc/hosts"
ip="$(multipass info ${name} --format json | jq -r '.info.'${name}'.ipv4[0]')"
sudo hostess add ${domain} ${ip}
