#!/bin/bash
set -e

echo "========================================"
echo "Secure Transport Lab - Full Deployment"
echo "========================================"

# -------------------------------
# Networks
# -------------------------------

echo "Deploying hub network..."
./deploy-hub.sh hub1

echo "Deploying spoke networks..."
for site in spk1 spk2 spk3
do
  ./deploy-spoke.sh "$site"
done

echo "Deploying remote networks..."
for site in rem1
do
  ./deploy-remote.sh "$site"
done

# -------------------------------
# FortiGate VMs
# -------------------------------

echo "Deploying FortiGate VMs..."
for vm in vm-fst-hub1-fgt1 vm-fst-spk1-fgt1 vm-fst-spk2-fgt1 vm-fst-spk3-fgt1
do
  ./deploy-fgt.sh "$vm"
done

# -------------------------------
# Windows VMs
# -------------------------------

echo "Deploying Windows VMs..."
for vm in vm-fst-hub1-ads1 vm-fst-spk1-win1 vm-fst-spk2-win1 vm-fst-rem1-win1 vm-fst-rem1-win2
do
  ./deploy-windows.sh "$vm"
done

# -------------------------------
# Fortinet Management / Services
# -------------------------------

echo "Deploying FortiManager..."
./deploy-fmg.sh vm-fst-hub1-fmg1

echo "Deploying FortiAnalyzer..."
./deploy-faz.sh vm-fst-hub1-faz1

echo "Deploying FortiAuthenticator..."
./deploy-fac.sh vm-fst-hub1-fac1

echo "========================================"
echo "Full deployment complete"
echo "========================================"
