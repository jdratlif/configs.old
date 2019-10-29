# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export LIBVIRT_DEFAULT_URI="qemu:///system"

# global aliases
alias ipt="sudo iptables --line-numbers -n -v -L"
alias gcs='curl https://raw.githubusercontent.com/jdratlif/configs/master/sync.sh | sh'
alias puppet="sudo puppet agent --test"
alias rpm5="rpm --define='_gpg_name rpmbuild@grnoc.iu.edu'"
alias rpm6="rpm --define='_gpg_name syseng@grnoc.iu.edu'"
alias rpm7="rpm --define='_gpg_name globalnoc@iu.edu'"

HOSTNAME=$(/bin/hostname -s)

# host specific aliases
if [ $HOSTNAME == "jdratlif-dev7" ]; then
    alias logstash='sudo /usr/share/logstash/bin/logstash'
    alias pyenv='source ~/venv/bin/activate'
    alias ssh_laptop='ssh -f -N laptop'
    alias ssh_xaiver='ssh -f -N xaiver'
    alias xrdb='xrdb -cpp /usr/bin/cpp'
fi

# use vi line editing mode
set -o vi
bind -m vi-insert "\C-l":clear-screen

# history options
export HISTTIMEFORMAT="%h %d %H:%M:%S "
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL="ignorespace:erasedups"

if [ -z ${PROMPT_COMMAND+x} ]; then
    export PROMPT_COMMAND="history -a"
else
    export PROMPT_COMMAND="$PROMPT_COMMAND; history -a"
fi

shopt -s histappend
shopt -s cmdhist
