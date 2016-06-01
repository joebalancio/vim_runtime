#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# link vimrc to home
if [ -L ~/.vimrc ]
then
  unlink ~/.vimrc
else
  rm ~/.vimrc
fi
ln -s $DIR/vimrc ~/.vimrc

# link vim_runtime to home
if [ -L ~/.vim ]
then
  unlink ~/.vim
else
  rm ~/.vim
fi
ln -s $DIR ~/.vim

# link vim_runtime to neovim
if [ -L ~/.config/nvim ]
then
  unlink ~/.config/nvim
else
  rm ~/.config/nvim
fi
ln -s $DIR ~/.config/nvim

# clone neobundle
if [ ! -d $DIR/bundle/Vundle.vim ]
then
  git clone https://github.com/VundleVim/Vundle.vim.git $DIR/bundle/Vundle.vim
fi

# run vim
vim -u $DIR/vimrc-vundle +PluginInstall +qall

$DIR/bundle/YouCompleteMe/install.sh

echo 'All done!'
