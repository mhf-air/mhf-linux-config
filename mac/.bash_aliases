shopt -s expand_aliases

# some grep aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some ls aliases
alias ls='ls -G'
alias ll='ls -AlFsh'
alias la='ls -A'
alias l='ls -CF'

# misc
alias cp='cp -v'
alias mv='mv -v'
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
alias d='docker'

# tmux start cmd
alias tm="tmux \
new -c ~/js/src/pmis -n server-running -s server-running \; \
select-pane -t 0 \; \
new -c ~/js/src/pmis -n server -s default\; \
new-window -c ~/js/src/demo -n js -t default\; \
select-pane -t 0 \; \
new-window -c ~/go/src/wiki -n go -t default\; \
select-pane -t 0 \; \
new-window -c ~/go/src/nice -n nice -t default\; \
select-pane -t 0 \; \
select-window -t default:0 \; \
"
# new-window -c ~/android/kotlin/wiki -n kotlin -t default\; \

# split-window -vc ~/go/src/wiki -p 15 -t default \; \
# split-window -hc ~/go/src/wiki -p 50 -t default \; \
alias q-tmux="tmux kill-server"

alias setproxy="export http_proxy=http://127.0.0.1:1087; export https_proxy=http://127.0.0.1:1087; echo 'HTTP Proxy on'"
alias unsetproxy="unset http_proxy; unset https_proxy; echo 'HTTP Proxy off'"

#some git basic aliases
alias ga='git add'
alias gac='git add . && git commit'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --graph \
--pretty=format:"%C(red)%h %Creset%C(yellow)[%C(bold blue)%cn%Creset%C(yellow),%C(green)%cd%Creset%C(yellow)] %C(cyan)%s %C(yellow)%d" \
--date=short
'
alias gm='git merge --no-ff --squash'
alias gs='git status --ignore-submodules'
alias gg='git add . && git commit -m "s:"'

# How to squash local commits into one commit?
# git reset <last pushed commit>
# gac

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

