#!/bin/bash
set -e

# TODO: Add fontconfig apt install
# TODO: Add Noto Color Emoji | https://fonts.google.com/noto/specimen/Noto+Color+Emoji

echo "0. Update system and install deps"

# If apt is not present, skip the whole installation

if ! [ -x "$(command -v apt)" ]; then
    echo "Skipping installation because apt is not present"
    exit 1
fi

sudo apt update

sudo apt install build-essential

echo "1. Checking out cfg repository"

# If git is not present, install it
if ! [ -x "$(command -v git)" ]; then
    echo "Git is not installed. Installing it now"
    sudo apt install -y git
fi

# If destinetion folder is already present, remove it
if [ -d "$HOME/.cfg" ]; then
    echo "Removing existing .cfg folder"
    rm -rf $HOME/.cfg
fi

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

    wget "https://github.com/Peltoche/lsd/releases/download/$(echo $lsd_version)/lsd_$(echo $lsd_version)_amd64.deb"

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


echo "6.3. tmux"
# https://github.com/tmux/tmux/wiki/Installing


if ! [ -x "$(command -v tmux)" ]; then
    sudo apt install -y tmux

    echo -e "\ttmux successfully installed"
else
    echo -e "\ttmux already installed"
fi


echo "6.4. fzf"
# https://github.com/junegunn/fzf#using-git


if ! [ -x "$(command -v fzf)" ]; then
    ~/.fzf/install --bin

    echo -e "\tFZF successfully installed"
else
    echo -e "\tSkipping because FZF is already installed"
fi
