#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

function choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true
    do
        # list all options (option list is zero-based)
        index=0
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            #then echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
            then echo -e "  ${YELLOW}\ufc32${NC} \e[48;5;226m$o${NC}" # mark & highlight the current option
            else echo "   $o "
            fi
            index=$(( $index + 1 ))
        done
        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( $cur + 1 ))
            [ "$cur" -ge $count ] && cur=$(( $count - 1 ))
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}


# ---------------- Usage ----------------
# selections=(
# "Selection A"
# "Selection B"
# "Selection C"
# )

# choose_from_menu "Please make a choice:" selected_choice "${selections[@]}"
# echo "Selected choice: $selected_choice"

#------------
# Reference:
#------------
# https://askubuntu.com/questions/1705/how-can-i-create-a-select-menu-in-a-shell-script
# https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu
# ASCII Colors
# https://askubuntu.com/questions/558280/changing-colour-of-text-and-background-of-terminal
