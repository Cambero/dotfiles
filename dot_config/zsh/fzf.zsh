source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" # 2> /dev/null

source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

# source $DOTFILES/zsh/scripts_fzf.zsh # fzf Scripts

# Used with FZF_COMPLETION_DIR_COMMANDS **
# FZF_CTRL_T_COMMAND
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# User by other commands **
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}


_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fd -td -H --max-depth=3 | fzf --preview 'tree -C {}' "$@";;
    tree)         find . -type d | fzf --preview 'tree -C {}' "$@";;
    # ls)           fzf --preview 'echo {}' "$@" ;;
    # git)          echo "uno dos" | tr ' ' '\n' | fzf "$@";;
    ll)          echo "uno dos" | tr ' ' '\n' | fzf "$@";;
    *)            fzf "$@" ;;
  esac
}

# export FZF_DEFAULT_OPTS="--bind 'change:first'"
# FZF_DEFAULT_COMMAND
# export FZF_COMPLETION_OPTS='--border --info=inline'

# export FZF_CTRL_T_OPTS="--bind 'alt-e:become(code -g {})'"

#
# Clever hack: set up double <Tab> instead of $FZF_COMPLETION_TRIGGER for default fzf completion
# NOTE: this needs fzf-tab to load before .zshrc.d/fzf, read below
#

# Another reminder for myself how this all works.
#
# Both fzf-tab and fzf/completion.zsh (hereinafter fzf.zsh) bind their widgets
# to ^I (Tab) and wrap the previously bound widget.
#
# fzf-tab manual advises the user to load fzf-tab last (specifically, after
# fzf.zsh) such that fzf-tab's widget (fzf-tab-complete) is called first and
# wraps the fzf.zsh's widget (fzf-complete).
#
# However, due to my double <Tab> hack I would prefer if the order was reversed,
# such that fzf.zsh's widget is called first and wraps the fzf-tab's widget
# (fzf-tab-complete).
#
# The reason for this is that if I use a double <Tab> and fzf-complete fails to
# come up with a completion, it will call the next wrapped widget, which has to
# be fzf-tab-complete so that I still get some sort of fzf-powered completion
# instead of expand-or-complete (the default one).
# (Also see the comment below.)

fzf-completion-notrigger() {
	# disable trigger just this once
	local FZF_COMPLETION_TRIGGER=""
	# if fzf-completion can't come up with something, call fzf-tab-complete
	# instead of the default completion widget (expand-or-complete).
	#
	# FIXME: triggers an infinite recursion on an empty prompt
	#        if this worked, the above ordering dance would not be needed
	# _zsh_autosuggest_highlight_reset:3: maximum nested function level reached; increase FUNCNEST?
	#
	#local fzf_default_completion='fzf-tab-complete'
	fzf-completion "$@"
}
zle -N fzf-completion-notrigger

# Set an aggressive $KEYTIMEOUT to make usage of single <Tab> less miserable
KEYTIMEOUT=20
# Bind double <Tab>
bindkey -M emacs '\t\t' fzf-completion-notrigger
# Bind Ctrl-Space in case I am unable to use double <Tab> due to a combination
# of the aggressive $KEYTIMEOUT on a slow link.
# bindkey -M emacs '^ ' fzf-completion-notrigger
