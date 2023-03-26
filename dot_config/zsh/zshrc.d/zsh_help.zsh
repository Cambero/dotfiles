# +----------+
# | Zsh Help |
# +----------+
# Use zsh help instead man
# bindkeys: alt-h  &  alt-H
unalias run-help 2>/dev/null       # don't display err if already done
autoload -Uz run-help              # load the function
