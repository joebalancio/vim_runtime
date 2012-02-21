#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# link vimrc to home
rm ~/.vimrc
ln -s $DIR/vimrc ~/.vimrc

# create temp file
sed -n '/VUNDLE_INSTALL_START/,/VUNDLE_INSTALL_END/p' vimrc > $DIR/tempfile

# clone vundle
git clone https://github.com/gmarik/vundle.git $DIR/bundle/vundle

# run vim
vim -u tempfile +BundleInstall +qa
