# FortiAuthenticator Deployment

Deploys FortiAuthenticator into Hub1. Ensure Hub1 Azure Networking components are deployed first.

## Deploy

Run from Azure Cloud Shell (Bash):

```bash
# remove existing repo (if present)
rm -rf secure-transport-lab

# clone latest repo
git clone https://github.com/jtanderson2/secure-transport-lab.git

# change to fortiauthenticator deployment directory
cd secure-transport-lab/azure/fortiauthenticator

# make scripts executable
chmod +x *.sh

# deploy fac1
./deploy-fac.sh vm-fst-hub1-fac1

```
This deploys in order:

- NIC
- FortiAuthenticator VM

## Destroy

Run from Azure Cloud Shell (Bash):

```bash
# destroy fac1
az vm delete -g rg-fst-hub1 -n vm-fst-hub1-fac1 --yes --no-wait

```



