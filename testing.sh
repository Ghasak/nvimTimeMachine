#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

examined_font_array=("3270" "Agave" "Terminess" "Roboto" "OpenDyslexic" "Fira" "Ubuntu" "Noto" "Hack" "Fura")
echo "========================"

PATTERN="^[a-z]"
PATTERN_2="([^[:space:]]+[[:space:]]+[^[:space:]]+)(.*)"
Arr=()
ls $HOME/Library/Fonts/ | while IFS="" read -r installed_font; do
	for efont in "${examined_font_array[@]}"; do
		# check if the efont literal is existed at each line (line is a full font name) and check for lower cases using {$var,,}
		if [[ $installed_font =~ "$efont" ]] || [[ $installed_font =~ "${efont,,}" ]]; then
			#echo -e "Found ${YELLOW}$installed_font${NC}"
			# Append to ARRAY the installed_font
			# append string of installed_font to ARRAY that has so many elements
			echo -e "Found ${YELLOW}$installed_font${NC}"
			Arr=($(printf ${installed_font} | tr " " "\n"))

		fi
	done
done
echo "========================"
