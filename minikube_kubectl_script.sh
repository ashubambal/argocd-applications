#!/bin/bash

# Updating system and installing Docker
echo "Updating system and installing Docker..."
sudo apt update -y
sudo apt install docker.io -y
sudo usermod -aG docker $USER
echo "System update and Docker installation completed."

# Installing kubectl
echo "Installing kubectl..."
echo "***********************************************************************************"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Making kubectl executable and moving it to /usr/local/bin
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# Verifying kubectl installation
kubectl version --client
echo "kubectl installed successfully."

# Installing Minikube
echo "Installing Minikube..."
echo "***********************************************************************************"
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64

# Moving Minikube to /usr/local/bin
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

# Starting Minikube
echo "Starting Minikube..."
minikube start
echo "Minikube started successfully."

# Installing K9S 
echo "Installing K9S..."
echo "***********************************************************************************"
VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)
wget https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_amd64.tar.gz
tar -xvf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/
rm -f k9s_Linux_amd64.tar.gz
echo "k9s Installed successfully."
echo "***********************************************************************************"
