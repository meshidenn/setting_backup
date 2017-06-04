if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

[ -f "$HOME/.profile" ] && source "$HOME/.profile"
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"

eval $(ssh-agent)

function cleanup {
    echo "Killing SSH-Agent" 
    kill -9 $SSH_AGENT_PID
    }

#export PATH=/usr/local/bin:$PATH
export PATH="$HOME/.pyenv/shims:$PATH"

