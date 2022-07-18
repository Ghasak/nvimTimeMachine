function spinner() {
	function cursorBack() {
	echo -en "\033[$1D"
}
echo -n "$SHELL $USER $HOME"
echo -ne "Checking system...\n"

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
