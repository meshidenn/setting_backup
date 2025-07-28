#!/bin/bash


cp -r .config $HOME
cp -r .tmux.conf $HOME
cp -r .bashrc $HOME

# starship
echo setup starship
mkdir -p ~/.local/bin
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -b .local/bin
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# fzf
echo setup fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# z
echo setup z
mkdir .commands
git clone https://github.com/rupa/z.git ~/.commands/z/
echo ". ~/.commands/z/z.sh" >> ~/.bashrc

# uv
echo setup uv
curl -LsSf https://astral.sh/uv/install.sh | sh
cd $HOME

# kubectl
echo setup kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# mise
echo setup mise
curl https://mise.run | sh
~/.local/bin/mise --version
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
mise use --global node
node -v

# claude
echo setup claude code
npm install -g @anthropic-ai/claude-code
cp -r .claude $HOME

# gemini-cli
echo setup gemini cli
npm install -g @google/gemini-cli

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
