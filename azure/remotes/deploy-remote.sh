#!/bin/bash
set -e

SITE=$1
DATA_FILE=./remotes.json

# ----- Derived names (standard naming convention) -----
VNET="vnet-fst-${SITE}"
SNET_LAN="snet-fst-${SITE}-lan"

# ----- Pull site-specific values from JSON -----
RG=$(jq -r ".\"$SITE\".rg" $DATA_FILE)
LOC=$(jq -r ".\"$SITE\".location" $DATA_FILE)

AS1=$(jq -r ".\"$SITE\".vnetAddressSpaces[0]" $DATA_FILE)
LAN_CIDR=$(jq -r ".\"$SITE\".subnets.lanCidr" $DATA_FILE)

echo "Deploying REMOTE: $SITE"

# Resource Group
az group create --name "$RG" --location "$LOC"

# VNet + LAN subnet (LAN only)
az network vnet create \
  --resource-group "$RG" \
  --location "$LOC" \
  --name "$VNET" \
  --address-prefixes "$AS1" \
  --subnet-name "$SNET_LAN" \
  --subnet-prefix "$LAN_CIDR"

echo "Done: REMOTE $SITE"
