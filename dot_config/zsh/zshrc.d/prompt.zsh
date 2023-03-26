# +---------------+
# | Powerlevel10k |
# +---------------+
# if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
#   # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
#   if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#   fi

#   source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme

#   # To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
#   [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
# fi

eval "$(starship init zsh)"
