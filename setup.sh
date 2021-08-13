#!/bin/bash

cp -r .config ~/
cp .tmux.conf
cp -r .emacs.d ~/
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

sh -c "$(curl -fsSL https://starship.rs/install.sh)"
echo 'eval "$(starship init bash)"' >> .bashrc
