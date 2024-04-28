#!/bin/bash
#  ___           _        _ _   _   _           _       _             
# |_ _|_ __  ___| |_ __ _| | | | | | |_ __   __| | __ _| |_ ___  ___  
#  | || '_ \/ __| __/ _` | | | | | | | '_ \ / _` |/ _` | __/ _ \/ __| 
#  | || | | \__ \ || (_| | | | | |_| | |_) | (_| | (_| | ||  __/\__ \ 
# |___|_| |_|___/\__\__,_|_|_|  \___/| .__/ \__,_|\__,_|\__\___||___/ 
#                                    |_|                               
# ----------------------------------------------------- 
# Required: yay trizen timeshift btrfs-grub
# ----------------------------------------------------- 

sleep 1
clear
figlet "Updates"

_isInstalledYay() {
    package="$1";
    check="$(yay -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

if gum confirm "Initialize update?" ;then
    echo 
    echo ":: Update started."
elif [ $? -eq 130 ]; then
        exit 130
else
    echo
    echo ":: Update canceled."
    exit;
fi

if [[ $(_isInstalledYay "timeshift") == "0" ]] ;then
    if gum confirm "Use time machine?" ;then
        echo
        c=$(gum input --placeholder "Enter a comment for the machine...")
        sudo timeshift --create --comments "$c"
        sudo timeshift --list
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo ":: DONE. Cabin $c created!"
        echo
    elif [ $? -eq 130 ]; then
        echo ":: Machine canceled."
        exit 130
    else
        echo ":: Machine canceled."
    fi
    echo
fi

yay

notify-send "Packages installed."
echo 
echo ":: Update complete"
sleep 2
