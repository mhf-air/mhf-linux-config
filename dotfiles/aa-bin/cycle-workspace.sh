#!/usr/bin/env bash

# set -o xtrace
set -o errexit
set -o pipefail
readonly ARGS="$@"
readonly ARGS_COUNT="$#"
println() {
  printf "$@\n"
}
# ================================================================================

main() {
  readonly row=2
  readonly column=2
  
  readonly info=$(wmctrl -d | cut -d " " -f 3 | tr -d $'\n')
  readonly all=$(($row * $column))
  local curIndex
  for ((i=0; i<all; i++)); do
    if [[ ${info:$i:1} == "*" ]];then
      curIndex="$i"
      break
    fi
  done

  local x=$(($curIndex % $column))
  local y=$(($curIndex / $column))

  if [[ "$MODE" == "v" ]];then
    if [[ $y < $(($row - 1)) ]];then
      y=$(($y + 1))
    else
      y=0
    fi
  elif [[ "$MODE" = "h" ]];then
    if [[ $x < $(($column - 1)) ]];then
      x=$(($x + 1))
    else
      x=0
    fi
  else
    echo "error: only supports v and h"
    exit
  fi

  local newIndex=$(($y * $row + $x))
  wmctrl -s $newIndex
}

readonly MODE="$1"

main
