# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/jlcambero/.config/zsh/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/jlcambero/.config/zsh/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/jlcambero/.config/zsh/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/jlcambero/.config/zsh/fzf/shell/key-bindings.zsh"
