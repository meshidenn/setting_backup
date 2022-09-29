#!/bin/bash

PATH_TO_SCRIPT=$1

cp -r $PATH_TO_SCRIPT/.config ~/
cp $PATH_TO_SCRIPT/.tmux.conf ~/
cp -r $PATH_TO_SCRIPT/.emacs.d ~/
cp $PATH_TO_SCRIPT/.bashrc ~/

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# z
mkdir .commands
git clone https://github.com/rupa/z.git ~/.commands/z/
echo ". ~/.commands/z/z.sh" >> ~/.bashrc

# poetry
curl -sSL https://install.python-poetry.org | python3 -
echo "export PATH=$PATH:$HOME/.local/bin"  >> ~/.bashrc

cd $HOME

# starship
mkdir -p ~/.local/bin
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -b .local/bin
echo 'eval "$(starship init bash)"' >> ~/.bashrc


# git completion for mac
## MAC
echo "source /usr/local/etc/bash_completion.d/git-prompt.sh" >> ~/.bashrc
echo "source /usr/local/etc/bash_completion.d/git-completion.bash" >> ~/.bashrc

## UBUNTU
echo "source /usr/share/bash-completion/completions/git" >> ~/.bashrc

echo "__git_complete g __git_main" >> /usr/local/etc/bash_completion.d/git-completion.bash

echo "export PATH=$PATH:~/.local/bin" >> ~/.bashrc

source ~/.bashrc
