#!/usr/bin/env bash
set -euo pipefail

# Check if 1Password CLI is available
if ! command -v op &> /dev/null; then
    echo "Warning: 1Password CLI (op) not found. WireGuard setup may be incomplete."
fi

# Set up WireGuard config after it's installed by chezmoi (Linux only)
if [ "$(uname -s)" != "Darwin" ] && [ -f "/etc/wireguard/gw0.conf" ]; then
	echo ">>> Wireguard config installed at /etc/wireguard/gw0.conf"
	echo ">>> Enable with: sudo wg-quick up gw0"
	sudo chmod 600 /etc/wireguard/gw0.conf
	sudo chown root: /etc/wireguard/gw0.conf
fi
