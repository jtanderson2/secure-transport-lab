#!/bin/bash
set -e

VM_NAME=$1
DATA_FILE=./windows.json

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

echo "Deploying Windows VM: $VM_NAME"
echo "  RG=$RG  LOC=$LOC"
echo "  HOSTNAME=$HOSTNAME"
echo "  SIZE=$SIZE"
echo "  URN=$URN"
echo "  NIC=$NIC_NAME  IP=$NIC_IP"

# Create NIC
az network nic create \
  --resource-group "$RG" \
  --name "$NIC_NAME" \
  --location "$LOC" \
  --vnet-name "$VNET_NAME" \
  --subnet "$SNET_NAME" \
  --private-ip-address "$NIC_IP" \
  --accelerated-networking true

# Create VM
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
  --boot-diagnostics-storage ""

echo "Done: $VM_NAME"
