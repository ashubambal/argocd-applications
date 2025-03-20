#!/bin/bash

# Updating system and installing Docker
echo "Updating system and installing Docker..."
sudo apt update -y
sudo apt install docker.io -y

# Add the current user to the docker group and apply the change immediately
sudo usermod -aG docker $USER
newgrp docker

# Verify Docker installation
echo "Verifying Docker installation..."
docker version
if [ $? -ne 0 ]; then
  echo "Docker installation failed or permissions not applied correctly."
  exit 1
fi
echo "Docker installed and configured successfully."

# Installing kubectl
echo "Installing kubectl..."
echo "***********************************************************************************"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Making kubectl executable and moving it to /usr/local/bin
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# Verifying kubectl installation
kubectl version --client
if [ $? -ne 0 ]; then
  echo "kubectl installation failed."
  exit 1
fi
echo "kubectl installed successfully."

# Installing Minikube
echo "Installing Minikube..."
echo "***********************************************************************************"
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64

# Moving Minikube to /usr/local/bin
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

# Verifying Minikube installation
minikube version
if [ $? -ne 0 ]; then
  echo "Minikube installation failed."
  exit 1
fi
echo "Minikube installed successfully."

# Starting Minikube
echo "Starting Minikube..."
minikube start
if [ $? -ne 0 ]; then
  echo "Minikube failed to start. Check logs for more details."
  exit 1
fi
echo "Minikube started successfully."

# Installing K9S
echo "Installing K9S..."
echo "***********************************************************************************"
VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)
wget https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_amd64.tar.gz
tar -xvf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/
rm -f k9s_Linux_amd64.tar.gz

# Verifying K9S installation
k9s version
if [ $? -ne 0 ]; then
  echo "K9S installation failed."
  exit 1
fi
echo "k9s installed successfully."
echo "***********************************************************************************"

echo "All tools installed successfully! 🚀"

