# Secure Transport Lab – Azure Deployment

This repository contains a modular Azure lab that emulates a Fortinet SD-WAN environment across hub, spoke, and remote sites, with supporting services and workloads.

Azure is used to replicate SD-WAN underlay. All connectivity is via overlay (no VNet peering).

## Deployment

Run from Azure Cloud Shell (Bash):

```bash
# remove existing repo (if present)
rm -rf secure-transport-lab

# clone latest repo
git clone https://github.com/jtanderson2/secure-transport-lab.git

# change to Azure deployment directory
cd secure-transport-lab/azure

# make scripts executable
chmod +x *.sh */*.sh

# deploy full lab
./deploy-all.sh
```

This deploys in order:

- Hub network
- Spoke networks
- Remote networks
- FortiGate VMs
- Windows VMs
- Management (FortiManager, FortiAnalyzer, FortiAuthenticator)

All deployments are Azure CLI-driven using JSON configuration files.

No OS configuration or Fortinet licensing is applied. BYOL is assumed.

## Modular Deployment

Components can be deployed individually from their folders:

- `hubs`, `spokes`, `remotes`
- `fortigates`
- `fortimanager`, `fortianalyzer`, `fortiauthenticator`
- `windows`

See each folder for component-specific instructions.

## Initial Access

- FortiGates: accessible via public IP
- Windows VMs: access via Azure Bastion (Developer SKU)
- Management (FMG/FAZ/FAC): access via hub Bastion or Windows VM
- Additional access options available once SD-WAN overlay is configured

VM Credentials

- Username: `fstadmin`
- Password: `F@rT15eCuR3!` *(change after first login)*

## Destroy

Run from Azure Cloud Shell (Bash):

```bash
# assumes repo is cloned into azcli session, see above

# change to Azure deployment directory
cd secure-transport-lab/azure

# destroy full lab
./destroy-all.sh
```
