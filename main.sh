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

    # Prompt to delete .deb file
    while true; do
        read -p "Do you want to delete the downloaded .deb file after installation? (y/n): " delete_choice
        case $delete_choice in
            [Yy]* ) rm -f $1; echo ".deb file deleted."; break;;
            [Nn]* ) echo "Keeping the .deb file."; break;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Function to display the menu
show_menu() {
    clear
    echo "========================================="
    echo "      BellSoft JDK Installation Menu"
    echo "========================================="
    echo "1) Install JDK"
    echo "2) Uninstall JDK and Java"
    echo "3) Exit"
    echo "========================================="
    echo -n "Choose an option [1-3]: "
}

# Function to handle JDK installation
install_jdk_menu() {
    clear
    echo "Select the package to install:"
    echo "1) Full Package"
    echo "2) Standard Package"
    echo "3) Lite Package"
    echo -n "Enter your choice [1-3]: "
    read choice

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
            echo "Invalid choice."
            return
            ;;
    esac

    echo "Downloading the package..."
    wget $package_url -O bellsoft-jdk.deb
    install_jdk "bellsoft-jdk.deb"
    echo "Installation complete!"
}

# Check for necessary dependencies
echo "Checking for required dependencies..."
check_dependency "wget"
check_dependency "dpkg"
check_dependency "apt-get"

# Main program loop
while true; do
    show_menu
    read option

    case $option in
        1)
            install_jdk_menu
            ;;
        2)
            while true; do
                read -p "Are you sure you want to completely uninstall JDK and Java? (y/n): " uninstall_choice
                case $uninstall_choice in
                    [Yy]* ) remove_old_jdk; break;;
                    [Nn]* ) echo "Skipping uninstallation."; break;;
                    * ) echo "Please answer yes (y) or no (n).";;
                esac
            done
            ;;
        3)
            echo "Exiting the script."

            # Self-deletion prompt
            while true; do
                read -p "Do you want to delete this script (main.sh) after exiting? (y/n): " delete_script
                case $delete_script in
                    [Yy]* ) clear; echo "Deleting script..."; rm -- "$0"; exit 0;;
                    [Nn]* ) clear; echo "Keeping the script."; exit 0;;
                    * ) echo "Please answer yes (y) or no (n).";;
                esac
            done
            ;;
        *)
            echo "Invalid option. Please choose 1, 2, or 3."
            ;;
    esac
done
