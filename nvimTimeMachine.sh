#!/usr/bin/env bash

##### Constants
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
function currentTime() {
	TIME_STAMP=$(date +%Y-%m-%d-%H%M%S)
	echo -ne "${RED}$(date +%Y-%m-%d-%H%M%S)${NC}\n"
	#echo "$(date +"%x %r %Z")"
}

SYSTEM_TYPE=""
function whichSystem() {
	if [ "$(uname)" == "Darwin" ]; then
		# Do something under Mac OS X platform
		echo -ne "[${BLUE}\uf179${NC} ] Running on ${YELLOW}macOSX${NC}\n"
		currentTime
		SYSTEM_TYPE='macOSX'
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		# Do something under GNU/Linux platform
		SYSTEM_TYPE='Linux'
		echo -ne "[${BLUE}\uf306${NC}] Running on LinuX"
	fi
}

function cursorBack() {
	echo -en "\033[$1D"
}
echo -n "$SHELL $USER $HOME"
echo -ne "Checking system...\n"

function spinner() {
	# ---------------------------------------------------------------
	#                      Spinner function
	# ---------------------------------------------------------------
	i=1
	spin='⣾⣽⣻⢿⡿⣟⣯⣷'
	_spin="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
	charwidth=1
	counter=0
	i=0
	tput civis # cursor invisible
	while [[ ${counter} -lt 10 ]]; do
		#printf "\b${sping:i++%${#sping}:1}"
		i=$(((i + $charwidth) % ${#_spin}))
		printf "${RED}%s${NC}" "${_spin:$i:$charwidth}"
		echo -ne "$(ls -l | wc -l) files\r"
		#cursorBack 1
		sleep 0.2
		echo
		tput cuu1 # cursor up 1
		tput el
		counter=$((counter + 1))
	done
}

# zip a file with progress bar <- You need gdu
# zip -qr - ./testingSpark | pv -s $(gdu -bs ./testingSpark | awk '{print $1}') > spark_testing.zip
# unzip with progress bar <- You need gdu
# unzip -o spark_testing.zip -d ./ | pv -l > /dev/null
# ----------------------------------
# command [opetions] args
# -- list_capsules
# -- create_capsule
# -- restore_capsule

function help() {
	cat <<EOF

OPTIONS:
--------

	(-cc)   | (--create_capsule)    : create a new capsules
	(-l)    | (--list_capsules)     : list all saved capsules
	(-rc)   | (--restore_capsule)   : restore a capsule
	(-[vV]) | (--version)           : current CLI version
	(-[hH]) | (--help)	            : show this help

Dependencies:
-------------
	- gdu       : brew install gdu
	- pv        : brew install pv
	- zip       : brew install zip

Notes:
------
	MacOSX: \$HOME is \$home for GNU Linux

EOF
}

function version() {
	cat <<EOF
Version: 0.0.1
EOF
}

function check_macOS_dependencies() {
	dependencies=("pv" "zip" "gdu")
	for ((i = 0; i < ${#dependencies[@]}; i++)); do
		if [[ -z "$(command -v ${dependencies[$i]})" ]]; then
			echo -e "[${RED}\uf487${NC} ] ${RED}${dependencies[$i]}${NC} is not installed. Please install it first."
			exit 1
		else
			echo -e "[${RED}\uf487${NC} ] ${GREEN}${dependencies[$i]}${NC} is installed."

		fi
	done
}

function mac_install_prerequisites() {
	echo -e "[${YELLOW}\uf046${NC} ] ${MAGENTA}Installing prerequisites ...${NC}"
	if [[ -d "$HOME/.nvim_capsules" ]]; then
		echo -e "[${GREEN}\ue5fe${NC} ] ${BLUE}$HOME/.nvim_capsules${NC} already exists."
	else
		mkdir -p $HOME/.nvim_capsules
		echo -e "[${GREEN}\uf413${NC} ] ${GREEN}$HOME/.nvim_capsules${NC} created."
	fi
}

function create_capsule() {
	file_time_stamp=$(date +%Y-%m-%d-%H%M%S)
	echo "save_file_name: $save_file_name"
	#_spin='⣾⣽⣻⢿⡿⣟⣯⣷'
	#_spin="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
	_spin="⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏ "
	charwidth=2
	# ------------ Create a capsule for nvim plugins and languages servers -------------
	zip -qr - ~/.local/share/nvim | pv -s $(gdu -bs ~/.local/share/nvim | awk '{print $1}') >~/.nvim_capsules/nvim_backup_$file_time_stamp.zip &
	pid=$!
	#while ps -p $pid >/dev/null; do
	while kill -0 $pid 2>/dev/null; do
		tput civis # cursor invisible
		i=$(((i + $charwidth) % ${#_spin}))
		printf "${RED}%s${NC}" "${_spin:$i:$charwidth}"
		echo
		tput cuu1 # cursor up 1
		tput el
	done
	i=0

	# ------------ Do same for the nvim at .config/nvim ------------
	zip -qr - ~/.config/nvim | pv -s $(gdu -bs ~/.config/nvim | awk '{print $1}') >~/.nvim_capsules/nvim_config_$file_time_stamp.zip &
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
}

function list_capsules() {
	echo -e "[${YELLOW}\uf046${NC} ] ${MAGENTA}Listing capsules ...${NC}"
	if [[ -d "$HOME/.nvim_capsules" ]]; then
		echo -e "[${GREEN}\ue5fe${NC} ] ${BLUE}$HOME/.nvim_capsules${NC} exists."
		capsules_list_containers=$(ls -l $HOME/.nvim_capsules | awk '{print $9}')
		eval "line1=($capsules_list_containers)"
		for ((i = 0; i < ${#line1[@]}; i++)); do
			echo -e "[${MAGENTA}\ue7b2${NC} ] ${GREEN}${line1[$i]}${NC}"
		done
	else
		echo -e "[${RED}\uf487${NC} ] ${RED}$HOME/.nvim_capsules${NC} does not exist."
	fi

}

function restore_capsule() {
	capsule_name=$1
	parsed_time_stamp=$(echo $capsule_name | awk -F "_" '{print $3}' | awk -F "." '{print $1}')
	_spin="⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏ "
	charwidth=2
	echo -e "[${YELLOW}\uf046${NC} ] ${MAGENTA}Restoring capsule ${capsule_name}...${NC}"
	if [[ -f "$HOME/.nvim_capsules/${capsule_name}" ]]; then
		if [[ -d "$HOME/.local/share/nvim" ]]; then
			mv $HOME/.local/share/nvim $HOME/.local/share/nvim_backup
		else
			echo -e "[${RED}\uf487${NC} ] ${RED}$HOME/.local/share/nvim${NC} does not exist."
		fi
		echo -e "[${GREEN}\uf413${NC} ] ${GREEN}$HOME/.nvim_capsules/${capsule_name}${NC} exists."
		# ------------ restore nvim plugins and languages servers -------------
		unzip -o $HOME/.nvim_capsules/${capsule_name} -d $HOME/.local/share/temp_$parsed_time_stamp | pv -l >/dev/null &
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
		# Excuting these should be come after the spinner is done.
		mv $HOME/.local/share/temp_$parsed_time_stamp/$HOME/.local/share/nvim $HOME/.local/share/
		rm -rf $HOME/.local/share/temp_$parsed_time_stamp

		echo "Do you want to remove backup files? (y/n)"
		read -p "$(echo -e "See help: Continue? (${MAGENTA}Y${NC}/${MAGENTA}N${NC}): ")" confirm
		if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
			rm -rf $HOME/.local/share/nvim_backup
		else
			continue
		fi
		# ------------ restore nvim at .config/nvim ------------
		# Notice here  in this if statement, we are checking if the .config/nvim folder exists.
		# should remove exit otherwise the following code will not be executed.
		if [[ -d "$HOME/.config/nvim" ]]; then
			mv $HOME/.config/nvim $HOME/.config/nvim_backup
		else
			echo -e "[${RED}\uf487${NC} ] ${RED}$HOME/.config/nvim${NC} does not exist."
		fi
		capsule_config_name=nvim_config_$parsed_time_stamp.zip
		unzip -o $HOME/.nvim_capsules/${capsule_config_name} -d $HOME/.config/temp_$parsed_time_stamp | pv -l >/dev/null &
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
		# Excuting these should be come after the spinner is done.
		mv $HOME/.config/temp_$parsed_time_stamp/$HOME/.config/nvim $HOME/.config/
		rm -rf $HOME/.config/temp_$parsed_time_stamp
		echo -e "[${GREEN}\uf413${NC} ] ${GREEN}$HOME/.config/nvim${NC} restored."
		echo -e "[${GREEN}\uf413${NC} ] ${GREEN}$HOME/.local/share/nvim${NC} restored."
		echo "Do you want to remove backup files? (y/n)"
		read -p "$(echo -e "See help: Continue? (${MAGENTA}Y${NC}/${MAGENTA}N${NC}): ")" confirm
		if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
			rm -rf $HOME/.config/nvim_backup
			exit 0
		else
			exit 0
		fi

	else

		echo -e "[${RED}\uf487${NC} ] ${RED}$HOME/.nvim_capsules/${capsule_name}${NC} does not exist."
	fi

exit 0


}

# --------- Main --------------

whichSystem
if [[ $SYSTEM_TYPE == 'macOSX' ]]; then
	mac_install_prerequisites
	check_macOS_dependencies

	while [[ "$1" != "" ]]; do
		case $1 in
		-cc | --create_capsule)
			echo -ne "[${BLUE}\ue7b2${NC} ] Creating a new capsule...\n"
			currentTime
			create_capsule
			exit 1
			;;
		-l | --list_capsules)
			currentTime
			list_capsules
			exit 1
			;;
		-rc | --restore_capsule)
			currentTime
			if [[ -z "$2" ]]; then
				echo -e "[${RED}\uf487${NC} ] ${RED}Please provide a capsule name.${NC}"
				exit 1
			else
				restore_capsule $2
				exit 1
			fi
			exit 1
			;;
		-[hH] | --help)
			help
			exit 1
			;;
		-[vV] | --version)
			version
			exit 1
			;;
		*)
			echo "Unknow flag or arg ... "
			read -p "$(echo -e "See help: Continue? (${YELLOW}Y${NC}/${YELLOW}N${NC}): ")" confirm
			if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
				help
				exit 1
			else
				exit 1
			fi
			;;

		esac
	done
fi
