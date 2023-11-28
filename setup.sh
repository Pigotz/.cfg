#!/bin/bash
set -e

# TODO: Add fontconfig apt install
# TODO: Add Noto Color Emoji | https://fonts.google.com/noto/specimen/Noto+Color+Emoji

echo "0. Update system and install deps"

sudo apt update

sudo apt install build-essential

echo "1. Checking out cfg repository"

git clone --bare https://github.com/Pigotz/.cfg.git $HOME/.cfg

function config {
	/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

# Checking out repo files
config checkout

# Avoid showing the entire home as untracked
config config status.showUntrackedFiles no


echo "2. Initialising submodules"

# Submodules
config submodule update --init


echo "3. Cloning custom ZSH things into .oh-my-zsh folder"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin

echo "4. Installing ZSH via APT"

sudo apt install -y zsh


echo "5. Make ZSH the default shell"

sudo chsh -s $(which zsh)


echo "6. Installing tools"

echo "6.1. LSD"
# https://github.com/Peltoche/lsd

if ! [ -x "$(command -v lsd)" ]; then
    lsd_version=0.23.1

    wget https://github.com/Peltoche/lsd/releases/download/$(echo $lsd_version)/lsd_$(echo $lsd_version)_amd64.deb
    
    sudo dpkg -i lsd_$(echo $lsd_version)_amd64.deb

    rm lsd_$(echo $lsd_version)_amd64.deb

    echo -e "\tLSD successfully installed"
else
    echo -e "\tLSD already installed"
fi


echo "6.2. xclip"
# https://avilpage.com/2014/04/access-clipboard-from-terminal-in.html

if ! [ -x "$(command -v xclip)" ]; then
    sudo apt install -y xclip

    echo -e "\txclip successfully installed"
else
    echo -e "\txclip already installed"
fi


echo "6.3. pyenv"
# https://github.com/pyenv/pyenv#automatic-installer


if ! [ -x "$(command -v pyenv)" ]; then
    curl https://pyenv.run | bash

    echo -e "\tpyenv successfully installed"
else
    echo -e "\tpyenv already installed"
fi

echo "6.4. Go"
# https://go.dev/doc/install


if ! [ -x "$(command -v go)" ]; then
    go_version=1.19.4

    wget https://go.dev/dl/go$(echo $go_version).linux-amd64.tar.gz

    rm -rf /usr/local/go && tar -C /usr/local -xzf go$(echo $go_version).linux-amd64.tar.gz

    echo -e "\tGo successfully installed"
else
    echo -e "\tGo already installed"
fi

echo "6.5. tmux"
# https://github.com/tmux/tmux/wiki/Installing


if ! [ -x "$(command -v tmux)" ]; then
    sudo apt install -y tmux

    echo -e "\ttmux successfully installed"
else
    echo -e "\ttmux already installed"
fi

echo "6.6. Rust and Cargo"
# https://www.rust-lang.org/tools/install


if ! [ -x "$(command -v cargo)" ] && ! [ -x "$(command -v rustc)" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    echo -e "\tRust and Cargo successfully installed"
else
    echo -e "\tSkipping because something is already installed"
fi

echo "6.6. Node and N"
# https://www.rust-lang.org/tools/install


if ! [ -x "$(command -v node)" ]; then
    curl -L https://bit.ly/n-install | bash

    n install 16

    echo -e "\Node and N successfully installed"
else
    echo -e "\tSkipping because Node is already installed"
fi

echo "6.7. fzf"
# https://github.com/junegunn/fzf#using-git


if ! [ -x "$(command -v fzf)" ]; then
    .fzf/install --bin

    echo -e "\Node and N successfully installed"
else
    echo -e "\tSkipping because Node is already installed"
fi
