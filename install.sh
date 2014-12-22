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

# clone neobundle
if [ ! -d $DIR/bundle/neobundle.vim ]
then
  git clone https://github.com/Shougo/neobundle.vim $DIR/bundle/neobundle.vim
fi

# run vim
vim +NeoBundleInstall +qa

./$DIR/bundle/YouCompleteMe/install.sh

echo 'All done!'
