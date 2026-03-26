# Hub Deployment

Deploys the Azure Networking components for the SD-WAN Hub sites

## Deploy

Run from Azure Cloud Shell (Bash):

```bash
# remove existing repo (if present)
rm -rf secure-transport-lab

# clone latest repo
git clone https://github.com/jtanderson2/secure-transport-lab.git

# change to hub deployment directory
cd secure-transport-lab/azure/hubs

# make scripts executable
chmod +x *.sh

# deploy hub1
./deploy-hub.sh hub1

# deploy hub2
./deploy-hub.sh hub2
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
# destroy hub1
az group delete -n rg-fst-hub1 --yes --no-wait

# destroy hub2
az group delete -n rg-fst-hub2 --yes --no-wait
```
