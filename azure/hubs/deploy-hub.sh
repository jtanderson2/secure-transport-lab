#!/bin/bash
set -e

SITE=$1
DATA_FILE=./hubs.json

# ----- Derived names (standard naming convention) -----
RG_PREFIX="rg-fst-"
VNET="vnet-fst-${SITE}"

SNET_LAN="snet-fst-${SITE}-lan"
SNET_WAN1="snet-fst-${SITE}-wan1"
SNET_WAN2="snet-fst-${SITE}-wan2"
SNET_BASTION="AzureBastionSubnet"

PIP_WAN1="pip-fst-${SITE}-fgt1-wan1"
PIP_WAN2="pip-fst-${SITE}-fgt1-wan2"

NIC_LAN="nic-fst-${SITE}-fgt1-lan"
NIC_WAN1="nic-fst-${SITE}-fgt1-wan1"
NIC_WAN2="nic-fst-${SITE}-fgt1-wan2"

# ----- Pull site-specific values from JSON -----
RG=$(jq -r ".\"$SITE\".rg" $DATA_FILE)
LOC=$(jq -r ".\"$SITE\".location" $DATA_FILE)

AS1=$(jq -r ".\"$SITE\".vnetAddressSpaces[0]" $DATA_FILE)
AS2=$(jq -r ".\"$SITE\".vnetAddressSpaces[1]" $DATA_FILE)

LAN_CIDR=$(jq -r ".\"$SITE\".subnets.lanCidr" $DATA_FILE)
WAN1_CIDR=$(jq -r ".\"$SITE\".subnets.wan1Cidr" $DATA_FILE)
WAN2_CIDR=$(jq -r ".\"$SITE\".subnets.wan2Cidr" $DATA_FILE)
BASTION_CIDR=$(jq -r ".\"$SITE\".subnets.bastionCidr" $DATA_FILE)

IP_LAN=$(jq -r ".\"$SITE\".fortigateIps.lan" $DATA_FILE)
IP_WAN1=$(jq -r ".\"$SITE\".fortigateIps.wan1" $DATA_FILE)
IP_WAN2=$(jq -r ".\"$SITE\".fortigateIps.wan2" $DATA_FILE)

echo "Deploying HUB: $SITE"

# Resource Group
az group create --name "$RG" --location "$LOC"

# VNet + LAN subnet
az network vnet create \
  --resource-group "$RG" \
  --location "$LOC" \
  --name "$VNET" \
  --address-prefixes "$AS1" "$AS2" \
  --subnet-name "$SNET_LAN" \
  --subnet-prefix "$LAN_CIDR"

# Subnets
az network vnet subnet create --resource-group "$RG" --vnet-name "$VNET" --name "$SNET_WAN1" --address-prefixes "$WAN1_CIDR"
az network vnet subnet create --resource-group "$RG" --vnet-name "$VNET" --name "$SNET_WAN2" --address-prefixes "$WAN2_CIDR"
az network vnet subnet create --resource-group "$RG" --vnet-name "$VNET" --name "$SNET_BASTION" --address-prefixes "$BASTION_CIDR"

# Public IPs
az network public-ip create --resource-group "$RG" --name "$PIP_WAN1" --location "$LOC" --sku Standard --allocation-method Static
az network public-ip create --resource-group "$RG" --name "$PIP_WAN2" --location "$LOC" --sku Standard --allocation-method Static

# FortiGate NICs (IP forwarding + accelerated networking)
az network nic create \
  --resource-group "$RG" --name "$NIC_LAN" --location "$LOC" \
  --vnet-name "$VNET" --subnet "$SNET_LAN" \
  --private-ip-address "$IP_LAN" \
  --ip-forwarding true --accelerated-networking true

az network nic create \
  --resource-group "$RG" --name "$NIC_WAN1" --location "$LOC" \
  --vnet-name "$VNET" --subnet "$SNET_WAN1" \
  --private-ip-address "$IP_WAN1" \
  --public-ip-address "$PIP_WAN1" \
  --ip-forwarding true --accelerated-networking true

az network nic create \
  --resource-group "$RG" --name "$NIC_WAN2" --location "$LOC" \
  --vnet-name "$VNET" --subnet "$SNET_WAN2" \
  --private-ip-address "$IP_WAN2" \
  --public-ip-address "$PIP_WAN2" \
  --ip-forwarding true --accelerated-networking true

echo "Done: HUB $SITE"
