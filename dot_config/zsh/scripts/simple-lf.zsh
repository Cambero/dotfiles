#!/usr/bin/env zsh

# on directory
# left - right - enter 		- change directory

# on file
# left 				- change directory
# right - enter		- copy to clipboard

# Common
# alt-o 			- open with predefined app
# alt-r 			- open in finder
# alt-e 			- open in vscode
# alt-a 			- show hidden files
# alt-A 			- hide hidden files
# alt-t 			- show all files recursively
# alt-h 			- go to home
# alt-g 			- search with ripgrep
function select-option() {
	lsd | fzf \
		--ansi \
		--height 100% \
		--delimiter : \
		--cycle \
		--preview 'less {}' \
		--bind "left:become(
				cd .. && pwd
			)" \
		--bind "right:become(
				if [[ -d {} ]]; then
					cd {} && pwd
				else
					echo {}
				fi
			)" \
		--bind='alt-o:become(open {})' \
		--bind='alt-r:become(open -R {})' \
		--bind='alt-e:become(code {})' \
		--bind='alt-h:become(cd ~ && pwd)' \
		--bind='alt-a:reload(lsd -a)' \
		--bind='alt-A:reload(lsd)' \
		--bind='alt-t:reload(fd --color=always --hidden --exclude ".git" .)' \
		--bind='alt-g:reload(rg .)'
}

simple-lf() {
	while true
	do
	selection=$(select-option)

	# Determine what to do depending on the selection
	if [ -z $selection ]; then
		return 0
	elif [ -d $selection ]; then
		cd $selection
	elif [ -f $selection ]; then
		realpath $selection | pbcopy
		echo copied to clipboard: $(realpath $selection)
		return 0
	else
		echo else
		return 0
	fi
	done
}
