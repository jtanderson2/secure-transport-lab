#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo "Secure Transport Lab - Full Deployment"
echo "========================================"

echo "Deploying hub network..."
cd "$BASE_DIR/hubs"
bash ./deploy-hub.sh hub1
cd "$BASE_DIR"

echo "Deploying spoke networks..."
cd "$BASE_DIR/spokes"
for site in spk1 spk2 spk3
do
  bash ./deploy-spoke.sh "$site"
done
cd "$BASE_DIR"

echo "Deploying remote networks..."
cd "$BASE_DIR/remotes"
for site in rem1
do
  bash ./deploy-remote.sh "$site"
done
cd "$BASE_DIR"

echo "Deploying FortiGate VMs..."
cd "$BASE_DIR/fortigates"
for vm in vm-fst-hub1-fgt1 vm-fst-spk1-fgt1 vm-fst-spk2-fgt1 vm-fst-spk3-fgt1
do
  bash ./deploy-fgt.sh "$vm"
done
cd "$BASE_DIR"

echo "Deploying Windows VMs..."
cd "$BASE_DIR/windows"
for vm in vm-fst-hub1-ads1 vm-fst-spk1-win1 vm-fst-spk2-win1 vm-fst-rem1-win1 vm-fst-rem1-win2
do
  bash ./deploy-windows.sh "$vm"
done
cd "$BASE_DIR"

echo "Deploying FortiManager..."
cd "$BASE_DIR/fortimanager"
bash ./deploy-fmg.sh vm-fst-hub1-fmg1
cd "$BASE_DIR"

echo "Deploying FortiAnalyzer..."
cd "$BASE_DIR/fortianalyzer"
bash ./deploy-faz.sh vm-fst-hub1-faz1
cd "$BASE_DIR"

echo "Deploying FortiAuthenticator..."
cd "$BASE_DIR/fortiauthenticator"
bash ./deploy-fac.sh vm-fst-hub1-fac1
cd "$BASE_DIR"

echo "========================================"
echo "Full deployment complete"
echo "========================================"
