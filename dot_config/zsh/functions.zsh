function takedir() {
  mkdir -p $@ && cd ${@:$#}
}

function takegit() {
  git clone $1
  cd $(basename ${1%%.git})
}

palette_fg() {
  local -a colors
  for i in {000..255}; do
      colors+=("%F{$i}$i%f")
  done
  print -cP $colors
}

palette_bg() {
  for i in {0..255}; do
    printf "\033[48;5;%dm\033[38;5;15m %03d " $i $i
    printf "\033[33;5;0m\033[38;5;%dm %03d " $i $i
    (( i+1 <= 16 ? (i+1) % 8 :  ((i+1)-16) % 6  )) || printf "\033[0m\n"
    (( i+1 <= 16 ? (i+1) % 16 : ((i+1)-16) % 36 )) || printf "\033[0m\n"
  done
}

palette() {
  for i in {0..255}; do
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
  done
}

# Usage: printc COLOR_CODE
printc() {
    local color="%F{$1}"
    echo -E ${(qqqq)${(%)color}}
}

function fvars(){
  env | cut -d= -f1 | fzf --preview 'eval print -rl \${}' --preview-window=wrap
}

## fzf path
function fpath() { fuzzy_path $PATH }
function ffpath() { fuzzy_path $FPATH }

function fuzzy_path() {
  echo $1 | tr ':' '\n' | fzf --height=100% --preview 'exa -F --group-directories-first --icons {}' --layout=reverse --info=inline --border=sharp
}

# zsh options
zsh_options() {
  printf '%s=%s\n' "${(@kv)options}" | fzf
}

# Quick look of file
function quick-look() {
  (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}


## Utils
files_by_extension() {
	 fd -Hi -tf --exclude '.git' | awk -F . '{print $NF}' | sort | uniq -c | awk '{print $1,$2}' | sort -n -r | head -n 10
}



# ----------------------------------------------------------
# print 42 ``-''
#   echo ${(l:42::-:)}
# or use ``$COLUMS''
#   echo ${(l:$COLUMNS::-:)}
# and now with colors (require _autoload colors ;colors_)
#   echo "$bg[red]$fg[black]${(l:42::-:)}"


# _Get ASCII value of a character_
#  $ char=N ; print $((#char))

# Lists every executable in PATH
# $ print -l ${^path}/*(-*N)

# n -- quickest note taker
n() { [[ $# == 0 ]] && tail ~/.n || echo "$(date +'%F %R'): $*" >>~/.n }



# Copy to clipboard?
# Use Ctrl-x,Ctrl-l to get the output of the last command
# Warning EXECUTE AGAIN the the previous command
# zmodload -i zsh/parameter
# insert-last-command-output() {
# LBUFFER+="$(eval $history[$((HISTCMD-1))])"
# }
# zle -N insert-last-command-output
# bindkey "^X^L" insert-last-command-output

