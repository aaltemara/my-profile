# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source extra .bashrc includes
if [ -d ~/.bashrc.d ]; then
    for f in ~/.bashrc.d/*; do
        [[ -f $f ]] && . $f
    done
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

alias fixssh='eval $(tmux showenv -s SSH_AUTH_SOCK)'
export EDITOR=vim
export HISTSIZE=10000
