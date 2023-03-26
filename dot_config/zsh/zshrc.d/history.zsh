# +---------+
# | History |
# +---------+
# if export in zshenv or zprofile will be overwrited by /etc/zshrc
export HISTSIZE=50000            # Maximum events for internal history
export SAVEHIST=50000            # Maximum events in history file
# Dont save to history file this commands
export HISTORY_IGNORE="(l *|la *|ll *|lla *|lsd *|ls *|cd|cd *|pwd|exit)"
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
