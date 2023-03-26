# +------------+
# | Navigation |
# +------------+
setopt AUTO_CD              # If the command is a dirname perform cd
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

# +----------+
# | Settings |
# +----------+
setopt NOCLOBBER            # Don’t write over existing files with >, use >! instead
setopt NOBEEP               # No beep
setopt RM_STAR_WAIT         # wait ten seconds when `rm *' or `rm path/*'. can avoid by expanding the * in ZLE (with tab).
setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
