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
alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'

newfile() {
	local path="$1"
	local dir=$(dirname "$path")
	mkdir -p "$dir"
	touch "$path"
}
c() {
	cd "$@"
	l
}
alias ..='c ..'
alias ...='c ../..'

b() {
	local url="$1"
	google-chrome "$url" &> /dev/null
	wmctrl -a tilda
}

alias d="docker"
alias yarn-global-update="yarn global upgrade-interactive"
alias fe="gnome-open . &> /dev/null && sleep 0.3s && wmctrl -a tilda"

# tmux start cmd
alias tm="tmux \
new -c ~/go/src/nice/web-vue -n server-running -s server-running \; \
split-window -h -c ~/go/src/nice/web-vue\; \
select-pane -t 1 \; \
new -c ~/c/vulkan -n server -s default\; \
new-window -c ~/c/vulkan -n cg -t default\; \
select-pane -t 1 \; \
new-window -c ~/go/src/wiki -n go -t default\; \
select-pane -t 1 \; \
new-window -c ~/go/src/nice -n nice -t default\; \
select-pane -t 1 \; \
new-window -c ~/go/src/nice/web-vue -n js -t default\; \
select-pane -t 1 \; \
select-window -t default:1 \; \
"

# split-window -vc ~/go/src/wiki -p 15 -t default \; \
# split-window -hc ~/go/src/wiki -p 50 -t default \; \
alias q-tmux="tmux kill-server"

alias sbcl='sbcl --noinform'
# alias make='make -s'
alias m='make'
alias gcc='gcc -std=c11'
alias g++='g++ -std=c++11'

alias amamam='xmodmap ~/.xmodmaprc'
alias mamama='xmodmap ~/.orig-xmodmaprc'
alias setproxy="export http_proxy=http://127.0.0.1:7777; export https_proxy=http://127.0.0.1:7777; echo 'HTTP Proxy on'"
alias unsetproxy="unset http_proxy; unset https_proxy; echo 'HTTP Proxy off'"

#some git basic aliases
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --graph \
--pretty=format:"%C(red)%h   %C(green)%ad   %C(cyan)%s   %C(dim white)%an%Creset  %C(yellow)%d" \
--date=short'
# --pretty=format:"%C(red)%h %Creset%C(yellow)[%C(green)%ad%Creset%C(yellow) %C(bold blue)%an%Creset%C(yellow)] %C(cyan)%s %C(yellow)%d%+b" \
alias gm='git merge --squash'
alias gs='git status --ignore-submodules'
alias gg='git add . && git commit -m "s:"'

#common typos
alias suod='sudo'
alias eixt='exit'
alias vmi='vim'

#================================== vim ===================================
v() {
	local session window pane servername str vimcmd

	if [[ -n "$(ps -e | grep tmux)" ]]; then
		session=$(tmux list-sessions | grep attached | cut -d : -f 1)
		window=$(tmux list-windows | grep active | cut -d : -f 1)
		pane=$(tmux list-panes | grep active | cut -d : -f 1)
		servername=$(echo $session$window$pane | tr 'a-z' 'A-Z')
	else
		servername=$(echo "not-in-tmux" | tr 'a-z' 'A-Z')
	fi

	str=$(vim --serverlist | grep "$servername")
	if [[ -n "$str" ]]; then
		if [ -n "$1" ]; then
			#now only support open one file, e.g. v .bashrc
			vimcmd=":cd $PWD<cr>:tabnew<cr>:e $1<cr>"
		else
			vimcmd=":cd $PWD<cr>"
		fi

		vim --servername "$str" --remote-send "$vimcmd"
		fg
	else
		vim --servername "$servername"
	fi
}

#============================== git workflow ==============================
git-last-push() {
	local origin=$(git remote)
	local cur=$(git rev-parse --abbrev-ref HEAD)
	local commit=$(git rev-parse "${origin}/${cur}")
	git reset "$commit"
}

git-clean() {
	echo "***** before *****"
	git count-objects -vH
	echo

	git reflog expire --all --expire=now
	git gc --prune=now --aggressive

	echo
	echo "***** after *****"
	git count-objects -vH
}

git-new-feature() {
	if ! _git-existed ;then
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
g() {
	if ! _git-existed ;then
		echo -e "${red}git repository doesn't exist${nocolor}"
		return
	fi

	if [[ "$#" < 1 ]];then
		_git-list-fix-branches
		return
	fi

	if [[ "$1" == "dev" ]];then
		echo -e "you should use: git-fix-dev${nocolor}"
		return
	elif _git-is-a-feature-branch $1 ;then
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
		_git-list-fix-branches
		return
	fi
}

g-test() {
	if ! _git-existed ;then
		echo -e "${red}git repository doesn't exist${nocolor}"
		return
	fi

	if [[ "$#" < 1 ]];then
		_git-list-fix-branches
		return
	fi

	if [[ "$1" == "dev" ]];then
		echo -e "you should use: git-fix-dev-push${nocolor}"
		return
	elif _git-is-a-feature-branch $1 ;then
		echo -e "${brown}goal: merge *$1* to *test*......\n${nocolor}"
		echo -en "${cyan}        " && git checkout $1
		if ! _git-pull-feature $1 ;then
			return
		fi
		if ! _git-merge-branch-and-push-test $1 ;then
			return
		fi

		echo -e "${brown}\ndone.${nocolor}"
	else
		_git-list-fix-branches
		return
	fi
}

g-push() {
	if ! _git-existed ;then
		echo -e "${red}git repository doesn't exist${nocolor}"
		return
	fi

	if [[ "$#" < 1 ]];then
		_git-list-fix-branches
		return
	fi

	if [[ "$1" == "dev" ]];then
		echo -e "you should use: git-fix-dev-push${nocolor}"
		return
	elif _git-is-a-feature-branch $1 ;then
		echo -e "${brown}goal: push *$1* to origin and merge *$1* to *test*......\n${nocolor}"
		echo -en "${cyan}        " && git checkout $1
		if ! _git-push-feature $1 ;then
			return
		fi
		if ! _git-merge-branch-and-push-test $1 ;then
			return
		fi

		echo -e "${brown}\ndone.${nocolor}"
	else
		_git-list-fix-branches
		return
	fi
}

#fix dev branch
git-fix-dev() {
	if ! _git-existed ;then
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

git-fix-dev-push() {
	if ! _git-existed ;then
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

	if ! _git-merge-branch-and-push-test dev ;then
		return
	fi

	echo -e "${brown}\ndone.${nocolor}"
}

#hotfix
git-hotfix() {
	if ! _git-existed ;then
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

git-hotfix-push() {
	if ! _git-existed ;then
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
_git-list-fix-branches() {
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

_git-pull-feature() {
	if [[ "$#" < 1 ]];then
		echo -e "_git-push-feature error: this should not happen, try to edit ~/.bash_aliases${nocolor}"
		return 1
	fi

	if [[ "$1" == "dev" || "$1" == "master" || "$1" == "*" || "$1" == "test" ]];then
		_git-list-fix-branches
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

_git-push-feature() {
	if ! _git-pull-feature $1 ;then
		return
	else
		echo -e "${green}\nstep: push to origin *$1*...${lightgray}"
		git push origin $1
	fi

	return 0
}

_git-merge-branch-and-push-test() {
	if [[ "$#" < 1 ]];then
		echo -e "_git-merge-branch-and-push-test error: this should not happen, try to edit ~/.bash_aliases${nocolor}"
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

_git-is-a-feature-branch() {
	if [[ "$#" < 1 ]];then
		echo -e "_git-is-a-feature-branch error: this should not happen, try to edit ~/.bash_aliases${nocolor}"
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

# ================================================================================
_checkItem() {
	local wd=$(pwd)

	local item="$1"
	cd "$item"

	if _git-existed; then
		local darkgreen='\033[1;32m'
		local nocolor='\033[0m'

		local full="$wd/$sub"
		echo -e "${darkgreen}${full:17}${nocolor}"

		git pull origin master

		echo
		cd "$wd"
		return 0
	fi

	local list=($(ls))
	for sub in "${list[@]}"
	do
		if [[ -d "$sub" ]]; then
			_checkItem "$sub"
		fi
	done

	cd "$wd"
}

go-update() {
	local wd=$(pwd)
	cd "/home/mhf/go/src"

	for sub in *
	do
		echo $sub
		if [[ "$sub" == "nice" || "$sub" == "wiki" ]]; then
			continue
		fi

		if [[ -d "$sub" ]]; then
			_checkItem "$sub"
		fi
	done

	cd "$wd"
}

#================================== man ===================================
man() {
	LESS_TERMCAP_mb=$'\e'"[1;31m" \
	LESS_TERMCAP_md=$'\e'"[1;36m" \
	LESS_TERMCAP_me=$'\e'"[0m" \
	LESS_TERMCAP_se=$'\e'"[0m" \
	LESS_TERMCAP_so=$'\e'"[1;40;92m" \
	LESS_TERMCAP_ue=$'\e'"[0m" \
	LESS_TERMCAP_us=$'\e'"[1;32m" \
	command man "$@"
}

#============================ to be continued =============================
