#!/bin/bash

yellow="\033[33m"
red="\033[0;31m"
light_red="\033[91m"

echo -e "
${yellow}
          _ ._  _ , _ ._
        (_ ' ( \`  )_  .__)
      ( (  (    )   \`)  ) _)
     (__ (_   (_ . _) _) ,__)
           ~~\ ' . /~~
         ,::: ;   ; :::,
        ':::::::::::::::'
 ____________/_ __ \____________
|                               |
|       [Nocturne] .files       |
|_______________________________|
"

echo -e "${yellow}!!! ${red}WARNING${yellow} !!!"
echo -e "${light_red}This script will delete all your configuration files!"
echo -e "${light_red}Use it at your own risks."

if [ $# -ne 1 ] || [ "$1" != "-y" ];
    then
        echo -e "${yellow}Press a key to continue...\n"
        read key;
fi

set -e

installPackages() {
    while IFS= read -r package; do
        if [[ "$package" =~ ^#.* ]] || [[ -z "$package" ]]; then
            continue
        fi

        echo "Installing $package..."

        # Check if the package manager is paru (preferred)
        if command -v paru &> /dev/null; then
            sudo paru -Syu
            sudo paru -S "$package"

        # Check if the package manager is yay (default)
        elif command -v yay &> /dev/null; then
            sudo yay -Syu
            sudo yay -S "$package"

        else
            echo "[ERROR] No supported package manager found. Please install packages manually."
            exit 1
        fi

        echo "[OK] $package installed."
    done < "$1"
}

if [ -z "$1" ]; then
    echo "Usage: $0 <PACKAGES_FILE>"
    echo "ERROR: no PACKAGES file is provided"
    exit 1
fi

installPackages "$1"
