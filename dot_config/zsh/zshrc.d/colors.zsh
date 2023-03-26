# +--------+
# | Colors |
# +--------+
# There's a generator here: http://geoff.greer.fm/lscolors/
autoload colors && colors
source $ZDOTDIR/plugins/zcolors/zcolors.plugin.zsh
source $ZDOTDIR/.zcolors
eval "$(dircolors -b $ZDOTDIR/dircolors-solarized.256dark)"
