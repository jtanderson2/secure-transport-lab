# FortiAnalyzer Deployment

Deploys FortiAnalyzer into Hub1. Ensure Hub1 Azure Networking components are deployed first.

## Deploy

Run from Azure Cloud Shell (Bash):

```bash
# remove existing repo (if present)
rm -rf secure-transport-lab

# clone latest repo
git clone https://github.com/jtanderson2/secure-transport-lab.git

# change to fortimanager deployment directory
cd secure-transport-lab/azure/fortianalyzer

# make scripts executable
chmod +x *.sh

# deploy faz1
./deploy-faz.sh vm-fst-hub1-faz1

```
This deploys in order:

- NIC
- FortiAnalyzer VM

## Destroy

Run from Azure Cloud Shell (Bash):

```bash
# destroy faz1
az vm delete -g rg-fst-hub1 -n vm-fst-hub1-faz1 --yes --no-wait

```


