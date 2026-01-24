#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# GNU Stow のインストール
echo "Installing stow..."
if ! command -v stow &> /dev/null; then
    if command -v brew &> /dev/null; then
        brew install stow
    elif command -v apt &> /dev/null && sudo -n true 2>/dev/null; then
        sudo apt update && sudo apt install -y stow
    else
        # ソースからローカルインストール
        echo "Installing stow from source..."
        mkdir -p ~/.local/bin ~/.local/src
        cd ~/.local/src
        curl -LO http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
        tar xzf stow-latest.tar.gz
        cd stow-*/
        ./configure --prefix="$HOME/.local"
        make install
        cd "$DOTFILES_DIR"
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
if ! command -v mise &>/dev/null; then
    curl https://mise.run | sh
    eval "$(~/.local/bin/mise activate bash)"
    mise use --global node
else
    echo "mise already installed, skipping"
    eval "$(~/.local/bin/mise activate bash)"
fi

# claude
echo setup claude code
if ! command -v claude &>/dev/null; then
    npm install -g @anthropic-ai/claude-code
else
    echo "claude already installed, skipping"
fi

# gemini-cli
echo setup gemini cli
if ! command -v gemini &>/dev/null; then
    npm install -g @google/gemini-cli
else
    echo "gemini already installed, skipping"
fi

# starship
echo setup starship
if ! command -v starship &>/dev/null; then
    mkdir -p ~/.local/bin
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -b ${HOME}/.local/bin -y
else
    echo "starship already installed, skipping"
fi

# fzf
echo setup fzf
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
else
    echo "fzf already installed, skipping"
fi

# zoxide
echo setup zoxide
if ! command -v zoxide &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    echo "zoxide already installed, skipping"
fi

# uv
echo setup uv
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv already installed, skipping"
fi

# kubectl
echo setup kubectl
if ! command -v kubectl &>/dev/null; then
    cd /tmp
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    chmod +x kubectl
    mv kubectl ~/.local/bin/
    cd "$DOTFILES_DIR"
else
    echo "kubectl already installed, skipping"
fi

# git completion
echo setup git completion
if [ ! -f ~/.local/git-completion.bash ]; then
    if [ -f /usr/share/bash-completion/completions/git ]; then
        cp /usr/share/bash-completion/completions/git ~/.local/git-completion.bash
        echo "__git_complete g __git_main" >> ~/.local/git-completion.bash
    fi
else
    echo "git completion already installed, skipping"
fi

echo "Setup complete!"
