#!/usr/bin/env bash
# A Simple bash script for getting servers up and running with k3s and zsh

CURL='/usr/bin/curl'

#Set Colors
bold_green='\033[1;32m'

#Set Hostname
box_hostname=$(hostnamectl | grep "Static hostname:" | sed -e 's/^\s*//' -e '/^$/d')
echo -e "${bold_green}Your Current $box_hostname"
echo -e "${bold_green}Do you wish to change your hostname? (Y/n)"
read hostname_response

if [[ $hostname_response == "Y" || $hostname_response == "y" ]]; then
    echo -e "${bold_green}What would you like the hostname to be?"
    read set_hostname
    sudo hostnamectl set-hostname $set_hostname
    echo -e "${bold_green}Your hostname has been set to $set_hostname"
elif [[ $hostname_response == "N" || $hostname_response == "n" ]]; then
    echo -e "${bold_green}Okay, Skipping hostname setup"
fi
#Update Repos
echo -e "${bold_green}Updating Repo's..."; sudo apt update -y > /dev/null
echo -e "${bold_green}Upgrading packages...."; sudo apt upgrade -y > /dev/null

#Installing VIM
VIM_PKG="vim"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $VIM_PKG|grep "install ok installed")
echo Checking for $VIM_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
    echo "No $VIM_PKG. Setting up $REQUIRED_PKG."
    echo -e "${bold_green}Installing $VIM_PKG"; sudo apt-get --yes install $VIM_PKG > /dev/null
fi
#Install ZSH
echo -e "${bold_green}Install ZSH? (Y/n)"
read zsh_response
if [[ $zsh_response == "Y" || $zsh_response == "y" ]]; then

    REQUIRED_PKG="zsh"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
    echo Checking for $REQUIRED_PKG: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
        echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
        echo -e "${bold_green}Installing $REQUIRED_PKG"; sudo apt-get --yes install $REQUIRED_PKG > /dev/null
    fi
elif [[ $zsh_response == "N" || $zsh_response == "n" ]]; then
    echo -e "${bold_green}Skipping ZSH Install"
else
echo -e "${bold_green}You did not enter a correct response"
fi

echo -e "${bold_green} Install OhMyZSH? (Y/n)"
read omz_response

if [[ $omz_response == "Y" || $omz_response == "y" ]]; then
    echo -e "${bold_green}Installing OhMyZSH"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${bold_green}Overwrite default .zshrc file with custom? (Y/n)"
    read zshrc_response
    if [[ $zshrc_response == "Y" || $zshrc_response == "y" ]]; then
        echo -e "${bold_green}Over Writing Default .ZSHRC File"
        $CURL ~/.zshrc https://raw.githubusercontent.com/MujiSayed/init_scripts/main/.zshrc
    elif [[ $zshrc_response == "N" || $zshrc_response == "n" ]]; then
        echo -e "${bold_green}Skipping .bashrc overwrite"
    fi
elif [[ $omz_response == "N" || $omz_response == "n" ]]; then
    echo -e "${bold_green}Skipping OhMyZSH Install"
else
echo -e "${bold_green} You did not choose a correct response"
fi

echo -e "${bold_green}Do you Wish to install Rancher K3S Kubernetes? (Y/n)"
read k3s_response

if [[ $k3s_response == "Y" || $k3s_response == "y" ]]; then
    
    echo -e "${bold_green}Is this the master node or a worker node? (Master/Worker)"
    read k3s_job
    if [[ $k3s_job = "Master" || $k3s_job == "master" ]]; then
    
        $CURL -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC=" --no-deploy servicelb --no-deploy traefik" sh -
    elif [[ $k3s_job == "Worker" || $k3s_job == "worker" ]]; then
    
        echo -e "${bold_green}Please enter the Master Node IP Address (ex. 192.168.35.62)"
        read K3S_URL
        echo -e "${bold_green}Please enter the Master Server Node Token (sudo cat /var/lib/rancher/k3s/server/node-token)"
        read K3S_TOKEN
        $CURL -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_URL="https://$K3S_URL:6443" K3S_TOKEN=$K3S_TOKEN sh -
    else 
    echo -e "${bold_green}You did not enter a correct response"
    fi
elif [[ $k3s_response == "N" || $k3s_response == "n" ]]; then
    echo -e "${bold_green}K3S install has been skipped"
echo -e "${bold_green}Line 50"
else 
echo -e "${bold_green}You did not enter a correct response"
fi