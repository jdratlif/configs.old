# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export LIBVIRT_DEFAULT_URI='qemu:///system'

# global aliases
alias aide_accept='sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db'
alias aide_nagios='sudo truncate -s0 /var/log/aide/aide.log'
alias aide_run='sudo aide --update | less -X'
alias aide_showlog='sudo cat /var/log/aide/aide.log'
alias fix_perms='find . -type f -exec chmod 644 {} \; ; find . -type d -exec chmod 755 {} \;'
alias ipt='sudo iptables --line-numbers -n -v -L'
alias p='sudo /opt/puppetlabs/puppet/bin/puppet agent --test'
alias p_environment='grep environment /etc/puppetlabs/puppet/puppet.conf | awk '\''{print $3}'\'
alias p_enabled='sudo test -f /opt/puppetlabs/puppet/cache/state/agent_disabled.lock; if test $? -eq 0; then echo "puppet is disabled"; sudo cat /opt/puppetlabs/puppet/cache/state/agent_disabled.lock | awk -F: '\''{print $2}'\'' | sed -e '\''s/["}]//g'\''; else echo "puppet is enabled"; fi'
alias p_lookup='sudo /opt/puppetlabs/puppet/bin/puppet lookup --merge deep --node'
alias p_test='sudo /opt/puppetlabs/puppet/bin/puppet agent -t --noop --agent_disabled_lockfile=/nonexisting'
alias rpm5="=rpm --define='_gpg_name rpmbuild@grnoc.iu.edu'"
alias rpm6="rpm --define='_gpg_name syseng@grnoc.iu.edu'"
alias rpm7="rpm --define='_gpg_name globalnoc@iu.edu'"
alias socks5='ssh -D 17798 -S /tmp/.ssh-skip-socks5-jdratlif -M -fN skip.grnoc.iu.edu; export SOCKS5_PROXY="localhost:17798"'
alias socks5_kill='ssh -S /tmp/.ssh-skip-socks5-jdratlif -O exit skip.grnoc.iu.edu'

HOSTNAME=$(/bin/hostname -s)

# host specific aliases
if [ $HOSTNAME == 'jdratlif-dev7' ]; then
    alias logstash='sudo /usr/share/logstash/bin/logstash'
    alias pyenv='source ~/venv/bin/activate'
    alias ssh_laptop='AUTOSSH_POLL=30 AUTOSSH_LOGFILE=/tmp/autossh.log autossh -M 20000 -f -N laptop'
    alias ssh_xaiver='autossh -M 30000 -f -N xaiver'
    alias cd_telegraf='cd ~/go/src/github.com/influxdata/telegraf'
    alias xrdb='xrdb -cpp /usr/bin/cpp'
fi

# use ssh-proxy if we are on a cloud compute node
echo $HOSTNAME | grep -E '^compute[0-9]?' > /dev/null

if [ $? -eq 0 ]; then
    alias cloud_auth='source /usr/local/bin/ecp-login'
    alias gcs='socks5 ; git config --global http.proxy socks5://127.0.0.1:17798 ; curl -x socks5://localhost:17798 https://raw.githubusercontent.com/jdratlif/configs/master/sync.sh | sh ; socks5_kill'
else
    alias gcs='curl https://raw.githubusercontent.com/jdratlif/configs/master/sync.sh | sh'
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
