#!/usr/bin/bash

# update pacman cache & install zsh
sudo pacman -Sy zsh
# change default shell to zsh
chsh $USER -s $(which zsh) 
# TODO put oh-my-zsh install scipt directly into this one
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

