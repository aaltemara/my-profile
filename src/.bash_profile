# Custom .bash_profile

## Functions
pathmunge() {
  if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      PATH=$PATH:$1
    else
      PATH=$1:$PATH
    fi
  fi
}

# Set to anything to have tmux use ansifilter (if present) for logging
ANSIFILTER=
LOG_DIR=~/logs


# Pretty green prompt (opposite of our red root prompt)
PS1='\[\e[0;49;90m\][\[\e[32m\]\u\[\e[0;49;90m\]@\[\e[1;49;32m\]\h\[\e[0;49;90m\]] \[\e[2;49;0m\] \w\[\e[90m\]\$\[\e[0m\] '

## Update PATH
[[ -e ~/bin ]] && pathmunge ~/bin

## SSH Agent
agent_socket=$(ls -1rt /tmp/ssh-*/agent* | tail -n 1)
if [[ -n $agent_socket ]]; then
    export SSH_AUTH_SOCK=$agent_socket
else
    eval $(ssh-agent -s)
fi

## SSH Keys
if [[ -e ~/.ssh ]]; then
    # Add our keys, if not already added
    for key_file in ~/.ssh/*id_rsa; do
        if ! ssh-add -l | grep -q /$(basename $key_file); then
            echo "Adding $key_file to our ssh-agent"
            ssh-add $key_file
        #else
        #    echo "$key_file is already in our ssh-agent. Not adding."
        fi
    done
fi

## Vim
if which vim &>/dev/null; then
    alias vi=vim
    alias realvi=/usr/bin/vi

    if [[ -e ~/.vim/bundle/tmux-config/tmux-autowrite/autowrite-vim.sh ]]; then
        . ~/.vim/bundle/tmux-config/tmux-autowrite/autowrite-vim.sh
    fi
fi

## Tmux
if which tmux &>/dev/null; then
    # We're in a tmux session
    if [[ -n $TMUX ]]; then
	    mkdir -p $LOG_DIR/tmux
	    logfile="$LOG_DIR/tmux/$(date +'%Y%m%d%H%M%S')-$(hostname -s)-$TMUX_PANE".log
	    if [[ -n $ANSIFILTER ]] && which ansifilter &>/dev/null; then
	    tmux pipe-pane -o "cat | ansifilter >> $logfile"
            else
	    tmux pipe-pane -o "cat >> $logfile"
	    fi
    else
	    if tmux list-sessions | grep -vq attached; then
		    echo "Detached tmux sessions found. Attaching."
		    tmux attach
	    elif tmux list-sessions | grep -q created; then
		    echo "Existing tmux sessions found. Not creating a new session."
		    tmux list-sessions
	    else
		    echo "No tmux sessions found. Creating a new session."
		    tmux
	    fi
    fi
fi

## git
if which git &>/dev/null; then
    # TODO: Make this accept a nice comment, so we're not breaking the law
    alias my-git-commit="git add -A .; git commit -m 'undocumented'; git push origin master"
fi

# Source .bashrc
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
