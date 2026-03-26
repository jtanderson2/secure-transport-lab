# Spoke Deployment

Deploys the Azure Networking components for the SD-WAN Spoke sites.

## Deploy

Run from Azure Cloud Shell (Bash):

```bash
# remove existing repo (if present)
rm -rf secure-transport-lab

# clone latest repo
git clone https://github.com/jtanderson2/secure-transport-lab.git

# change to spoke deployment directory
cd secure-transport-lab/azure/spokes

# make scripts executable
chmod +x *.sh

# deploy spk1
./deploy-spoke.sh spk1

# deploy spk2
./deploy-spoke.sh spk2

# deploy spk3
./deploy-spoke.sh spk3
```
This deploys in order:

- Resource Group
- VNET
- Subnets
- Route Tables
- WAN NSGs (any-any)
- Public IPS
- NICs For Hub FortiGates

## Destroy

Run from Azure Cloud Shell (Bash):

```bash
# destroy spk1
az group delete -n rg-fst-spk1 --yes --no-wait

# destroy spk2
az group delete -n rg-fst-spk2 --yes --no-wait

# destroy spk3
az group delete -n rg-fst-spk3 --yes --no-wait
```

