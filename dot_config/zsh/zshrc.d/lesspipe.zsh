# Changed on lesspipe.sh to avoid -ps stdin not a terminal error-
# from: cmdtree=$(ps -T -oargs=)
# to:   cmdtree=$(ps -oargs=)
export LESSOPEN="|$HOMEBREW_PREFIX/bin/lesspipe.sh %s"
export LESSHISTFILE=- # no use history .lesshst
export LESS="--IGNORE-CASE --LONG-PROMPT --QUIET --chop-long-lines --RAW-CONTROL-CHARS --quit-if-one-screen --no-init --quit-at-eof"
