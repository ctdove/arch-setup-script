#!/usr/bin/bash

ZSHRC="./reqs/.zshrc"
VIMRC="./reqs/.vimrc"
P10KRC="./reqs/.p10k.zsh"

mkdir $HOME/bin
#**install git**
# gets latest version link
git_ver=$(basename \
	$(curl -s -N https://mirrors.edge.kernel.org/pub/software/scm/git/ | \
 		grep "<a href=" | \
 		sed -n -e "s/^.*href=\"//p" | \
 		sed -n -e "s/\">.*//p" | \
 		grep -E -v "./*(man|html|core)" | \
		tail -n2 | head -n1) \
	.tar.xz)

# download lastest version
curl "https://mirrors.edge.kernel.org/pub/software/scm/git/${git_ver}" \
	--output $HOME/${git_ver}.tar.xz
tar -xf ${git_ver}.tar.xz ; rm ${git_ver}.tar.xz ; cd ${git_ver} 
make configure
./configure --prefix=$HOME/local
make ; make install

# TODO : install git (not preinstalled on most arch isos)
# download zsh
curl \
	"https://sourceforge.net/projects/zsh/files/zsh/latest/dowwnload" \
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
[ -f "$SHELL" ] && exec "$SHELL" -l" \
>> $HOME/.bash_profile
source $HOME/.bash_profile

# TODO put oh-my-zsh install scipt directly into this one
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm $HOME/.zshrc ; cp ${ZSHRC} $HOME/.zshrc ; source $HOME/.zshrc
# autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
${ZSH_CUSTOM:-$HO$HOMEE/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# POWERLEVEL10K theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp ${P10KRC} $HOME/.p10k.zsh

source $HOME/.zshrc
#--------------------------------------
# vim setup
if ! pacman -Qi vim > /dev/null ; then
	# install vim
	git clone https://github.com/vim/vim.git
	cd vim
	[ ! -d "$HOME/.local"  ] && mkdir -p "$HOME/.local"
	./configure --prefix=$HOME/.local && make && make install
	export PATH=$PATH:$HOME/.local/bin
fi
# install vundle
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
# copy vim config
cp ${VIMRC} $HOME/.vimrc
# TODO get plugin dependencies ; clean up vimrc
# install plugins
vim +PlugInstall -c q # <- installs plugins then quits vim
#--------------------------------------
