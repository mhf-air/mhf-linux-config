shopt -s expand_aliases

# some grep aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some ls aliases
alias ls='ls --color=auto'
alias ll='ls -AlFsh'
alias la='ls -A'
alias l='ls -CF'

# misc
alias cp='cp -v'
alias mv='mv -v'
alias update='sudo apt update && sudo apt upgrade && sudo apt autoremove'
newfile (){
  path=$1
  dir=`dirname $path`
  file=`basename $path`
  mkdir -p $dir
  touch $path
}
c (){
  cd "$@"
  l
}
alias ..='c ..'
alias ...='c ../..'

# tmux start cmd
alias tm='tmux \
new -c ~/js/src/vue -n server-running -s server-running \; \
select-pane -t 0 \; \
new -c ~/js/src -n server -s default\; \
new-window -c ~/js/src/vue -n js -t default\; \
select-pane -t 0 \; \
new-window -c ~/go/src/wiki -n go -t default\; \
select-pane -t 0 \; \
new-window -c ~/go/src/nice -n nice -t default\; \
select-pane -t 0 \; \
select-window -t default:0 \; \
'
# new-window -c ~/android/kotlin/wiki -n kotlin -t default\; \

# split-window -vc ~/go/src/wiki -p 15 -t default \; \
# split-window -hc ~/go/src/wiki -p 50 -t default \; \
alias q-tmux="tmux kill-server"

alias sbcl='sbcl --noinform'
alias make='make -s'
alias gcc='gcc -std=c99'
alias g++='g++ -std=c++11'
# alias redis='~/software/redis-3.2.0/src/redis-cli'
alias amamam='xmodmap .xmodmaprc'

#some git basic aliases
alias ga='git add'
alias gb='git branch'
alias gc='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --graph \
--pretty=format:"%C(red)%h %Creset%C(yellow)[%C(bold blue)%cn%Creset%C(yellow),%C(green)%cd%Creset%C(yellow)] %C(cyan)%s" \
--date=short
'
alias gm='git merge --no-ff --squash'
alias gs='git status --ignore-submodules'
alias gg='git add . && git commit -m "s:"'

alias m1='mongo -u mhf -p 123 --authenticationDatabase "admin"'
alias edit-remote-file='sshfs -o idmap=user root@192.168.1.9:/etc /home/mhf/go/src/wiki/remote-server'

#common typos
alias suod='sudo'
alias eixt='exit'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#================================== vim ===================================
v(){
  local session window pane servername str vimcmd

  if [[ -n "$(ps -e | grep tmux)" ]]; then
    session=$(tmux list-sessions | grep attached | cut -d : -f 1)
    window=$(tmux list-windows | grep active | cut -d : -f 1)
    pane=$(tmux list-panes | grep active | cut -d : -f 1)
    servername=$(echo $session$window$pane | tr 'a-z' 'A-Z')
  else
    servername=$(echo "not-in-tmux" | tr 'a-z' 'A-Z')
  fi

  str=$(vim --serverlist | grep $servername)
  if [[ "$str" = "$servername" ]]; then
    if [ -n "$1" ]; then
      #now only support open one file, e.g. v .bashrc
      vimcmd=":cd $PWD<cr>:tabnew<cr>:e $1<cr>"
    else
      vimcmd=":cd $PWD<cr>"
    fi

    vim --servername $servername --remote-send "$vimcmd"
    fg
  else
    vim --servername $servername
  fi
}

#============================== git workflow ==============================
git-new-feature(){
  if ! Git-existed ;then
    echo -e "${red}git repository doesn't exist${nocolor}"
    return
  fi

  if [[ "$#" < 1 ]];then
    echo -e "${red}error: You need to provide a feature name${nocolor}"
    return
  fi

  echo -e "${brown}goal: add a new feature branch *$1*......\n${nocolor}"
  git-fix-dev
  echo -en "${cyan}        " && git checkout -b $1
  echo -e "${green}step: add a *$1* branch in remote...${lightgray}"
  git push origin $1

  echo -e "${brown}\ndone.${nocolor}"
}

#fix a feature branch
g(){
  if ! Git-existed ;then
    echo -e "${red}git repository doesn't exist${nocolor}"
    return
  fi

  if [[ "$#" < 1 ]];then
    Git-list-fix-branches
    return
  fi

  if [[ "$1" == "dev" ]];then
    echo -e "you should use: git-fix-dev${nocolor}"
    return
  elif Git-is-a-feature-branch $1 ;then
    echo -e "${brown}goal: fix *$1* branch......\n${nocolor}"

    if [[ -n "$(git status --porcelain)" ]];then
      echo -e "error: the current branch is not clean${nocolor}"
      return
    fi
    echo -en "${cyan}        " && git checkout $1

    echo -e "${green}step: pull from origin *$1*...${lightgray}"
    git pull origin $1
    if [[ -n "$(git status --porcelain)" ]];then
      echo -e "error: pull merge conflict${nocolor}"
      return
    fi

    echo -e "${brown}\ndone.${nocolor}"
  else
    Git-list-fix-branches
    return
  fi
}

g-test(){
  if ! Git-existed ;then
    echo -e "${red}git repository doesn't exist${nocolor}"
    return
  fi

  if [[ "$#" < 1 ]];then
    Git-list-fix-branches
    return
  fi

  if [[ "$1" == "dev" ]];then
    echo -e "you should use: git-fix-dev-push${nocolor}"
    return
  elif Git-is-a-feature-branch $1 ;then
    echo -e "${brown}goal: merge *$1* to *test*......\n${nocolor}"
    echo -en "${cyan}        " && git checkout $1
    if ! Git-pull-feature $1 ;then
      return
    fi
    if ! Git-merge-branch-and-push-test $1 ;then
      return
    fi

    echo -e "${brown}\ndone.${nocolor}"
  else
    Git-list-fix-branches
    return
  fi
}

g-push(){
  if ! Git-existed ;then
    echo -e "${red}git repository doesn't exist${nocolor}"
    return
  fi

  if [[ "$#" < 1 ]];then
    Git-list-fix-branches
    return
  fi

  if [[ "$1" == "dev" ]];then
    echo -e "you should use: git-fix-dev-push${nocolor}"
    return
  elif Git-is-a-feature-branch $1 ;then
    echo -e "${brown}goal: push *$1* to origin and merge *$1* to *test*......\n${nocolor}"
    echo -en "${cyan}        " && git checkout $1
    if ! Git-push-feature $1 ;then
      return
    fi
    if ! Git-merge-branch-and-push-test $1 ;then
      return
    fi

    echo -e "${brown}\ndone.${nocolor}"
  else
    Git-list-fix-branches
    return
  fi
}

#fix dev branch
git-fix-dev(){
  if ! Git-existed ;then
    echo -e "${red}git repository doesn't exist${nocolor}"
    return
  fi

  echo -e "${brown}goal: fix *dev* branch......\n${nocolor}"

  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: the current branch is not clean${nocolor}"
    return
  fi
  echo -en "${cyan}        " && git checkout dev

  echo -e "${green}step: pull from origin *release*...${lightgray}"
  git pull origin release
  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: pull merge conflict${nocolor}"
    return
  fi

  echo -e "${brown}\ndone.${nocolor}"
}

git-fix-dev-push(){
  if ! Git-existed ;then
    echo -e "${red}git repository doesn't exist${nocolor}"
    return
  fi

  echo -e "${brown}goal: push *dev* to origin *release* and merge *dev* to *test*......\n${nocolor}"

  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: the current branch is not clean${nocolor}"
    return
  fi
  echo -en "${cyan}        " && git checkout dev

  echo -e "${green}step: pull from origin *release*...${lightgray}"
  git pull origin release
  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: pull merge conflict${nocolor}"
    return
  fi

  echo -e "${green}\nstep: push to origin *release*...${lightgray}"
  git push origin dev:release

  #merge dev to all feature branches
  local str arr
  str=`git branch | xargs`
  set -f
  arr=(${str})
  for branch in "${arr[@]}"; do
    if [[ "$branch" != "master" && "$branch" != "dev" && "$branch" != "test" && "$branch" != "*" ]];then
      if [[ -n "$(git status --porcelain)" ]];then
        echo -e "error: the current branch is not clean${nocolor}"
        return
      fi
      echo -en "${cyan}\n        " && git checkout $branch

      echo -e "${green}step: merge *dev*...${lightgray}"
      git merge --no-ff dev
      if [[ -n "$(git status --porcelain)" ]];then
        echo -e "error: merge conflict${nocolor}"
        return
      fi

      echo
    fi
  done

  if ! Git-merge-branch-and-push-test dev ;then
    return
  fi

  echo -e "${brown}\ndone.${nocolor}"
}

#hotfix
git-hotfix(){
  if ! Git-existed ;then
    echo -e "${red}git repository doesn't exist${nocolor}"
    return
  fi

  echo -e "${brown}goal: hotfix *master* branch......\n${nocolor}"

  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: the current branch is not clean${nocolor}"
    return
  fi
  echo -en "${cyan}        " && git checkout master

  echo -e "${green}step: pull from origin *master*...${lightgray}"
  git pull origin master
  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: pull merge conflict${nocolor}"
    return
  fi

  echo -e "${brown}\ndone.${nocolor}"
}

git-hotfix-push(){
  if ! Git-existed ;then
    echo -e "${red}git repository doesn't exist${nocolor}"
    return
  fi

  echo -e "${brown}goal: push *master* to origin *master*......\n${nocolor}"

  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: the current branch is not clean${nocolor}"
    return
  fi
  echo -en "${cyan}        " && git checkout master

  echo -e "${green}step: pull from origin master...${lightgray}"
  git pull origin master
  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: pull merge conflict${nocolor}"
    return
  fi

  echo -e "${green}\nstep: push to origin *master*...${lightgray}"
  git push origin master

  echo -e "${brown}\ndone.${nocolor}"
}


#for internal use
Git-list-fix-branches(){
  echo -e "${brown}choose a *feature* branch:${nocolor}"

  #list all the feature branches
  local str arr
  str=`git branch | xargs`
  set -f
  arr=(${str})
  for branch in "${arr[@]}"; do
    if [[ "$branch" != "dev" && "$branch" != "master" && "$branch" != "test" && "$branch" != "*" ]];then
      echo -e "${green}  "$branch"${nocolor}"
    fi
  done
}

Git-pull-feature(){
  if [[ "$#" < 1 ]];then
    echo -e "Git-push-feature error: this should not happen, try to edit ~/.bash_aliases${nocolor}"
    return 1
  fi

  if [[ "$1" == "dev" || "$1" == "master" || "$1" == "*" || "$1" == "test" ]];then
    Git-list-fix-branches
  else
    if [[ -n "$(git status --porcelain)" ]];then
      echo -e "error: the current branch is not clean${nocolor}"
      return 2
    fi

    echo -e "${green}step: pull from origin *$1*...${lightgray}"
    git pull origin $1
    if [[ -n "$(git status --porcelain)" ]];then
      echo -e "error: pull merge conflict${nocolor}"
      return 3
    fi
  fi

  return 0
}

Git-push-feature(){
  if ! Git-pull-feature $1 ;then
    return
  else
    echo -e "${green}\nstep: push to origin *$1*...${lightgray}"
    git push origin $1
  fi

  return 0
}

Git-merge-branch-and-push-test(){
  if [[ "$#" < 1 ]];then
    echo -e "Git-merge-branch-and-push-test error: this should not happen, try to edit ~/.bash_aliases${nocolor}"
    return 1
  fi

  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: the current branch is not clean${nocolor}"
    return 2
  fi

  echo -en "${cyan}\n        " && git checkout test

  echo -e "${green}step: merge *$1*...${lightgray}"
  git merge --no-ff $1
  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: merge conflict${nocolor}"
    return 4
  fi

  echo -e "${green}\nstep: pull from origin *test*...${lightgray}"
  git pull origin test
  if [[ -n "$(git status --porcelain)" ]];then
    echo -e "error: pull merge conflict${nocolor}"
    return 3
  fi

  echo -e "${green}\nstep: push to origin *test*${lightgray}"
  git push origin test

  return 0
}

Git-is-a-feature-branch(){
  if [[ "$#" < 1 ]];then
    echo -e "Git-is-a-feature-branch error: this should not happen, try to edit ~/.bash_aliases${nocolor}"
    return
  fi

  #list all the feature branches
  local str arr
  str=`git branch | xargs`
  set -f
  arr=(${str})
  for branch in "${arr[@]}"; do
    if [[ "$branch" != "dev" && "$branch" != "master" && "$branch" != "test" && "$branch" != "*" ]];then
      if [[ "$branch" == $1 ]];then
        return 0
      fi
    fi
  done

  return 1
}

Git-existed(){
  local str arr
  str=`ls -a`
  set -f
  arr=(${str})
  for branch in "${arr[@]}"; do
    if [[ "$branch" == ".git" ]];then
      return 0
    fi
  done

  return 1
}

#================================== man ===================================
man(){
  LESS_TERMCAP_mb=$'\e'"[1;31m" \
  LESS_TERMCAP_md=$'\e'"[1;36m" \
  LESS_TERMCAP_me=$'\e'"[0m" \
  LESS_TERMCAP_se=$'\e'"[0m" \
  LESS_TERMCAP_so=$'\e'"[1;40;92m" \
  LESS_TERMCAP_ue=$'\e'"[0m" \
  LESS_TERMCAP_us=$'\e'"[1;32m" \
  command man "$@"
}

r(){
  cd /home/mhf/go/src/nice/mist
  go run gen/main.go
  go run a.go
}

#================================== enumlator =============================
emulator(){
  cd "$(dirname "$(which emulator)")" && ./emulator "$@";
}

#============================ to be continued =============================
alias black-android='adb -d shell sh /data/data/me.piebridge.brevent/brevent.sh'
alias chap-clear="rm -r ~/.gradle/caches/modules-2/metadata-2.36/descriptors/com.iamalisper.chap/ && rm -r ~/.gradle/caches/modules-2/files-2.1/com.iamalisper.chap/"
alias chap-publish="~/android/project/Chap/gradlew assembleRelease artifactoryPublish"
alias chap-start="/home/mhf/android/artifactory-oss-5.8.3/bin/artifactoryctl"
