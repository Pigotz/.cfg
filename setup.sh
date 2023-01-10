#!/bin/bash

echo "1. Checking out cfg repository"

git clone --bare git@github.com:Pigotz/.cfg.git $HOME/.cfg

function config {
	/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

# # Backup dir
# mkdir $HOME/.cfg-backup

# Checking out repo files
config checkout

# Avoid showing the entire home as untracked
config config status.showUntrackedFiles no

echo "2. Initialising submodules"

# Submodules
config submodule update --init
