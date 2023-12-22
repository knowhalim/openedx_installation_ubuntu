#!/bin/bash

# Update and upgrade packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Adding new user and setting up sudo privileges
adduser tutoruser # Follow the prompts to set the password and user details
echo "tutoruser  ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

# Install necessary packages
sudo apt install -y python3 python3-pip libyaml-dev apt-transport-https ca-certificates curl software-properties-common

# Install and setup Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install specific version of Docker for tutor
VERSION_STRING=5:20.10.15~3-0~ubuntu-focal
sudo apt-get install -y docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo groupadd docker
sudo usermod -aG docker tutoruser

# Install Tutor and plugins
sudo pip install "tutor[full]"
sudo pip install tutor-indigo

# Set Tutor plugins root environment variable
export TUTOR_PLUGINS_ROOT="/home/tutoruser/.local/share/tutor/plugins"

# Reboot to apply changes
sudo reboot

# The following commands need to be run after reboot, as tutoruser
# su tutoruser
# tutor local launch -d
# tutor local do createuser --staff --superuser edx edx@example.com
# tutor local do importdemocourse
