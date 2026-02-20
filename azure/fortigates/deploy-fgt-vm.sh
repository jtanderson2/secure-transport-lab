#!/bin/bash
set -e

VM_NAME=$1
DATA_FILE=./fortigates.json

RG=$(jq -r ".\"$VM_NAME\".rg" $DATA_FILE)
LOC=$(jq -r ".\"$VM_NAME\".location" $DATA_FILE)

SIZE=$(jq -r ".\"$VM_NAME\".vmSize" $DATA_FILE)
URN=$(jq -r ".\"$VM_NAME\".imageUrn" $DATA_FILE)

DISK_SKU=$(jq -r ".\"$VM_NAME\".osDisk.sku" $DATA_FILE)
DISK_SIZE=$(jq -r ".\"$VM_NAME\".osDisk.sizeGb" $DATA_FILE)

NIC_WAN1_NAME=$(jq -r ".\"$VM_NAME\".nics.wan1" $DATA_FILE)
NIC_WAN2_NAME=$(jq -r ".\"$VM_NAME\".nics.wan2" $DATA_FILE)
NIC_LAN_NAME=$(jq -r ".\"$VM_NAME\".nics.lan"  $DATA_FILE)

NIC_WAN1_ID=$(az network nic show -g "$RG" -n "$NIC_WAN1_NAME" --query id -o tsv)
NIC_WAN2_ID=$(az network nic show -g "$RG" -n "$NIC_WAN2_NAME" --query id -o tsv)
NIC_LAN_ID=$(az network nic show -g "$RG" -n "$NIC_LAN_NAME"  --query id -o tsv)

PLAN_PUBLISHER=$(az vm image show --urn "$URN" --query plan.publisher -o tsv)
PLAN_PRODUCT=$(az vm image show --urn "$URN" --query plan.product   -o tsv)
PLAN_NAME=$(az vm image show --urn "$URN" --query plan.name         -o tsv)

echo "Deploying FortiGate VM: $VM_NAME"
echo "  RG=$RG  LOC=$LOC"
echo "  SIZE=$SIZE"
echo "  URN=$URN"
echo "  NIC order: WAN1 (primary), WAN2, LAN"

az vm image terms accept --urn "$URN"

az vm create \
  --resource-group "$RG" \
  --location "$LOC" \
  --name "$VM_NAME" \
  --size "$SIZE" \
  --image "$URN" \
  --nics "$NIC_WAN1_ID" "$NIC_WAN2_ID" "$NIC_LAN_ID" \
  --os-disk-size-gb "$DISK_SIZE" \
  --storage-sku "$DISK_SKU" \
  --admin-username fstadmin \
  --admin-password 'F@rT15eCuR3!' \
  --plan-publisher "$PLAN_PUBLISHER" \
  --plan-product "$PLAN_PRODUCT" \
  --plan-name "$PLAN_NAME" \
  --boot-diagnostics-storage "" \
  --security-type TrustedLaunch \
  --enable-secure-boot false \
  --enable-vtpm false

echo "Done: $VM_NAME"
