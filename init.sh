#!/bin/bash
# A Simple bash script for getting servers up and running with k3s and zsh

echo "Updating Repo's"
sudo apt update -y
echo "Upgrading packages"
sudo apt upgrade -y

echo "Installing zsh"
sudo apt install zsh -y