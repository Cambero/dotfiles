# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

# bindkey => show all keybindings
# alt-x => mode Execute, within:
#     which-command         # show keybing for a command 
#     describe-key-briefly  # search command for a keybing
#
# show code for keystroke
# cat -v
# cat > /dev/null
# read
# ctrl-v and press the key combination

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use emacs key bindings
bindkey -e


# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

# [Alt-RightArrow] - move forward one word
bindkey -M emacs '^[^[[C' forward-word
bindkey -M viins '^[^[[C' forward-word
bindkey -M vicmd '^[^[[C' forward-word
# # [Alt-LeftArrow] - move backward one word
bindkey -M emacs '^[^[[D' backward-word
bindkey -M viins '^[^[[D' backward-word
bindkey -M vicmd '^[^[[D' backward-word

# [alt-m] Copy previous word, file rename magick
bindkey -M emacs "^[m" copy-prev-shell-word

# [ctrl-x ctrl-e] Edit the current command line in $VISUAL / $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# https://nathangrigg.com/2014/04/zsh-push-line-or-edit
# Remap to push-line-or-edit
# "^[q" push-line # alt-q 
# "^[Q" push-line # alt-Q
# "^Q" push-line  # ctrl-Q # dont work on iterm2
bindkey -M emacs "^[q" push-line-or-edit
bindkey -M emacs "^[Q" push-line-or-edit


# Defaults that I like
# alt-?	      # which-command
# ctrl-x a    # alias-expension

# alt-s || alt-S || alt-$   # spell-word
# ctrl-t || ctrl-T          # transpose-words
# ctrl-l || ctrl-alt-l      # clear-screen