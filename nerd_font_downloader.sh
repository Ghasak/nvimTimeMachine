#!/usr/bin/env bash

TITLE="Compile and watch on system: $HOSTNAME"
RIGHT_NOW="$(date +"%x %r %Z")"
CREAT_TIME_STAMP="Updated on $RIGHT_NOW by $USER"
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
TIME_STAMP=$(date +%Y-%m-%d-%H%M%S)
NERD_FONT_VERSION="2.1.0"

SYSTEM_TYPE=""

function currentTime() {
	TIME_STAMP=$(date +%Y-%m-%d-%H%M%S)
	echo -ne "${RED}$(date +%Y-%m-%d-%H%M%S)${NC}\n"
	#echo "$(date +"%x %r %Z")"
}

function check_macOS_dependencies() {
	dependencies=("curl" "brew" "wget")
	for ((i = 0; i < ${#dependencies[@]}; i++)); do
		if [[ -z "$(command -v ${dependencies[$i]})" ]]; then
			echo -e "[${RED}\uf487${NC} ] ${RED}${dependencies[$i]}${NC} is not installed. Please install it first."
			exit 1
		else
			echo -e "[${RED}\uf487${NC} ] ${GREEN}${dependencies[$i]}${NC} is installed."

		fi
	done
}

function whichSystem() {
	if [ "$(uname)" == "Darwin" ]; then
		# Do something under Mac OS X platform
		echo -ne "[${BLUE}\uf179${NC} ] Running on ${YELLOW}macOSX${NC}\n"
		#currentTime
		SYSTEM_TYPE='macOSX'
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		# Do something under GNU/Linux platform
		SYSTEM_TYPE='Linux'
		echo -ne "[${BLUE}\uf306${NC}] Running on LinuX"
	fi
}

function exists_in_list() {
	LIST=$1
	DELIMITER=$2
	VALUE=$3
	LIST_WHITESPACES=$(echo $LIST | tr "$DELIMITER" " ")
	for x in $LIST_WHITESPACES; do
		if [ "$x" = "$VALUE" ]; then
			return 0
		fi
	done
	return 1
}

# ********************************************************
#             List of all installed fonts
# ********************************************************
function list_of_all_installed_font() {
	font_array=($(ls -1 /Library/Fonts/))
	for ((i = 0; i < ${#font_array[@]}; i++)); do
		echo -e "[${BLUE}\uf1d7${NC} ] ${font_array[$i]}"
	done
}

# ********************************************************
#                       Main
# ********************************************************
#list_nerd_fonts=("3270" "Agave" "Terminess" "Tinos" "Ubuntu" "RobotoMono" "OpenDyslexic" "Noto" "Arimo" "FiraCode" "Hack")
list_nerd_fonts=("3270" "Agave" "Terminess" "RobotoMono" "OpenDyslexic" "Noto" "Arimo" "FiraCode" "Hack")
exception_names=("3270" "Agave" "Terminess" "Roboto" "OpenDyslexic" "Noto" "Arimo" "Fura Code"  "Hack")
not_installed_fonts=() # Array to store not installed fonts
whichSystem
check_macOS_dependencies
font_array=$(ls $HOME/Library/Fonts/)
if [[ $SYSTEM_TYPE == "macOSX" ]]; then
	for ((i = 0; i < ${#list_nerd_fonts[@]}; i++)); do
		font_family="${list_nerd_fonts[$i]}"
		font_name="${list_nerd_fonts[$i]}-Regular.ttf"
		if [[ $font_family == "RobotoMono" ]]; then
			font_family="Roboto"
		fi
		# You can use tolower function in awk or IGNORECASE
		if [[ $(echo $font_array | awk 'BEGIN {IGNORECASE = 1}{for(i=1;i<=NF;i++) if($i=="'$font_family'") print $i}') ]] || [[ $(echo $font_array | awk 'BEGIN {IGNORECASE = 1}{for(i=1;i<=NF;i++) if($i=="'$exception_names[$i]'") print $i}') ]] ; then
			echo -e "[${GREEN}\uf031${NC} ] ${GREEN}${font_family}${NC} is installed."
		else
			echo -e "[${RED}\uf031${NC} ] ${RED}${font_family}${NC} is not installed. Please install it first."
			# install font
			not_installed_fonts+=($font_family)
		fi
	done
	if [[ ${#not_installed_fonts[@]} > 0 ]]; then
		source $HOME/.GScript/nvimTimeMachine/select_menu.sh
		choose_from_menu "Please make a choice:" selected_choice "${not_installed_fonts[@]}"
		read -p "$(echo -e "You have selected ${MAGENTA}$font_family${NC} font: Do you want to Download? (${MAGENTA}Y${NC}/${MAGENTA}N${NC}): ")" confirm
		echo -e "Download Homepage: ${BLUE}https://www.nerdfonts.com/font-downloads${NC}"
		echo -e "Download Directory: ${YELLOW}$HOME/Library/Fonts/${NC}"
		if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
			_spin="⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏ "
			charwidth=2
			cd "$HOME/Library/Fonts/" && curl -O -J -L "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERD_FONT_VERSION/$selected_choice.zip" && unzip -q $selected_choice.zip && rm $selected_choice.zip &
			pid=$!
			while kill -0 $pid 2>/dev/null; do
				tput civis # cursor invisible
				i=$(((i + $charwidth) % ${#_spin}))
				printf "${RED}%s${NC}" "${_spin:$i:$charwidth}"
				echo
				tput cuu1 # cursor up 1
				tput el
			done
			i=0
		else
			exit 0
		fi
	fi
fi
