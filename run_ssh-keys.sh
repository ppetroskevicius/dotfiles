#!/usr/bin/env bash
set -euo pipefail

# Check if 1Password CLI is available
if ! command -v op &> /dev/null; then
    echo "Warning: 1Password CLI (op) not found. SSH key setup may be incomplete."
fi

# Set up SSH keys after they're installed by chezmoi
if [ -f "$HOME/.ssh/id_ed25519" ]; then
	echo ">>> Setting up SSH keys..."
	chmod 600 "$HOME/.ssh/id_ed25519"

	# Generate public key if it doesn't exist
	if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
		ssh-keygen -y -f "$HOME/.ssh/id_ed25519" >"$HOME/.ssh/id_ed25519.pub"
	fi

	# Add to authorized_keys
	if [ ! -f "$HOME/.ssh/authorized_keys" ] || ! grep -q "$(cat "$HOME/.ssh/id_ed25519.pub")" "$HOME/.ssh/authorized_keys" 2>/dev/null; then
		cat "$HOME/.ssh/id_ed25519.pub" >>"$HOME/.ssh/authorized_keys"
		chmod 600 "$HOME/.ssh/authorized_keys"
	fi

	# Add known hosts
	if ! grep -q "github.com" "$HOME/.ssh/known_hosts" 2>/dev/null; then
		ssh-keyscan github.com >>"$HOME/.ssh/known_hosts" 2>/dev/null || true
	fi

	# Start SSH agent and add key
	if [ "$(uname -s)" != "Darwin" ]; then
		systemctl --user enable --now ssh-agent.service 2>/dev/null || true
	fi
	eval "$(ssh-agent -s)" >/dev/null 2>&1 || true
	ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null || true
fi
