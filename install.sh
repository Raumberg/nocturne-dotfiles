#!/bin/bash

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
