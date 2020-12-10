#!/usr/bin/bash
ZSHRC="./reqs/.zshrc"
VIMRC="./reqs/.vimrc"
P10KRC="./reqs/.p10k.zsh"

mkdir $HOME/bin
# download zsh
curl
"https://sourceforge.net/projects/zsh/files/zsh/latest/dowwnload"
--output "$HOME/zsh.tar.xz"
tar -xf "$HOME/zsh.tar.xz" ; rm "$HOME/zsh.tar.xz" 
# build zsh
cd $HOME/zsh
./configure --prefix="$HOME/local" \
	    CPPFLAGS="-I$HOME/local/include" \
			    LDFLAGS="-L$HOME/local/lib"
make -j && make install

# change default shell to zsh
echo "
export PATH=$HOME/local/bin:$PATH
export SHELL=`which zsh`
[ -f "$SHELL" ] && exec "$SHELL" -l" 
>> $HOME/.bash_profile
source $HOME/.bash_profile

# TODO put oh-my-zsh install scipt directly into this one
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm $HOME/.zshrc ; cp $(ZSHRC) $HOME/.zshrc ; source $HOME/.zshrc
# autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions
${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# POWERLEVEL10K theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp $(P10KRC) $HOME/.p10k.zsh

source $HOME/.zshrc

