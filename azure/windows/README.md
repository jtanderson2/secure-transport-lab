# Windows Deployment

Deploys Windows Servers into Hub, Spokes and Remotes. Ensure respective Azure Networking components are deployed first.

## Deploy

Run from Azure Cloud Shell (Bash):

```bash
# remove existing repo (if present)
rm -rf secure-transport-lab

# clone latest repo
git clone https://github.com/jtanderson2/secure-transport-lab.git

# change to windows deployment directory
cd secure-transport-lab/azure/windows

# make scripts executable
chmod +x *.sh

# deploy hub1-ads1
./deploy-windows.sh vm-fst-hub1-ads1

# deploy spk1-win1
./deploy-windows.sh vm-fst-spk1-win1

# deploy spk2-win1
./deploy-windows.sh vm-fst-spk2-win1

# deploy spk3-win1
./deploy-windows.sh vm-fst-spk3-win1

# deploy rem1-win1
./deploy-windows.sh vm-fst-rem1-win1

# deploy rem1-win2
./deploy-windows.sh vm-fst-rem1-win2
```
This deploys in order:

- NIC
- FortiGate VM

## Destroy

Run from Azure Cloud Shell (Bash):

```bash
# destroy hub1-ads1
az vm delete -g rg-fst-hub1 -n vm-fst-hub1-ads1 --yes --no-wait

# destroy spk1-win1
az vm delete -g rg-fst-spk1 -n vm-fst-spk1-win1 --yes --no-wait

# destroy spk2-win1
az vm delete -g rg-fst-spk2 -n vm-fst-spk2-win1 --yes --no-wait

# destroy spk3-win1
az vm delete -g rg-fst-spk3 -n vm-fst-spk3-win1 --yes --no-wait

# destroy rem1-win1
az vm delete -g rg-fst-rem1 -n vm-fst-rem1-win1 --yes --no-wait

# destroy rem1-win2
az vm delete -g rg-fst-rem1 -n vm-fst-rem1-win2 --yes --no-wait
```



