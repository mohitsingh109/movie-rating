#!/bin/bash

TOKEN="f8baa8b9-3b39-432c-b21f-e643ddd1bcb5"
DOMAIN="mr-mohit"
RESOURCE_GROUP="KDG"
VM_NAME="movie-rating-vm"
VM_PUBLIC_IP=$(az vm show -d -g $RESOURCE_GROUP -n $VM_NAME --query publicIps -o tsv)

url="https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=$VM_PUBLIC_IP"
echo $url
curl -X GET $url
