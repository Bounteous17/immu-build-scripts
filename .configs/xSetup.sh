#!/bin/bash

# colors
WHITE="$(tput setaf 7)"
WHITEB="$(tput bold ; tput setaf 7)"
BLUE="$(tput setaf 4)"
BLUEB="$(tput bold ; tput setaf 4)"
CYAN="$(tput setaf 6)"
CYANB="$(tput bold ; tput setaf 6)"
GREEN="$(tput setaf 2)"
GREENB="$(tput bold ; tput setaf 2)"
RED="$(tput setaf 1)"
REDB="$(tput bold; tput setaf 1)"
YELLOW="$(tput setaf 3)"
YELLOWB="$(tput bold ; tput setaf 3)"
BLINK="$(tput blink)"
NC="$(tput sgr0)"

KEYMAP_INPUT="us"
SPOOF_MAC=0
# return codes
SUCCESS=0
FAILURE=1

# print formatted output
wprintf()
{
    fmt="${1}"
    
    shift
    printf "%s$fmt%s" "$WHITE" "$@" "$NC"
    
    return $SUCCESS
}

# print error and exit
err()
{
    printf "%s[-] ERROR: %s%s\n" "$RED" "$@" "$NC"
    
    exit $FAILURE
    
    return $SUCCESS
}

continue_alert() {
    echo -e
	read -p "Press enter to continue script"
    clear
}

contains() {
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && return 0 || return 1
}

ask_keymap() {
    wprintf '[+] Available keymap options:'
    printf "\n
1. Set a keymap
2. List available keymaps\n\n"
    wprintf '[?] Make a choice: '
    read keymap_opt
    contains "1 2" "$keymap_opt"
    if [ "$?" = "1" ]
    then
        err "Unknow option $keymap_opt"
    elif [ "$keymap_opt" = "2" ]
    then
        localectl list-x11-keymap-layouts
        echo
    fi
}

set_keymap() {
    printf "\nInsert keymap layout [us]: "
    read KEYMAP_INPUT
    setxkbmap $KEYMAP_INPUT
	clear
}

passwd_immu() {
	printf "\nUser: immu\nPassword: immu\n"
	sudo passwd immu
    continue_alert
}

set_time() {
    printf "\nManually set system clock (yyyy-MM-dd hh:mm:ss): "
	read _time
    sudo timedatectl set-time "${_time}"
    continue_alert
}

ask_macspoof() {
    wprintf '[+] MAC address changer:'
    printf "\n
1. Skip spoofing
2. Spoof MAC address\n\n"
    wprintf '[?] Make a choice: '
    read -r spoof_opt
    contains "1 2" "$spoof_opt"
    if [ "$?" = "1" ]
    then
        err "Unknow option $spoof_opt"
    elif [ "$spoof_opt" = "2" ]
    then
        SPOOF_MAC=1
    fi
}

spoof_mac() {
	if [ "$SPOOF_MAC" = "1" ] 
	then
		printf "\nInsert network interface name: "
		read _interface
		sudo macchanger -r $_interface
	fi
	echo -e
	read -p "Press enter to exit script"
}

ask_keymap
set_keymap
passwd_immu
set_time
ask_macspoof
spoof_mac
