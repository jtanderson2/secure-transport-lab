# FortiGate Deployment

Deploys FortiGates into Hub and Spokes. Ensure respective Azure Networking components are deployed first.

## Deploy

Run from Azure Cloud Shell (Bash):

```bash
# remove existing repo (if present)
rm -rf secure-transport-lab

# clone latest repo
git clone https://github.com/jtanderson2/secure-transport-lab.git

# change to fortigate deployment directory
cd secure-transport-lab/azure/fortigates

# make scripts executable
chmod +x *.sh

# deploy hub1-fgt1
./deploy-fgt.sh vm-fst-hub1-fgt1

# deploy spk1-fgt1
./deploy-fgt.sh vm-fst-spk1-fgt1

# deploy spk2-fgt1
./deploy-fgt.sh vm-fst-spk2-fgt1

# deploy spk3-fgt1
./deploy-fgt.sh vm-fst-spk3-fgt1

```
This deploys in order:

- FortiGate VM (NICs are created in hub/spoke networking scipts)

## Destroy

Run from Azure Cloud Shell (Bash):

```bash
# destroy hub1-fgt1
az vm delete -g rg-fst-hub1 -n vm-fst-hub1-fgt1 --yes --no-wait

# destroy spk1-fgt1
az vm delete -g rg-fst-spk1 -n vm-fst-spk1-fgt1 --yes --no-wait

# destroy spk2-fgt1
az vm delete -g rg-fst-spk2 -n vm-fst-spk2-fgt1 --yes --no-wait

# destroy spk3-fgt1
az vm delete -g rg-fst-spk3 -n vm-fst-spk3-fgt1 --yes --no-wait
```



