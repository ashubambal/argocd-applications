#!/bin/bash

set -e  # Stop the script on any error

echo "🚀 Starting setup..."

# ================================
# 1. System Update & Docker Installation
# ================================

echo "🔍 Updating system and installing Docker..."
sudo apt update -y
sudo apt install docker.io -y
echo "✅ Docker installed successfully."

# Add user to the docker group
echo "🔧 Adding current user to the 'docker' group..."
sudo usermod -aG docker $USER
newgrp docker

# Verify Docker installation
echo "🧪 Verifying Docker installation..."
docker version
if [ $? -ne 0 ]; then
  echo "❌ Docker installation failed. Please check Docker logs."
  exit 1
fi
echo "✅ Docker installed successfully."

read -p "Press Enter to continue..."


# ================================
# 2. Install kubectl
# ================================

echo "🔍 Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Making kubectl executable and moving it to /usr/local/bin
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# Verifying kubectl installation
echo "🧪 Verifying kubectl installation..."
kubectl version --client
if [ $? -ne 0 ]; then
  echo "❌ kubectl installation failed."
  exit 1
fi
echo "✅ kubectl installed successfully."

read -p "Press Enter to continue..."


# ================================
# 3. Install Minikube
# ================================

echo "🔍 Installing Minikube..."
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64

# Moving Minikube to /usr/local/bin
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

# Verifying Minikube installation
echo "🧪 Verifying Minikube installation..."
minikube version
if [ $? -ne 0 ]; then
  echo "❌ Minikube installation failed."
  exit 1
fi
echo "✅ Minikube installed successfully."

read -p "Press Enter to continue..."


# ================================
# 4. Start Minikube
# ================================

echo "🚦 Starting Minikube..."
minikube start
if [ $? -ne 0 ]; then
  echo "❌ Minikube failed to start. Check logs for more details."
  exit 1
fi
echo "✅ Minikube started successfully."

read -p "Press Enter to continue..."


# ================================
# 5. Install K9S
# ================================

echo "🔍 Installing K9S..."
VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)
wget https://github.com/derailed/k9s/releases/download/${VERSION}/k9s_Linux_amd64.tar.gz
tar -xvf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/
rm -f k9s_Linux_amd64.tar.gz

# Verifying K9S installation
echo "🧪 Verifying K9S installation..."
k9s version
if [ $? -ne 0 ]; then
  echo "❌ K9S installation failed."
  exit 1
fi
echo "✅ K9S installed successfully."

read -p "Press Enter to continue..."


# ================================
# 🎉 Final Message
# ================================

echo "***********************************************************************************"
echo "✅ All tools installed successfully! 🚀"
echo "Docker, kubectl, Minikube, and K9S are ready to use."
echo "You can now run 'minikube status' or 'kubectl get nodes' to verify."
echo "***********************************************************************************"

