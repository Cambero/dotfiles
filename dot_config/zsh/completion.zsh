  # ____ ___  __  __ ____  _     _____ _____ ___ ___  _   _ 
#  / ___/ _ \|  \/  |  _ \| |   | ____|_   _|_ _/ _ \| \ | |
# | |  | | | | |\/| | |_) | |   |  _|   | |  | | | | |  \| |
# | |__| |_| | |  | |  __/| |___| |___  | |  | | |_| | |\  |
#  \____\___/|_|  |_|_|   |_____|_____| |_| |___\___/|_| \_|
 #

#
# Origin
# https://github.com/Phantas0s/.dotfiles/blob/master/zsh/completion.zsh
#
# Good to know
# echo $_comps[rg]        # show function name
# echo $functions[_rg]    # show function
# whence -v $_comps[rg]   # show where it came from
# help whence             # for more info
#
# set -x    # enable trace for debug
# set +x    # disable  trace for debug

# +---------+
# | General |
# +---------+

# Load more completions
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)
fpath=($ZDOTDIR/completions $fpath)
fpath=($fpath "$(brew --prefix)/share/zsh/site-functions")

# Should be called before compinit
# zmodload zsh/complist
zmodload -i zsh/complist

# Use hjlk in menu selection (during completion)
# Doesn't work well with interactive mode
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xi' vi-insert                      # Insert
bindkey -M menuselect '^xh' accept-and-hold                # Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
bindkey -M menuselect '^xu' undo                           # Undo

# Pick item but stay in the menu
# bindkey -M menuselect "+" accept-and-menu-complete

autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files

# Only work with the Zsh function vman
# See $DOTFILES/zsh/scripts.zsh
compdef vman="man"

# +---------+
# | Options |
# +---------+

# setopt GLOB_COMPLETE      # Show autocompletion menu with globs
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

# +---------+
# | zstyles |
# +---------+

# fzf-tab
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' fzf-min-height 10
# zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:*' continuous-trigger 'right'
# zstyle ':fzf-tab:complete:cd:*' disabled-on any

# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -l --color=always $realpath'
# zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
# zstyle ':fzf-tab:complete:*:*' fzf-preview 'echo  desc: $desc\\n realpath: $realpath \\n words: $words \\n word: $word \\n group: $group'

# zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'


# Ztyle pattern
# :completion:<function>:<completer>:<command>:<argument>:<tag>
zstyle ':completion:*:processes' command "ps -wu$USER -opid,user,comm"

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true

zle -C alias-expension complete-word _generic
bindkey '^Xa' alias-expension
zstyle ':completion:alias-expension:*' completer _expand_alias

# Use cache for commands which use it

# Allow you to select in a menu
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification

# Dont work format
# TODO comented to disable groups
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}- %d (errors: %e) -%f'
zstyle ':completion:*:*:*:*:descriptions' format '-- %d --'
zstyle ':completion:*:*:*:*:messages' format ' %-- %d --'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# Colors for files and directory
zstyle '*' list-colors ${(s.:.)LS_COLORS}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# # Required for completion to be in good groups (named after the tags)
# TODO comented to disable groups
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Check
# Complete . and .. special directories
# zstyle ':completion:*' special-dirs true
