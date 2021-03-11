#!/bin/bash
# Linux Mint workstation initialization for the Durham Rescue Mission
# Written by Jonathan McMahel
# jonathan.mcmahel@durhamrescuemission.org

# Make sure current user is USERNAME
if [ $USER == USERNAME ]; then
  echo -e "\e[1;32mYou are signed in as $USER\e[0m"
else
  echo -e '\e[1;31mYou are not signed in as USERNAME\e[0m'
  echo -e '\e[1;31mPlease sign in as USERNAME and run the script again\e[0m'
  exit 0
fi

# Obtain credential for sudo commands
sudo -v

# Switch to local mirrors
echo -e '\e[1;32m\n\n\nSetting up local mirrors ...\n\n\n\e[0m'
sudo rm /etc/apt/sources.list.d/official-package-repositories.list
sudo touch /etc/apt/sources.list.d/official-package-repositories.list
echo 'deb http://mirror.cs.jmu.edu/pub/linuxmint/packages ulyssa main upstream import backport' | sudo tee -a /etc/apt/sources.list.d/official-package-repositories.list > /dev/null
echo '' | sudo tee -a /etc/apt/sources.list.d/official-package-repositories.list > /dev/null
echo 'deb http://mirror.cs.jmu.edu/pub/ubuntu focal main restricted universe multiverse' | sudo tee -a /etc/apt/sources.list.d/official-package-repositories.list > /dev/null
echo 'deb http://mirror.cs.jmu.edu/pub/ubuntu focal-updates main restricted universe multiverse' | sudo tee -a /etc/apt/sources.list.d/official-package-repositories.list > /dev/null
echo 'deb http://mirror.cs.jmu.edu/pub/ubuntu focal-backports main restricted universe multiverse' | sudo tee -a /etc/apt/sources.list.d/official-package-repositories.list > /dev/null
echo '' | sudo tee -a /etc/apt/sources.list.d/official-package-repositories.list > /dev/null
echo 'deb http://security.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse' | sudo tee -a /etc/apt/sources.list.d/official-package-repositories.list > /dev/null
echo 'deb http://archive.canonical.com/ubuntu/ focal partner' | sudo tee -a /etc/apt/sources.list.d/official-package-repositories.list > /dev/null

# Update apt cache
echo -e '\e[1;32m\n\n\nUpdating the APT cache ...\n\n\n\e[0m'
sudo apt-get update

# Upgrade software packages
echo -e '\e[1;32m\n\n\nUpgrading software packages ...\n\n\n\e[0m'
sudo apt-get -y upgrade

# Install language packs
echo -e '\e[1;32m\n\n\nInstalling language packs ...\n\n\n\e[0m'
sudo apt-get -y install hyphen-fi hyphen-ga hyphen-id

# Install SSH and VNC servers
echo -e '\e[1;32m\n\n\nInstalling VNC and SSH servers ...\n\n\n\e[0m'
sudo apt-get -y install x11vnc openssh-server

# Set up SSH keys and disable password login
echo -e '\e[1;32m\n\n\nConfiguring SSH access ...\n\n\n\e[0m'
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
echo "SSHKEY" >> ~/.ssh/authorized_keys
echo "SSHKEY" >> ~/.ssh/authorized_keys
sudo sed -i '58s/.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl stop sshd
sleep 3s
sudo systemctl start sshd

# Schedule automatic updates and nightly reboot
echo -e '\e[1;32m\n\n\nScheduling nightly reboot and updates ...\n\n\n\e[0m'
echo -e '\n\n' | sudo tee -a /etc/crontab > /dev/null
echo '# Reboot the system every day at 2:00 AM' | sudo tee -a /etc/crontab > /dev/null
echo '00 2 * * * root reboot -f' | sudo tee -a /etc/crontab > /dev/null
echo '' | sudo tee -a /etc/crontab > /dev/null
echo '# Check for updates and install available updates every day at 1:15 AM' | sudo tee -a /etc/crontab > /dev/null
echo '15 1 * * * root /usr/bin/apt update && /usr/bin/apt -y upgrade' | sudo tee -a /etc/crontab > /dev/null

# Add alias for 'lapt' command
echo -e '\e[1;32m\n\n\nCreating an alias for the lapt command ...\n\n\n\e[0m'
echo >> ~/.bashrc
echo '# Create an alias to easily show the top ten lines of output from '\''last'\'' and the two most recent logged APT events' >> ~/.bashrc
echo 'alias lapt='\''echo -e "$(last|head)\n\n$(tail -n 11 /var/log/apt/history.log)"'\''' >> ~/.bashrc

# Exiting the script
echo -e '\e[1;32m\n\n\nExiting the script ...\n\n\n\e[0m'

exit 0
