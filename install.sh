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

# clone vundle
if [ ! -d $DIR/bundle/vundle ]
then
  git clone https://github.com/gmarik/vundle.git $DIR/bundle/vundle
fi

# create temp file
sed -n '/VUNDLE_INSTALL_START/,/VUNDLE_INSTALL_END/p' vimrc > $DIR/tempfile

# run vim
vim -u $DIR/tempfile +BundleInstall +qa

# delete temp file
rm $DIR/tempfile

echo 'All done!'
