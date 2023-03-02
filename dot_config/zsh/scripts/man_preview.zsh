#!/usr/bin/env zsh

# open Man command on Preview
function man-preview() {
  local location
  # Don't let Preview.app steal focus if the man page doesn't exist
  location=$(man -w "$@") && mandoc -Tpdf $location | open -f -a Preview
}
compdef _man man-preview
