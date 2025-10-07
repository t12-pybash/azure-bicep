// main.bicep - Jenkins Build Agent Infrastructure
targetScope = 'resourceGroup'

@description('Location for all resources')
param location string = resourceGroup().location

@description('Project name prefix')
param projectName string = 'qscbuild'

@description('Admin username for VM')
param adminUsername string = 'azureuser'

@description('SSH public key for VM access')
@secure()
param sshPublicKey string

// Virtual Network
module network 'network.bicep' = {
  name: 'networkDeployment'
  params: {
    location: location
    projectName: projectName
  }
}

// Storage Account for build artifacts
module storage 'storage.bicep' = {
  name: 'storageDeployment'
  params: {
    location: location
    projectName: projectName
  }
}

// Jenkins Build Agent VM
module buildAgent 'vm.bicep' = {
  name: 'buildAgentDeployment'
  params: {
    location: location
    projectName: projectName
    adminUsername: adminUsername
    sshPublicKey: sshPublicKey
    subnetId: network.outputs.subnetId
  }
}

// Outputs
output vmPublicIp string = buildAgent.outputs.publicIp
output storageAccountName string = storage.outputs.storageAccountName
output vmName string = buildAgent.outputs.vmName
output resourceGroupName string = resourceGroup().name
