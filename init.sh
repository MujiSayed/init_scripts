#!/bin/bash
# A Simple bash script for getting servers up and running with k3s and zsh

CURL='/usr/bin/curl'
ZSHRC='https://raw.githubusercontent.com/MujiSayed/init_scripts/main/.zshrc'
echo "Updating Repo's"
sudo apt update -y
echo "Upgrading packages"
sudo apt upgrade -y

echo "Installing zsh"
sudo apt install zsh -y


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"