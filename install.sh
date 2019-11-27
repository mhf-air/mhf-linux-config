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

# must run ./install.sh in linux-config/
# edit ~/.config/user-dirs.dirs to .Desktop and change other lines to "$HOME/"

# after shadowsocks server-side config changes
# remember to change two places
#   ~/.cow/rc
#   ~/.bin/cow/shadowsocks.json
# and then run restart-ss

# install proxy
#   drap and drop .crx file into chrome's extenstion page
#   click Import/Export, input into Restore from online
#     https://raw.githubusercontent.com/wiki/FelisCatus/SwitchyOmega/GFWList.bak
#   click 自动切换, then click Download Profile Now
#   click the plugin icon on top-right corner, select 自动切换

# gnome extentions
#   in chrome, open gnome-shell-extension, click sync, select use remote
#     Clock Override %b%d日  %A  %R
#   enable NO title bar extension
#   enable Dynamic panel transparency extension
#     go to Background -> Enable custom panel color: #40403b
#     press Alt + F2, r enter amamam

# keyboard shortcut
#   open Tweaks -> Extensions -> Workspace grid -> setting: 2 x 2
#   open Settings -> Devices -> Keyboard
#     move to the bottom, click + button, enter
#       cycle workspace v
#       /home/mhf/.bin/aa/cycle-workspaces.sh v
#       F2
#
#       cycle workspace h
#       /home/mhf/.bin/aa/cycle-workspaces.sh h
#       F3

# open chrome -> stylus extension option -> import conf/stylus-some-date.json

# see https://github.com/cytle/wechat_web_devtools
# install wine

# 点击微信置顶
# 取消系统通知里的微信和备份


mkHomeDir() {
	local cwd=$(pwd)
	cd ~

	mkdir -p \
		.config/autostart .config/tilda \
		.bin/aa downloads inkscape blender rust c .Desktop \
		go/bin go/pkg go/src/wiki go/src/nice \
		js/src/work \
		py/tf \
		android/project android/sdk \
		software/node software/redis software/gradle

	cd $cwd
}

cpDotFile() {
	local cwd=$(pwd)
	cd dotfiles

	cp .bash_aliases .bashrc .gitconfig .inputrc .ideavimrc .tmux.conf .vimrc .xmodmaprc .orig-xmodmaprc .tern-project ~
	cp -r .bash_completion.d ~
	. ~/.bashrc

	cp .ycm_extra_conf.py ~/c

	cp .rustfmt.toml ~/rust

	cp -r cow ~/.bin

	# /etc/xdg/autostart is the place to add autostart script too
	cp autostart/* ~/.config/autostart
	cp tilda/* ~/.config/tilda

	cp aa-bin/* ~/.bin/aa

	cd $cwd
}

installUtility() {
	sudo add-apt-repository ppa:git-core/ppa

	sudo apt update
	sudo apt install \
		tilda git htop tree silversearcher-ag shadowsocks pylint3 clang-format \
		curl httpie wget gnome-tweak-tool make gcc wmctrl libgnome2-bin
}

compileTmux() {
	local cwd=$(pwd)
	cd /tmp

	sudo apt remove tmux
	sudo apt install \
	 libncurses5-dev libncursesw5-dev

	local libeventVersion=2.1.8-stable
	local libevent=libevent-${libeventVersion}.tar.gz
	wget https://github.com/libevent/libevent/releases/download/release-${libeventVersion}/$libevent
	tar -xzf $libevent
	cd libevent-${libeventVersion}
	./configure && make && sudo make install
	cd ..

	local tmuxVersion=2.7
	local tmux=tmux-${tmuxVersion}.tar.gz
	wget https://github.com/tmux/tmux/releases/download/${tmuxVersion}/$tmux
	tar -xzf $tmux
	cd tmux-${tmuxVersion}
	./configure --enable-static && make && sudo make install

	cd $cwd
}

compileVim() {
	sudo apt install libncurses5-dev libgnome2-dev libgnomeui-dev \
		libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
		python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git

	local cwd=$(pwd)

	# wget https://codeload.github.com/vim/vim/zip/master -O /tmp/vim-master.zip
	# unzip /tmp/vim-master.zip -d ~/software
	# cd ~/software/vim-master

	cd ~/software
	git clone https://github.com/vim/vim.git
	cd vim

	sudo apt remove vim vim-runtime gvim

	make distclean
	./configure --with-features=huge \
						--enable-multibyte \
						--enable-rubyinterp=yes \
						--enable-pythoninterp=dynamic \
						--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
						--enable-python3interp=dynamic \
						--with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
						--enable-perlinterp=yes \
						--enable-luainterp=yes \
						--enable-gui=gtk2 \
						--enable-cscope \
						--prefix=/usr/local
	make && sudo make install

	cd $cwd
}

installVimPlug() {
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

installGo() {
	local fileName=go.linux-amd64.tar.gz
	wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz -O /tmp/$fileName
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf /tmp/$fileName

	go get -u -v github.com/mhf-air/tab-indent
}

installNode() {
	local cwd=$(pwd)
	cd ~/software/node

	local version=v12.13.1
	local dirName=node-${version}-linux-x64
	local fileName=${dirName}.tar.xz
	wget https://nodejs.org/dist/${version}/$fileName -O $fileName
	tar -xf $fileName

	rm -f ~/.bin/node
	link-to-bin ${dirName}/bin node

	cd $cwd
}

installYarn() {
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt update && sudo apt install yarn

	yarn global add \
		js-beautify
		typescript

	# I don't know when to install yapf, so I put it here
	pip3 install yapf
}

installChrome() {
	local fileName=google-chrome-stable_current_amd64.deb
	wget https://dl.google.com/linux/direct/$fileName -O /tmp/${fileName}
	sudo dpkg -i --force-depends /tmp/${fileName}
	sudo apt-get install -f
}

installShadowSocksClient() {
	# download cow
	curl -L git.io/cow | COW_INSTALLDIR=/home/mhf/.bin/cow bash

	sudo cp dotfiles/cow/shadowsocks.service /etc/systemd/system
	sudo cp dotfiles/cow/cow.service /etc/systemd/system
	sudo systemctl enable --now /etc/systemd/system/shadowsocks.service
	sudo systemctl enable --now /etc/systemd/system/cow.service

	sed -i "s/# export http_proxy=/export http_proxy=/g" ~/.bashrc
	sed -i "s/# export https_proxy=/export https_proxy=/g" ~/.bashrc
	. ~/.bashrc
}

# NOTE: this plugin conficts with SwitchyOmega
#
# after cloning the repo
# open chrome extensions
# choose dev mode
# click load unpacked and choose ~/downloads/google-access-helper
installGoogleAccessHelper() {
	local cwd=$(pwd)
	cd ~/downloads

	git clone https://github.com/haotian-wang/google-access-helper.git

	cd $cwd
}

installQQ() {
	# see https://github.com/wszqkzqk/deepin-wine-ubuntu

	# 解决微信不能发送图片的问题
	sudo apt install libjpeg62:i386

	# 解决微信通知窃取窗口焦点的问题(好像不用设置也不会窃取焦点了)
	# open dconf-editor
	# navigate to org -> gnome -> desktop -> wm -> preference
	# choose strict over smart

	local cwd=$(pwd)
	cd ~/software
	git clone https://gitee.com/wszqkzqk/deepin-wine-for-ubuntu.git

	cd deepin-wine-for-ubuntu
	./install.sh

	mkdir mhf
	cd mhf
	# install QQ
	wget https://mirrors.aliyun.com/deepin/pool/non-free/d/deepin.com.qq.im/deepin.com.qq.im_8.9.19983deepin23_i386.deb
	sudo dpkg -i deepin.com.qq.im_8.9.19983deepin23_i386.deb

	# install WeChat
	wget https://mirrors.aliyun.com/deepin/pool/non-free/d/deepin.com.wechat/deepin.com.wechat_2.6.2.31deepin0_i386.deb
	sudo dpkg -i deepin.com.wechat_2.6.2.31deepin0_i386.deb

	cd $cwd
}

# main
main() {
	# mkHomeDir
	# cpDotFile
	# installUtility

	# installShadowSocksClient
	# installGoogleAccessHelper

	# compileTmux
	# installVimPlug
	# compileVim

	# installChrome

	# installGo
	installNode
	# installYarn
	# installQQ
}

main
