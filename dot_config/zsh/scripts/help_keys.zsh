# https://git.grml.org/?p=grml-etc-core.git;a=blob_plain;f=etc/zsh/zshrc;hb=HEAD
#v1# set number of lines to display per page
HELP_LINES_PER_PAGE=20
#v1# set location of help-zle cache file
HELP_ZLE_CACHE_FILE=$XDG_CONFIG_HOME/.cache/zsh_help_zle_lines.zsh
# helper function for help-zle, actually generates the help text
function help_zle_parse_keybindings () {
    emulate -L zsh
    setopt extendedglob
    unsetopt ksharrays  #indexing starts at 1

    #v1# choose files that help-zle will parse for keybindings
    ((${+HELPZLE_KEYBINDING_FILES})) || HELPZLE_KEYBINDING_FILES=( /etc/zsh/zshrc $ZDOTDIR/.zshrc $ZDOTDIR/key-bindings.zsh $ZDOTDIR/completion.zsh )

    if [[ -r $HELP_ZLE_CACHE_FILE ]]; then
        local load_cache=0
        local f
        for f ($HELPZLE_KEYBINDING_FILES) [[ $f -nt $HELP_ZLE_CACHE_FILE ]] && load_cache=1
        [[ $load_cache -eq 0 ]] && . $HELP_ZLE_CACHE_FILE && return
    fi

    #fill with default keybindings, possibly to be overwritten in a file later
    #Note that due to zsh inconsistency on escaping assoc array keys, we encase the key in '' which we will remove later
    local -A help_zle_keybindings
    help_zle_keybindings['<Ctrl>@']="set MARK"
    help_zle_keybindings['<Ctrl>x<Ctrl>j']="vi-join lines"
    help_zle_keybindings['<Ctrl>x<Ctrl>b']="jump to matching brace"
    help_zle_keybindings['<Ctrl>x<Ctrl>u']="undo"
    help_zle_keybindings['<Ctrl>_']="undo"
    help_zle_keybindings['<Ctrl>x<Ctrl>f<c>']="find <c> in cmdline"
    help_zle_keybindings['<Ctrl>a']="goto beginning of line"
    help_zle_keybindings['<Ctrl>e']="goto end of line"
    help_zle_keybindings['<Ctrl>t']="transpose charaters"
    help_zle_keybindings['<Alt>t']="transpose words"
    help_zle_keybindings['<Alt>s']="spellcheck word"
    help_zle_keybindings['<Ctrl>k']="backward kill buffer"
    help_zle_keybindings['<Ctrl>u']="forward kill buffer"
    help_zle_keybindings['<Ctrl>y']="insert previously killed word/string"
    help_zle_keybindings["<Alt>'"]="quote line"
    help_zle_keybindings['<Alt>"']="quote from mark to cursor"
    help_zle_keybindings['<Alt><arg>']="repeat next cmd/char <arg> times (<Alt>-<Alt>1<Alt>0a -> -10 times 'a')"
    help_zle_keybindings['<Alt>u']="make next word Uppercase"
    help_zle_keybindings['<Alt>l']="make next word lowercase"
    help_zle_keybindings['<Ctrl>xG']="preview expansion under cursor"
    help_zle_keybindings['<Alt>q']="push current CL into background, freeing it. Restore on next CL"
    help_zle_keybindings['<Alt>.']="insert (and interate through) last word from prev CLs"
    help_zle_keybindings['<Alt>,']="complete word from newer history (consecutive hits)"
    help_zle_keybindings['<Alt>m']="repeat last typed word on current CL"
    help_zle_keybindings['<Ctrl>v']="insert next keypress symbol literally (e.g. for bindkey)"
    help_zle_keybindings['!!:n*<Tab>']="insert last n arguments of last command"
    help_zle_keybindings['!!:n-<Tab>']="insert arguments n..N-2 of last command (e.g. mv s s d)"
    help_zle_keybindings['<Alt>h']="show help/manpage for current command"

    #init global variables
    unset help_zle_lines help_zle_sln
    typeset -g -a help_zle_lines
    typeset -g help_zle_sln=1

    local k v f cline
    local lastkeybind_desc contents     #last description starting with #k# that we found
    local num_lines_elapsed=0            #number of lines between last description and keybinding
    #search config files in the order they a called (and thus the order in which they overwrite keybindings)
    for f in $HELPZLE_KEYBINDING_FILES; do
        [[ -r "$f" ]] || continue   #not readable ? skip it
        contents="$(<$f)"
        for cline in "${(f)contents}"; do
            #zsh pattern: matches lines like: #k# ..............
            if [[ "$cline" == (#s)[[:space:]]#\#k\#[[:space:]]##(#b)(*)[[:space:]]#(#e) ]]; then
                lastkeybind_desc="$match[*]"
                num_lines_elapsed=0
            #zsh pattern: matches lines that set a keybinding using bind2map, bindkey or compdef -k
            #             ignores lines that are commentend out
            #             grabs first in '' or "" enclosed string with length between 1 and 6 characters
            elif [[ "$cline" == [^#]#(bind2maps[[:space:]](*)-s|bindkey|compdef -k)[[:space:]](*)(#b)(\"((?)(#c1,6))\"|\'((?)(#c1,6))\')(#B)(*)  ]]; then
                #description previously found ? description not more than 2 lines away ? keybinding not empty ?
                if [[ -n $lastkeybind_desc && $num_lines_elapsed -lt 2 && -n $match[1] ]]; then
                    #substitute keybinding string with something readable
                    k=${${${${${${${match[1]/\\e\^h/<Alt><BS>}/\\e\^\?/<Alt><BS>}/\\e\[5~/<PageUp>}/\\e\[6~/<PageDown>}//(\\e|\^\[)/<Alt>}//\^/<Ctrl>}/3~/<Alt><Del>}
                    #put keybinding in assoc array, possibly overwriting defaults or stuff found in earlier files
                    #Note that we are extracting the keybinding-string including the quotes (see Note at beginning)
                    help_zle_keybindings[${k}]=$lastkeybind_desc
                fi
                lastkeybind_desc=""
            else
              ((num_lines_elapsed++))
            fi
        done
    done
    unset contents
    #calculate length of keybinding column
    local kstrlen=0
    for k (${(k)help_zle_keybindings[@]}) ((kstrlen < ${#k})) && kstrlen=${#k}
    #convert the assoc array into preformated lines, which we are able to sort
    for k v in ${(kv)help_zle_keybindings[@]}; do
        #pad keybinding-string to kstrlen chars and remove outermost characters (i.e. the quotes)
        help_zle_lines+=("${(r:kstrlen:)k[2,-2]}${v}")
    done
    #sort lines alphabetically
    help_zle_lines=("${(i)help_zle_lines[@]}")
    [[ -d ${HELP_ZLE_CACHE_FILE:h} ]] || mkdir -p "${HELP_ZLE_CACHE_FILE:h}"
    echo "help_zle_lines=(${(q)help_zle_lines[@]})" >| $HELP_ZLE_CACHE_FILE
    zcompile $HELP_ZLE_CACHE_FILE
}
typeset -g help_zle_sln
typeset -g -a help_zle_lines

# Provides (partially autogenerated) help on keybindings and the zsh line editor
function help-zle () {
    emulate -L zsh
    unsetopt ksharrays  #indexing starts at 1
    #help lines already generated ? no ? then do it
    [[ ${+functions[help_zle_parse_keybindings]} -eq 1 ]] && {help_zle_parse_keybindings && unfunction help_zle_parse_keybindings}
    #already displayed all lines ? go back to the start
    [[ $help_zle_sln -gt ${#help_zle_lines} ]] && help_zle_sln=1
    local sln=$help_zle_sln
    #note that help_zle_sln is a global var, meaning we remember the last page we viewed
    help_zle_sln=$((help_zle_sln + HELP_LINES_PER_PAGE))
    zle -M "${(F)help_zle_lines[sln,help_zle_sln-1]}"
}
zle -N help-zle
bindkey "^X^h" help-zle