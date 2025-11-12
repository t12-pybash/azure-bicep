# Jenkins Build Agent - Azure Demo

Demo project showing automated provisioning of Jenkins build infrastructure using Azure Bicep.

## What This Demonstrates

- Bicep IaC: Declarative infrastructure for build agents
- Azure Resources: VM, VNet, Storage for artifacts
- Build Automation: Simulated firmware build pipeline
- DevOps Practices: Everything-as-code approach

## Architecture

Azure Resource Group
├── Virtual Network (10.0.0.0/16)
├── Ubuntu VM (Build Agent)
│   ├── Docker
│   ├── Java (for Jenkins)
│   ├── ARM cross-compiler
│   └── Build tools
└── Storage Account (Firmware artifacts)

## Quick Start

Prerequisites:
- Azure CLI: az login
- SSH key: ssh-keygen -t rsa -b 4096

Deploy:
./scripts/deploy.sh

Test Build:
ssh azureuser@VM_IP
./build-firmware.sh core-110f 1.0.0

Cleanup:
az group delete --name qscbuild-demo-rg --yes --no-wait

## Project Structure

bicep/
├── main.bicep
├── vm.bicep
├── network.bicep
└── storage.bicep
scripts/
├── deploy.sh
└── build-firmware.sh

##Build Infrastructure

- Jenkins agents in Azure
- Build artifacts in Azure Storage
- ARM cross-compilation
- Infrastructure as Code with Bicep

## Cost

VM: ~$15/month, Storage: ~$1/month, Demo: ~$0.50/hour

## Relevance to Role

Demonstrates Bicep IaC, build agent provisioning, Azure infrastructure automation, and DevOps best practices.
