#!/bin/bash

cp -r .config ~/
cp .tmux.conf ~/
cp -r .emacs.d ~/
cp .bashrc ~/

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


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

# git completion for mac
echo "source /usr/local/etc/bash_completion.d/git-prompt.sh" >> ~/.bashrc
echo "source /usr/local/etc/bash_completion.d/git-completion.bash" >> ~/.bashrc
echo "__git_complete g __git_main" >> /usr/local/etc/bash_completion.d/git-completion.bash

source ~/.bashrc
