#!/bin/sh

# must run ./install.sh in linux-config/

mkHomeDir(){
  cwd=`pwd`
  cd ~

  mkdir -p \
    .config/autostart .config/tilda \
    bin downloads inkscape rust \
    go/bin go/pkg go/src/wiki go/src/nice \
    js/src \
    software/node software/mongo software/nsq

  cd $cwd
}

cpDotFile(){
  cwd=`pwd`
  cd dotfiles

  cp .bash_aliases .bashrc .gitconfig .ideavimrc .tmux.conf .vimrc .xmodmaprc ~
  . ~/.bashrc

  mkdir -p ~/.cow
  cp .cow/* ~/.cow
  # open ~/.cow/cow to see how to autostart cow

  cp autostart/* ~/.config/autostart
  cp tilda/* ~/.config/tilda

  cd $cwd
}

installSoftware(){
  sudo apt install \
    tilda tmux htop tree silversearcher-ag shadowsocks
}

complieVim(){
  sudo apt install libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git
  sudo apt remove vim vim-runtime gvim

  cwd=`pwd`

  curl https://codeload.github.com/vim/vim/zip/master -o /tmp/vim-master.zip
  unzip /tmp/vim-master.zip -d ~/software
  cd ~/software/vim-master

  # cd ~/software
  # git clone https://github.com/vim/vim.git
  # cd vim

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

installVundle(){
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

installGo(){
  fileName=go1.10.linux-amd64.tar.gz
  curl https://golang.org/doc/install?download=$fileName -o /tmp/$fileName
  sudo tar -C /usr/local -xzf $fileName
}

installNode(){
  cwd=`pwd`
  cd ~/software/node

  dirName=node-v8.9.4-linux-x64
  fileName=${dirName}.tar.xz
  curl https://nodejs.org/dist/v8.9.4/$fileName -o $fileName
  tar -xf $fileName
  ln -s ${dirName}/bin bin

  cd $cwd
}

installYarn(){
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update && sudo apt install yarn

  yarn global add \
    js-beautify mhf-vue-format
}

installLanguage(){
  installGo
  installNode
  installYarn
}

installChrome(){
  fileName=google-chrome-stable_current_amd64.deb
  curl https://dl.google.com/linux/direct/$fileName -o /tmp/${fileName}
  sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
  sudo apt-get install -f
}

installShadowSocksClient(){
  sudo cp dotfiles/shadowsocks.service /etc/systemd/system
  systemctl enable /etc/systemd/system/shadowsocks.service
}

# main
main(){
  mkHomeDir
  cpDotFile
  installSoftware
  installChrome
  
  # complieVim
  # installVundle
  # installLanguage
}

other(){
  echo "go to System Settings > Keyboard > Shortcuts > Launchers, press BackSpace on 'Key to show the HUD'"
  echo "done"
}

main
other
