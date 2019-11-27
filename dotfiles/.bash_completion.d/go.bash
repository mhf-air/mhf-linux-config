#!/usr/bin/env bash

_go() {
  if [[ "${#COMP_WORDS[@]}" != "2" ]]; then
    return
  fi

  COMPREPLY=($(compgen -W "build clean doc env bug" "${COMP_WORDS[1]}"))
}

complete -F _go go
