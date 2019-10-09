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
    if [ "$?" = 1 ]
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
}



ask_keymap
set_keymap