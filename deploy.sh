# Rewritten deployment script from Alexey Kutepov (TSoding)
# Credits to Mr.Zozin (https://github.com/rexim/dotfiles/blob/master/deploy.sh)

#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

symlinkFile() {
    filename="$SCRIPT_DIR/$1"
    destination="$HOME/$2/$1"

    mkdir -p $(dirname "$destination")

    if [ -L "$destination" ]; then
        echo "[WARNING] $filename already symlinked"
        return
    fi

    if [ -e "$destination" ]; then
        echo "[ERROR] $destination exists but it's not a symlink. Please fix that manually"
        exit 1
    fi

    ln -s "$filename" "$destination"
    echo "[OK] $filename -> $destination"
}


deployManifest() {
    while IFS= read -r row; do
        if [[ "$row" =~ ^#.* ]]; then
            continue
        fi

        if [[ "$row" =~ (.+)->(.+) ]]; then
            filename="${BASH_REMATCH[1]}"
            destination="${BASH_REMATCH[2]}"

            symlinkFile "$filename" "$destination"
        else
            echo "[WARNING] Invalid line format: $row. Skipping..."
        fi
    done < "$SCRIPT_DIR/$1"
}


if [ -z "$@" ]; then
    echo "Usage: $0 <MANIFEST>"
    echo "ERROR: no MANIFEST file is provided"
    exit 1
fi

deployManifest $1
