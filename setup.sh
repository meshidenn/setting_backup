#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# GNU Stow のインストール
echo "Installing stow..."
if ! command -v stow &> /dev/null; then
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y stow
    elif command -v brew &> /dev/null; then
        brew install stow
    fi
fi

# 既存のファイルをバックアップ（シンボリックリンクでない場合）
backup_if_exists() {
    local target="$HOME/$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target to $target.backup"
        mv "$target" "$target.backup"
    fi
}

echo "Backing up existing files..."
backup_if_exists ".bashrc"
backup_if_exists ".bash_profile"
backup_if_exists ".profile"
backup_if_exists ".tmux.conf"
backup_if_exists ".config/git"
backup_if_exists ".config/starship.toml"
backup_if_exists ".claude"

# 必要なディレクトリを作成
mkdir -p "$HOME/.config"

# Stow でシンボリックリンク作成
echo "Stowing dotfiles..."
cd "$DOTFILES_DIR"
stow -v bash tmux git starship claude

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

# gemini-cli
echo setup gemini cli
npm install -g @google/gemini-cli

pushd ${HOME}

# starship
echo setup starship
mkdir -p ~/.local/bin
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -b ${HOME}/.local/bin
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
