#!/bin/bash

# Define the URL for the main script (renamed to main.sh)
SCRIPT_URL="https://raw.githubusercontent.com/JustablockCode/jdk-23-rpi-installer/main/main.sh"
SCRIPT_NAME="main.sh"

# Download the main script
echo "Downloading the main JDK installation script..."
wget -O $SCRIPT_NAME $SCRIPT_URL

# Make the script executable
echo "Making the script executable..."
chmod +x $SCRIPT_NAME

# Run the script
echo "Running the JDK installation script..."
sudo ./$SCRIPT_NAME
