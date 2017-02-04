# Anthony's .bash_profile

# Set to anything to have tmux use ansifilter (if present) for logging
ANSIFILTER=
LOG_DIR=~/logs

# Pretty green prompt (opposite of our red root prompt)
export PS1='\[\e[0;49;90m\][\[\e[32m\]\u\[\e[0;49;90m\]@\[\e[1;49;32m\]\h\[\e[0;49;90m\]] \[\e[2;49;0m\] \w\[\e[90m\]\$\[\e[0m\] '

# Terminal stuff
# Uncomment to prevent terminal from 'freezing' on 'Ctrl+s'
#stty -ixon
# Allow any key to 'unfreeze' terminal when stopped by 'Ctrl+s'
stty ixany

## SSH Agent
if [[ -e ~/.ssh ]]; then
    # Start agent if not running or not valid
    if ! test $SSH_AUTH_SOCK; then
       eval $(ssh-agent -s)
    fi
    # Add our keys
    for key_file in ~/.ssh/*id_rsa; do
        ssh-add $key_file
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
    # Source bash-git-prompt module, if found
    if [[ -e ~/.bash-git-prompt/gitprompt.sh ]]; then
      export GIT_PROMPT_ONLY_IN_REPO=1
      export GIT_PROMPT_THEME=TruncatedPwd_WindowTitle_C1
      source ~/.bash-git-prompt/gitprompt.sh
    fi

    # TODO: Make this accept a nice comment, so we're not breaking the law
    alias my-git-commit="git add -A .; git commit -m 'undocumented'; git push origin master"
fi

