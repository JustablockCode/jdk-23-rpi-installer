#!/bin/bash

check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo "$1 is not installed. Installing $1..."
        sudo apt-get update
        sudo apt-get install -y $1
    else
        echo "$1 is already installed."
    fi
}

remove_old_jdk() {
    echo "Removing old JDK and Java if installed..."
    sudo apt-get remove --purge openjdk-* -y
    sudo apt-get remove --purge bellsoft-jdk* -y
    sudo apt-get autoremove -y
    echo "Old JDK and Java removed."
}

install_jdk() {
    echo "Installing BellSoft JDK..."
    sudo dpkg -i $1

    echo "Checking and installing dependencies..."
    sudo apt-get install -f -y
}

show_menu() {
    clear
    echo "========================================="
    echo "   BellSoft JDK 23 Installation Menu"
    echo "========================================="
    echo "1) Install JDK 23"
    echo "2) Uninstall all JDK and Java"
    echo "3) Exit"
    echo "========================================="
    echo -n "Choose an option [1-3]: "
}

install_jdk_menu() {
    clear 
    echo "Select the package to install:"
    echo "1) Full Package(280.69Mb)"
    echo "2) Standard Package(190.02Mb)"
    echo "3) Lite Package(72.08Mb)"
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

    # Cleanup
    echo "Cleaning up..."
    rm bellsoft-jdk.deb

    echo "Installation complete!"
}

echo "Checking for required dependencies..."
check_dependency "wget"
check_dependency "dpkg"
check_dependency "apt-get"

while true; do
    show_menu
    read option
    echo "Thank you for using the JDK 23 installer by justablock:)"

    case $option in
        1)
            install_jdk_menu
            ;;
        2)
            while true; do
                read -p "Are you sure you want to uninstall JDK and Java? (y/n) completely: " uninstall_choice
                case $uninstall_choice in
                    [Yy]* ) remove_old_jdk; break;;
                    [Nn]* ) echo "Skipping uninstallation."; break;;
                    * ) echo "Please answer yes (y) or no (n).";;
                esac
            done
            ;;
        3)
            echo "Exiting the script."
            clear
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose 1, 2, or 3."
            ;;
    esac
done
