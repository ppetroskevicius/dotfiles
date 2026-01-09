#!/bin/bash
# Script to set machine type based on hostname or environment variable
# Usage: source this script or run it to set MACHINE_TYPE

if [ -z "$MACHINE_TYPE" ]; then
    hostname=$(hostname)
    
    if [[ "$hostname" =~ ^bm- ]]; then
        export MACHINE_TYPE="bm-hypervisor"
    elif [[ "$hostname" =~ ^vm-k8s- ]]; then
        export MACHINE_TYPE="vm-k8s-node"
    elif [[ "$hostname" =~ ^vm-dev- ]]; then
        export MACHINE_TYPE="vm-dev-container"
    elif [[ "$hostname" =~ ^vm-svc- ]] || [[ "$hostname" =~ ^vm-service- ]]; then
        export MACHINE_TYPE="vm-service"
    else
        export MACHINE_TYPE="dt-dev"
    fi
fi

echo "Machine type: $MACHINE_TYPE"