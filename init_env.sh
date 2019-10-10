#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    local msg="${1}"
    local type=${2}
    if [ "${type}" == "1" ]; then
        echo -e "${RED}* ${1}${NC}"
    else
        echo -e "${GREEN}* ${1}${NC}"
    fi

}

step() {
    while [ 1 ] ; do
        log "${1}"
	read yn
        case $yn in
            [Yy]* ) return 1;;
            [Nn]* ) return 0;;
            *) log "Please answer yes or no." 1 ;;
        esac
    done
}

step "Install basic packages. [Y/n]"
ret=$?
if [ ${ret} -eq 1 ];then
    apt-get install -y g++ build-essential vim cmake python-dev python3-dev clang git curl \
        nfs-common global tmux exuberant-ctags silversearcher-ag tig


    log "Finish."
fi

step "Prepare vim environments. [Y/n]"
ret=$?
if [ ${ret} -eq 1 ];then

    if [ ! -d "/root/.vim/packages/molokai" ];then
        git clone https://github.com/tomasr/molokai.git ~/.vim/packages/molokai
    fi
    if [ ! -d "/root/.vim/colors" ];then
        mkdir -p "/root/.vim/colors/"
    fi
    cp ~/.vim/packages/molokai/colors/molokai.vim  ~/.vim/colors/
    cp ./conf/vimrc ~/.vimrc
    cp ./conf/tmux.conf /root/.tmux.conf

    log "Finish."
fi

step "Prepare vim plugin. [Y/n]"
ret=$?
if [ ${ret} -eq 1 ];then
    mkdir -p ~/.vim/colors/
    if [ ! -d "/root/.vim/bundle/vundle" ];then
        git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    fi

    log "Finish."
fi

step "Compile YouCompleteMe. [Y/n]"
ret=$?
if [ ${ret} -eq 1 ];then
    if [ ! -d "/root/.vim/bundle/YouCompleteMe" ];then
        log "[Error] Failed to locate YouCompleteMe dir"
        exit 1
    fi
    python3 /root/.vim/bundle/YouCompleteMe/install.py --clang-completer
    log "Finish."
fi

step "Set git env. [Y/n]"
ret=$?
if [ ${ret} -eq 1 ];then
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.st status
    git config --global alias.pick cherry-pick
    git config --global alias.last 'log -1 HEAD'
    git config --global core.editor vim
    log "Finish."
fi

log "* Follows are some manual settin, please do it step by step"
log "-----------------------------"

log "Into vim to run :PluginInstall"
log "-----------------------------"

log "For Powerline font on windows."
log "Please download https://github.com/eugeneching/consolas-powerline-vim.git int C:/windows/fonts."
log "And change putty fonts style"
log "-----------------------------"

log "For gtags, download gtags-cscope.vim and gtags.vim. Then put then into /root/.vim/plugin "
log "-----------------------------"
