#!/bin/bash

PATH_TO_SCRIPT=$1

cp -r $PATH_TO_SCRIPT/.config ~/
cp $PATH_TO_SCRIPT/.tmux.conf ~/
cp -r $PATH_TO_SCRIPT/.emacs.d ~/
cp $PATH_TO_SCRIPT/.bashrc ~/

# starship
mkdir -p ~/.local/bin
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -b .local/bin
echo 'eval "$(starship init bash)"' >> ~/.bashrc

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

# git completion for mac
## MAC
# echo "source /usr/local/etc/bash_completion.d/git-prompt.sh" >> ~/.bashrc
# cp /usr/local/etc/bash_completion.d/git-completion.bash .local/

## UBUNTU
cp /usr/share/bash-completion/completions/git .local/
mv .local/git .local/git-completion.bash

echo "__git_complete g __git_main" >> .local/git-completion.bash
echo "source ~/.local/git-completion.bash" >> ~/.bashrc

echo "export PATH=$PATH:~/.local/bin" >> ~/.bashrc

source ~/.bashrc
