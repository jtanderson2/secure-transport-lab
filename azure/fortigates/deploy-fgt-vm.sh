#!/bin/bash
set -e

SITE=$1
DATA_FILE=./fortigates.json

RG=$(jq -r ".\"$SITE\".rg" $DATA_FILE)
LOC=$(jq -r ".\"$SITE\".location" $DATA_FILE)

VM=$(jq -r ".\"$SITE\".vmName" $DATA_FILE)
SIZE=$(jq -r ".\"$SITE\".vmSize" $DATA_FILE)
URN=$(jq -r ".\"$SITE\".imageUrn" $DATA_FILE)

DISK_SKU=$(jq -r ".\"$SITE\".osDisk.sku" $DATA_FILE)
DISK_SIZE=$(jq -r ".\"$SITE\".osDisk.sizeGb" $DATA_FILE)

NIC_WAN1_NAME=$(jq -r ".\"$SITE\".nics.wan1" $DATA_FILE)
NIC_WAN2_NAME=$(jq -r ".\"$SITE\".nics.wan2" $DATA_FILE)
NIC_LAN_NAME=$(jq -r ".\"$SITE\".nics.lan"  $DATA_FILE)

NIC_WAN1_ID=$(az network nic show -g "$RG" -n "$NIC_WAN1_NAME" --query id -o tsv)
NIC_WAN2_ID=$(az network nic show -g "$RG" -n "$NIC_WAN2_NAME" --query id -o tsv)
NIC_LAN_ID=$(az network nic show -g "$RG" -n "$NIC_LAN_NAME"  --query id -o tsv)

PLAN_PUBLISHER=$(az vm image show --urn "$URN" --query plan.publisher -o tsv)
PLAN_PRODUCT=$(az vm image show --urn "$URN" --query plan.product   -o tsv)
PLAN_NAME=$(az vm image show --urn "$URN" --query plan.name         -o tsv)

echo "Deploying FortiGate VM: $SITE"
echo "  RG=$RG  LOC=$LOC"
echo "  VM=$VM  SIZE=$SIZE"
echo "  URN=$URN"
echo "  NIC order: WAN1 (primary), WAN2, LAN"

az vm image terms accept --urn "$URN"

az vm create \
  --resource-group "$RG" \
  --location "$LOC" \
  --name "$VM" \
  --size "$SIZE" \
  --image "$URN" \
  --nics "$NIC_WAN1_ID" "$NIC_WAN2_ID" "$NIC_LAN_ID" \
  --os-disk-size-gb "$DISK_SIZE" \
  --storage-sku "$DISK_SKU" \
  --admin-username azureuser \
  --generate-ssh-keys \
  --plan-publisher "$PLAN_PUBLISHER" \
  --plan-product "$PLAN_PRODUCT" \
  --plan-name "$PLAN_NAME"

echo "Done: $SITE"
