#!/usr/bin/env zsh

# open Man command on Preview
function man-preview() {
  local location
  # Don't let Preview.app steal focus if the man page doesn't exist
  location=$(man -w "$@") && mandoc -Tpdf $location | open -f -a Preview
}
compdef _man man-preview



# WIP
# Search on man pages, cheat, tldr
fzf-man-widget() {
  batman="echo {} | sed -e 's/(.*//' | xargs man | col -bx | bat --language=man --plain --color always --theme=\"Monokai Extended\""
   man -k . | sort | uniq \
   | awk -v cyan=$(tput setaf 6) -v blue=$(tput setaf 4) -v res=$(tput sgr0) -v bld=$(tput bold) '{ $1=cyan bld $1; $2=res blue;} 1' \
   | fzf  \
      -q "$1" \
      --ansi \
      --tiebreak=begin \
      --prompt=' Man > '  \
      --preview-window '50%,rounded,<50(up,85%,border-bottom)' \
      --preview "${batman}" \
      --bind "enter:become(${batman})" \
      --bind "alt-c:+change-preview(echo {} | sed -e 's/(.*//' | xargs cheat)+change-prompt(ﯽ Cheat > )" \
      --bind "alt-C:+change-preview(cheat {q} -c)+change-prompt(ﯽ CheatQ > )" \
      --bind "alt-m:+change-preview(${batman})+change-prompt( Man > )" \
      --bind "alt-t:+change-preview(echo {} | sed -e 's/(.*//' | xargs tldr)+change-prompt(ﳁ TLDR > )"
  zle reset-prompt
}
# bindkey '^h' fzf-man-widget
# zle -N fzf-man-widget
#--bind "enter:execute(echo {} | sed -e 's/(.*//' | xargs man)"

