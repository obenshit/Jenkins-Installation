#!/bin/bash

# Check if the script is running with sudo privileges
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}ERROR: This script must be run as root or with sudo.${NC}"
    exit 1
fi

# Set colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'  # No Color

echo -e "${BLUE}#####################################"
echo -e "${BLUE}#       Install Jenkins on Linux      #"
echo -e "${BLUE}#           by Ori Ben Shitrit        #"
echo -e "${BLUE}#                                     #"
echo -e "${BLUE}#####################################${NC}"
echo -e "${YELLOW}Starting the installation process.${NC}"

echo -e "\n${GREEN}Updating the system.${NC}"
sudo yum update -y
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to update the system.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Adding the Jenkins repo${NC}"
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to add the Jenkins repo.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Importing Jenkins-CI key file.${NC}"
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to import Jenkins key file.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Upgrading the system${NC}"
sudo yum upgrade -y
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to upgrade the system.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Installing Java on Amazon Linux 2023${NC}"
sudo dnf install java-17-amazon-corretto -y
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to install Java.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Installing Jenkins${NC}"
sudo yum install jenkins -y
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to install Jenkins.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Enabling Jenkins service to start at boot${NC}"
sudo systemctl enable jenkins
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to enable Jenkins service.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Starting Jenkins as a service${NC}"
sudo systemctl start jenkins
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to start Jenkins service.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Checking the status of Jenkins service${NC}"
sudo systemctl status jenkins
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Jenkins service is not running.${NC}"
    exit 1
fi

echo -e "\n${YELLOW}#####################################"
echo -e "${YELLOW}#   Get the Admin password         #"
echo -e "${YELLOW}#####################################${NC}"

echo -e "${BLUE}Fetching the Jenkins admin password${NC}"
echo -e "${RED}Jenkins Admin Password: ${NC}"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to fetch Jenkins admin password.${NC}"
    exit 1
fi

echo -e "\n${YELLOW}#####################################"
echo -e "${YELLOW}#   Installation Complete!         #"
echo -e "${YELLOW}#####################################${NC}"
