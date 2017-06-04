alias emacs='emacs-25.2 -nw'

#coloed expression for ls -la
export LSCOLORS=gxfxcxdxbxegedabagacad
export PATH=/Developer/NVIDIA/CUDA-7.5/BIN:$PATH
export DYLD_LIBRARY_PATH=/Developer/NVIDIA/CUDA-7.6/lib:$DYLD_LIBRARY_PATH
export PATH=/opt/local/bin:$PATH
export LD_LIBRARY_PATH=/opt/local/lib:$PATH

# python
source /Users/hiroki/.pyenv/versions/anaconda3-4.0.0/bin/activate py3_personal
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="$PYENV_ROOT/versions/anaconda3-4.0.0/bin/:$PATH"
export PATH="$PYENV_ROOT/versions/anaconda3-4.0.0/env/:$PATH"

alias ll='ls -laG'
alias ls='ls -G'

alias grep='grep --color'
alias df='df -h'
alias ps='ps --sort=start_time'

export RBENV_ROOT="${HOME}/.rbenv"
if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
