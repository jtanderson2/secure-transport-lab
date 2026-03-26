#!/bin/bash
set -e

VM_NAME=$1
[[ -z "$VM_NAME" ]] && { echo "Usage: $0 <vm-name>"; exit 1; }
DATA_FILE=./fortiauthenticator.json

RG=$(jq -r ".\"$VM_NAME\".rg" $DATA_FILE)
LOC=$(jq -r ".\"$VM_NAME\".location" $DATA_FILE)

HOSTNAME=$(jq -r ".\"$VM_NAME\".hostname" $DATA_FILE)
SIZE=$(jq -r ".\"$VM_NAME\".vmSize" $DATA_FILE)
URN=$(jq -r ".\"$VM_NAME\".imageUrn" $DATA_FILE)

DISK_SKU=$(jq -r ".\"$VM_NAME\".osDisk.sku" $DATA_FILE)
DISK_SIZE=$(jq -r ".\"$VM_NAME\".osDisk.sizeGb" $DATA_FILE)

NIC_NAME=$(jq -r ".\"$VM_NAME\".nic.name" $DATA_FILE)
VNET_NAME=$(jq -r ".\"$VM_NAME\".nic.vnet" $DATA_FILE)
SNET_NAME=$(jq -r ".\"$VM_NAME\".nic.subnet" $DATA_FILE)
NIC_IP=$(jq -r ".\"$VM_NAME\".nic.privateIp" $DATA_FILE)

echo "Deploying FortiAuthenticator VM: $VM_NAME"
echo "  RG=$RG  LOC=$LOC"
echo "  HOSTNAME=$HOSTNAME"
echo "  SIZE=$SIZE"
echo "  URN=$URN"

# NIC
az network nic create \
  --resource-group "$RG" \
  --name "$NIC_NAME" \
  --location "$LOC" \
  --vnet-name "$VNET_NAME" \
  --subnet "$SNET_NAME" \
  --private-ip-address "$NIC_IP"

# Marketplace plan
PLAN_PUBLISHER=$(az vm image show --urn "$URN" --query plan.publisher -o tsv)
PLAN_PRODUCT=$(az vm image show --urn "$URN" --query plan.product -o tsv)
PLAN_NAME=$(az vm image show --urn "$URN" --query plan.name -o tsv)

az vm image terms accept --urn "$URN"

# VM
az vm create \
  --resource-group "$RG" \
  --location "$LOC" \
  --name "$VM_NAME" \
  --computer-name "$HOSTNAME" \
  --size "$SIZE" \
  --image "$URN" \
  --nics "$NIC_NAME" \
  --os-disk-size-gb "$DISK_SIZE" \
  --storage-sku "$DISK_SKU" \
  --admin-username fstadmin \
  --admin-password 'F@rT15eCuR3!' \
  --plan-publisher "$PLAN_PUBLISHER" \
  --plan-product "$PLAN_PRODUCT" \
  --plan-name "$PLAN_NAME" \
  --boot-diagnostics-storage ""

echo "Done: $VM_NAME"
