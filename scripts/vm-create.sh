#!/bin/bash

VM_NAME="movie-rating-vm"
LOCATION="westeurope"
ZONE="1"
VM_SIZE="Standard_B2s"
ADMIN_USERNAME="azureuser"
PUBLIC_KEY_PATH="~/.ssh/1747328742_3007941.pub"
IMAGE_PUBLISHER="almalinux"
IMAGE_OFFER="almalinux-x86_64"
IMAGE_SKU="9-gen2"
IMAGE_VERSION="latest"
OS_DISK_SIZE_GB=30
OS_DISK_TYPE="StandardSSD_LRS"
RESOURCE_GROUP="KDG"

STORAGE_ACCOUNT_NAME=$(echo "${VM_NAME}sa$(date +%s | tail -c 4)" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g' | cut -c 1-24)

echo "Creating storage account $STORAGE_ACCOUNT_NAME for boot diagnostics..."
az storage account create \
    --resource-group $RESOURCE_GROUP \
    --name $STORAGE_ACCOUNT_NAME \
    --location $LOCATION \
    --sku Standard_LRS

echo "Creating virtual machine $VM_NAME..."
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --location $LOCATION \
    --zone $ZONE \
    --size $VM_SIZE \
    --image "${IMAGE_PUBLISHER}:${IMAGE_OFFER}:${IMAGE_SKU}:${IMAGE_VERSION}" \
    --os-disk-name "${VM_NAME}_OsDisk_1_ec75a6bc609740aab6c28a126619bd2c" \
    --os-disk-size-gb $OS_DISK_SIZE_GB \
    --storage-sku $OS_DISK_TYPE \
    --admin-username $ADMIN_USERNAME \
    --ssh-key-values "$PUBLIC_KEY_PATH" \
    --security-type TrustedLaunch \
    --enable-secure-boot true \
    --enable-vtpm true \
    --public-ip-sku Standard \
    --nic-delete-option Detach \
    --os-disk-delete-option Delete \
    --boot-diagnostics-storage $STORAGE_ACCOUNT_NAME

if [ $? -eq 0 ]; then
    echo "Virtual machine created successfully:"
    az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details
    
    PUBLIC_IP=$(az vm show -d -g $RESOURCE_GROUP -n $VM_NAME --query publicIps -o tsv)
    echo "Public IP: $PUBLIC_IP"
else
    echo "Failed to create virtual machine. Check the error messages above."
    exit 1
fi

echo "Setup complete!"

echo "Enable Port 80 & 443"

az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 80

az vm open-port --resource-group $RESOURCE_GROUP --name $VM_NAME --port 443 --priority 940