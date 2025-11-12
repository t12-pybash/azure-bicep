#!/bin/bash
set -e

PROJECT_NAME="qscbuild"
LOCATION="westeurope"
RESOURCE_GROUP="${PROJECT_NAME}-demo-rg"

echo " Deploying Jenkins Build Agent Infrastructure"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check Azure login
if ! az account show &> /dev/null; then
    echo " Not logged in. Run: az login"
    exit 1
fi

# Check SSH key
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo " No SSH key found. Generate with: ssh-keygen -t rsa -b 4096"
    exit 1
fi

SSH_KEY=$(cat ~/.ssh/id_rsa.pub)

# Create resource group
echo " Creating resource group..."
az group create \
    --name "${RESOURCE_GROUP}" \
    --location "${LOCATION}" \
    --output table

# Deploy infrastructure
echo " Deploying Bicep templates..."
az deployment group create \
    --resource-group "${RESOURCE_GROUP}" \
    --template-file bicep/main.bicep \
    --parameters projectName="${PROJECT_NAME}" \
    --parameters sshPublicKey="${SSH_KEY}" \
    --output table

# Get outputs
VM_IP=$(az deployment group show \
    --resource-group "${RESOURCE_GROUP}" \
    --name main \
    --query properties.outputs.vmPublicIp.value -o tsv)

STORAGE=$(az deployment group show \
    --resource-group "${RESOURCE_GROUP}" \
    --name main \
    --query properties.outputs.storageAccountName.value -o tsv)

echo ""
echo " Deployment Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "VM IP:      ${VM_IP}"
echo "Storage:    ${STORAGE}"
echo "SSH:        ssh azureuser@${VM_IP}"
echo ""
echo "🗑️  Cleanup: az group delete --name ${RESOURCE_GROUP} --yes --no-wait"
