targetScope = 'subscription'

param rgName string
param location string
param siteName string

@description('VNet address spaces (array)')
param addressSpace array

param lanSubnetPrefix string
param wan1SubnetPrefix string
param wan2SubnetPrefix string
param bastionSubnetPrefix string

@description('FortiGate LAN IP used as default route next hop')
param lanNextHopIp string

@description('NIC definitions object')
param nics object

param tags object = {}

//
// Resource Group
//
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
  tags: tags
}

//
// WAN NSGs (Compliance Only – Permit All Inbound)
//
resource nsgWan1 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'nsg-${siteName}-wan1'
  scope: rg
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-all-inbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource nsgWan2 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'nsg-${siteName}-wan2'
  scope: rg
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-all-inbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

//
// Virtual Network
//
resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'vnet-${siteName}'
  scope: rg
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressSpace
    }
  }
}

//
// Route Table (LAN Only)
//
resource lanRouteTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: 'rt-${siteName}-lan'
  scope: rg
  location: location
  properties: {
    routes: [
      {
        name: 'default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: lanNextHopIp
        }
      }
    ]
  }
}

//
// Subnets
//
resource lanSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: 'vnet-${siteName}/snet-lan'
  scope: rg
  properties: {
    addressPrefix: lanSubnetPrefix
    routeTable: {
      id: lanRouteTable.id
    }
  }
}

resource wan1Subnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: 'vnet-${siteName}/snet-wan1'
  scope: rg
  properties: {
    addressPrefix: wan1SubnetPrefix
    networkSecurityGroup: {
      id: nsgWan1.id
    }
  }
}

resource wan2Subnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: 'vnet-${siteName}/snet-wan2'
  scope: rg
  properties: {
    addressPrefix: wan2SubnetPrefix
    networkSecurityGroup: {
      id: nsgWan2.id
    }
  }
}

resource bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: 'vnet-${siteName}/AzureBastionSubnet'
  scope: rg
  properties: {
    addressPrefix: bastionSubnetPrefix
  }
}

//
// Public IPs
//
resource wan1Pip 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: 'pip-${siteName}-wan1'
  scope: rg
  location: location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource wan2Pip 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: 'pip-${siteName}-wan2'
  scope: rg
  location: location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionPip 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: 'pip-fst-${siteName}-bst'
  scope: rg
  location: location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

//
// NICs
//
resource lanNic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: nics.lan.name
  scope: rg
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: nics.lan.privateIp
          subnet: {
            id: lanSubnet.id
          }
        }
      }
    ]
  }
}

resource wan1Nic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: nics.wan1.name
  scope: rg
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: nics.wan1.privateIp
          subnet: {
            id: wan1Subnet.id
          }
          publicIPAddress: {
            id: wan1Pip.id
          }
        }
      }
    ]
  }
}

resource wan2Nic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: nics.wan2.name
  scope: rg
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: nics.wan2.privateIp
          subnet: {
            id: wan2Subnet.id
          }
          publicIPAddress: {
            id: wan2Pip.id
          }
        }
      }
    ]
  }
}
