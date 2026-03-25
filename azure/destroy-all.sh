#!/bin/bash

set -e

echo "Starting full environment teardown..."

# Hubs
echo "Deleting hub resource groups..."
az group delete \
  --name rg-fst-hub1 \
  --yes \
  --no-wait

az group delete \
  --name rg-fst-hub2 \
  --yes \
  --no-wait

# Spokes
echo "Deleting spoke resource groups..."
az group delete \
  --name rg-fst-spk1 \
  --yes \
  --no-wait

az group delete \
  --name rg-fst-spk2 \
  --yes \
  --no-wait

az group delete \
  --name rg-fst-spk3 \
  --yes \
  --no-wait

# Remotes
echo "Deleting remote resource groups..."
az group delete \
  --name rg-fst-rem1 \
  --yes \
  --no-wait

echo "All delete commands submitted."

echo "Use the following to monitor progress:"
echo "az group list --query \"[?starts_with(name, 'rg-fst-')]\" -o table"
