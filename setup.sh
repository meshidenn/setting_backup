#!/bin/bash

cp -r .config ~/
cp .tmux.conf ~/
cp -r .emacs.d ~/

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
cp .bashrc ~/

# starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# z
mkdir .commands
git clone https://github.com/rupa/z.git ~/.commands/z/
echo ". ~/.commands/z/z.sh" >> ~/.bashrc

# poetry
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python -
echo "export PATH=$PATH:$HOME/.local/bin"  >> ~/.bashrc

source ~/.bashrc
