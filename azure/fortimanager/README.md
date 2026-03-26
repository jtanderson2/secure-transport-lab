# FortiManager Deployment

Deploys FortiManager into Hub1. Ensure Hub1 Azure Networking components are deployed first.

## Deploy

Run from Azure Cloud Shell (Bash):

```bash
# remove existing repo (if present)
rm -rf secure-transport-lab

# clone latest repo
git clone https://github.com/jtanderson2/secure-transport-lab.git

# change to fortimanager deployment directory
cd secure-transport-lab/azure/fortimanager

# make scripts executable
chmod +x *.sh

# deploy fmg1
./deploy-fmg.sh vm-fst-hub1-fmg1

```
This deploys in order:

- NIC
- FortiManager VM

## Destroy

Run from Azure Cloud Shell (Bash):

```bash
# destroy fmg1
az vm delete -g rg-fst-hub1 -n vm-fst-hub1-fmg1 --yes --no-wait

```


