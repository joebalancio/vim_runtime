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
if [ ! -e "$DIR/autoload/plug.vim" ]
then
  curl -fLo $DIR/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# run vim
if hash nvim 2>/dev/null
then
  nvim -u $DIR/vimrc-deps +PlugInstall
else
  vim -u $DIR/vimrc-deps +PlugInstall
fi

echo 'All done!'
