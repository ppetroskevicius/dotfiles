#!/usr/bin/env bash
set -euo pipefail

# Ensure 1Password CLI is installed before applying encrypted templates
if ! command -v op >/dev/null; then
  echo ">>> Installing 1Password CLI..."
  if [ "$(uname -s)" = "Darwin" ]; then
    brew install 1password-cli
  else
    # Linux installation
    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
      sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' |
      sudo tee /etc/apt/sources.list.d/1password.list
    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
      sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
      sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
    sudo apt update && sudo apt install -y 1password-cli
  fi
fi

# 2. Verify Authentication (Do not try to sign in here)
if ! op account get >/dev/null 2>&1; then
  echo "Error: 1Password CLI is not signed in."
  echo "Please sign in manually in your shell using 'eval \$(op signin)'"
  echo "OR enable the 1Password Desktop App integration (Settings -> Developer -> Integrate with CLI)."
  exit 1
fi

echo ">>> 1Password CLI is ready and authenticated."
