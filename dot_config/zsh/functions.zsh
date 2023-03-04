function takedir() {
  mkdir -p $@ && cd ${@:$#}
}

function takegit() {
  git clone $1
  cd $(basename ${1%%.git})
}

# palette with COLOR_CODES
palette() {
  local -a colors
  for i in {000..255}; do
      colors+=("%F{$i}$i%f")
  done
  print -cP $colors
}

# Usage: printc COLOR_CODE
printc() {
    local color="%F{$1}"
    echo -E ${(qqqq)${(%)color}}
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
