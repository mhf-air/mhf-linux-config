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
  local spaceNum=2
  local width=1920
  local height=1080
  
  local curPos=$(wmctrl -d | awk '{print $6}')
  local posOne="0,0"
  local posTwo=$((($spaceNum - 1) * $width))",0"
  local posThree="0,"$((($spaceNum - 1) * $height))
  local posFour=$((($spaceNum - 1) * $width))","$((($spaceNum - 1) * $height))
  
  if [[ "$MODE" == "v" ]];then
    case "$curPos" in
      $posOne)
        curPos=$posThree
        ;;
      $posTwo)
        curPos=$posOne
        ;;
      $posThree)
        curPos=$posOne
        ;;
      $posFour)
        curPos=$posThree
        ;;
      *)
        nextHeight=$(($(echo $curPos | cut -d ',' -f 2) + $height))
        curPos="0,"$nextHeight
        ;;
    esac
  elif [[ "$MODE" = "h" ]];then
    case "$curPos" in
      $posOne)
        curPos=$posTwo
        ;;
      $posTwo)
        curPos=$posOne
        ;;
      $posThree)
        curPos=$posFour
        ;;
      $posFour)
        curPos=$posThree
        ;;
      *)
        nextWidth=$(($(echo $curPos | cut -d ',' -f 2) + $width))
        curPos=$nextWidth",0"
        ;;
    esac
  else
    echo "error: only supports v and h"
    exit
  fi
  echo $curPos
  
  wmctrl -o $curPos
}

readonly MODE="$1"

main
