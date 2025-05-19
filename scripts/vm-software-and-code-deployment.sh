#!/bin/bash

VM_NAME="movie-rating-vm"
ADMIN_USERNAME="azureuser"
RESOURCE_GROUP="KDG"
PUBLIC_IP=$(az vm show -d -g $RESOURCE_GROUP -n $VM_NAME --query publicIps -o tsv)
PRIVATE_KEY_PATH="~/.ssh/1747328742_3007941"
# Note: Use this cmd to create public & private key
# az sshkey create --name "movie-rating-ssh" --resource-group "KDG"
# chmod 600 ~/.ssh/1747328742_3007941

# We've to add a if else if repo is their just do git pull not git clone

cat <<EOF > run-on-vm.sh
#!/bin/bash

sudo dnf update -y

sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

sudo systemctl start docker

sudo dnf install git -y

git clone https://gitlab.com/geetika.sethi/infra3-movie-rating-docker-app.git

cd infra3-movie-rating-docker-app

sudo docker compose up -d
EOF


# Upload deploy script
scp -i $PRIVATE_KEY_PATH -o StrictHostKeyChecking=no run-on-vm.sh $ADMIN_USERNAME@$PUBLIC_IP:/home/$ADMIN_USERNAME/

# Execute deploy script
ssh -i $PRIVATE_KEY_PATH -o StrictHostKeyChecking=no $ADMIN_USERNAME@$PUBLIC_IP 'bash run-on-vm.sh'
