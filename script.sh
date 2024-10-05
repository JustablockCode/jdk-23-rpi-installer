#!/bin/bash

# Function to check if a command is available
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo "$1 is not installed. Installing $1..."
        sudo apt-get update
        sudo apt-get install -y $1
    else
        echo "$1 is already installed."
    fi
}

# Function to remove old JDK and Java installations
remove_old_jdk() {
    echo "Removing old JDK and Java if installed..."
    sudo apt-get remove --purge openjdk-* -y
    sudo apt-get remove --purge bellsoft-jdk* -y
    sudo apt-get autoremove -y
    echo "Old JDK and Java removed."
}

# Function to install JDK package
install_jdk() {
    echo "Installing BellSoft JDK..."
    sudo dpkg -i $1

    # Fix dependencies
    echo "Checking and installing dependencies..."
    sudo apt-get install -f -y
}

# Check for necessary dependencies
echo "Checking for required dependencies..."
check_dependency "wget"
check_dependency "dpkg"
check_dependency "apt-get"

# Ask the user if they want to uninstall old JDK and Java
read -p "Do you want to completely uninstall existing JDK and Java? (y/n): " uninstall_choice

if [[ $uninstall_choice == "y" || $uninstall_choice == "Y" ]]; then
    remove_old_jdk
else
    echo "Skipping JDK and Java uninstallation."
fi

# Ask the user if they want to install a new JDK package
read -p "Do you want to install a new JDK package? (y/n): " install_choice

if [[ $install_choice == "y" || $install_choice == "Y" ]]; then
    # Ask the user for the package choice
    echo "Select the package to install:"
    echo "1) Full Package"
    echo "2) Standard Package"
    echo "3) Lite Package"
    read -p "Enter your choice (1/2/3): " choice

    # Download and install the appropriate package based on user input
    case $choice in
        1)
            echo "You chose the Full Package."
            package_url="https://download.bell-sw.com/java/23+38/bellsoft-jdk23+38-linux-aarch64-full.deb"
            ;;
        2)
            echo "You chose the Standard Package."
            package_url="https://download.bell-sw.com/java/23+38/bellsoft-jdk23+38-linux-aarch64.deb"
            ;;
        3)
            echo "You chose the Lite Package."
            package_url="https://download.bell-sw.com/java/23+38/bellsoft-jdk23+38-linux-aarch64-lite.deb"
            ;;
        *)
            echo "Invalid choice, exiting."
            exit 1
            ;;
    esac

    # Download the selected package
    echo "Downloading the package..."
    wget $package_url -O bellsoft-jdk.deb

    # Install the downloaded package
    install_jdk "bellsoft-jdk.deb"

    # Cleanup
    echo "Cleaning up..."
    rm bellsoft-jdk.deb

    echo "Installation complete!"
else
    echo "Skipping JDK installation."
fi
