source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20 # Doc Recommended value is 20.
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,bold"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=249"

# Widget Mapping
# This plugin works by triggering custom behavior when certain zle widgets are invoked. You can add and remove widgets from these arrays to change the behavior of this plugin:
# ZSH_AUTOSUGGEST_CLEAR_WIDGETS: Widgets in this array will clear the suggestion when invoked.
# ZSH_AUTOSUGGEST_ACCEPT_WIDGETS: Widgets in this array will accept the suggestion when invoked.
# ZSH_AUTOSUGGEST_EXECUTE_WIDGETS: Widgets in this array will execute the suggestion when invoked.
# ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS: Widgets in this array will partially accept the suggestion when invoked.
# ZSH_AUTOSUGGEST_IGNORE_WIDGETS: Widgets in this array will not trigger any custom behavior.
# Widgets that modify the buffer and are not found in any of these arrays will fetch a new suggestion after they are invoked.
# Note: A widget shouldn't belong to more than one of the above arrays.

# Remove (el) from (arr)ay
# arr=("${(@)arr:#el}")

# ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
# cual me gusta mas
# alt-m
bindkey "^[m" autosuggest-execute
# # ctrl-space
# bindkey '^ ' autosuggest-execute
# alt-enter
bindkey '^[^M' autosuggest-execute

