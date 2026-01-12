#!/bin/bash
# Ansible calls this script. The script asks 1Password for the secret.
# Because OP_SERVICE_ACCOUNT_TOKEN is in the env, no login is required.

op read "op://HomeLab/AnsibleVault/password" --no-newline
