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
    alias vnctunnel='ssh -f -N laptop'
    alias vncxaiver='autossh -M 20000 -f -N xaiver'
    alias xrdb='xrdb -cpp /usr/bin/cpp'
fi

set -o vi
bind -m vi-insert "\C-l":clear-screen
