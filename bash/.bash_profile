# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# SSH agent (keychain)
if command -v keychain &>/dev/null; then
    eval "$(keychain --eval --quiet \
        ~/.ssh/id_abci3.0_ed25519 \
        ~/.ssh/id_rsa_abci \
        ~/.ssh/id_rsa_github \
        ~/.ssh/matsuo_llm_ed25519)"
fi
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PATH:$PYENV_ROOT/bin"
# eval "$(pyenv init -)"
# eval "$(pyenv init --path)"
