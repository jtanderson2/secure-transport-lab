# Remote Deployment

Deploys the Azure Networking components for Remote User sites.

## Deploy

Run from Azure Cloud Shell (Bash):

```bash
# remove existing repo (if present)
rm -rf secure-transport-lab

# clone latest repo
git clone https://github.com/jtanderson2/secure-transport-lab.git

# change to remotes deployment directory
cd secure-transport-lab/azure/remotes

# make scripts executable
chmod +x *.sh

# deploy rem1
./deploy-remote.sh rem1

```
This deploys in order:

- Resource Group
- VNET
- Subnets

## Destroy

Run from Azure Cloud Shell (Bash):

```bash
# destroy rem1
az group delete -n rg-fst-rem1 --yes --no-wait

```


