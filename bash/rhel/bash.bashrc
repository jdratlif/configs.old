# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
PROMPT_COMMAND=my_prompt

my_prompt() {
    local exit_code="$?"

    PS1="(${exit_code}) \u@\H:\W \$"
}

export PAGER='less -X'
export LIBVIRT_DEFAULT_URI='qemu:///system'

# global aliases
alias aide_accept='sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db'
alias aide_nagios='sudo truncate -s0 /var/log/aide/aide.log'
alias aide_run='sudo aide --update | less -X'
alias aide_showlog='sudo cat /var/log/aide/aide.log'
alias fix_perms='find . -type f -exec chmod 644 {} \; ; find . -type d -exec chmod 755 {} \;'
alias ipt='sudo iptables --line-numbers -n -v -L'
alias mongo_ssl='MY_HOST=`hostname -f`; mongo --host $MY_HOST -u root -p `sudo cat /etc/mongo/mongodb_root_password` --ssl --sslPEMKeyFile /etc/mongo/${MY_HOST}.pem --sslCAFile /etc/mongo/ca-${MY_HOST}.crt --port'
alias myansible='source ~/myansible/bin/activate; export ANSIBLE_VAULT_PASSWORD_FILE=~/vault/areon-vault.pw ; cd ~/git/ansible'
alias p='sudo /opt/puppetlabs/puppet/bin/puppet agent --test'
alias p_environment='grep environment /etc/puppetlabs/puppet/puppet.conf | awk '\''{print $3}'\'
alias p_enabled='sudo test -f /opt/puppetlabs/puppet/cache/state/agent_disabled.lock; if test $? -eq 0; then echo "puppet is disabled"; sudo cat /opt/puppetlabs/puppet/cache/state/agent_disabled.lock | awk -F: '\''{print $2}'\'' | sed -e '\''s/["}]//g'\''; else echo "puppet is enabled"; fi'
alias p_lookup='sudo /opt/puppetlabs/puppet/bin/puppet lookup --merge deep --node'
alias p_force='sudo /opt/puppetlabs/puppet/bin/puppet agent -t --agent_disabled_lockfile=/nonexisting'
alias p_test='sudo /opt/puppetlabs/puppet/bin/puppet agent -t --noop --agent_disabled_lockfile=/nonexisting'
alias rpm5="=rpm --define='_gpg_name rpmbuild@grnoc.iu.edu'"
alias rpm6="rpm --define='_gpg_name syseng@grnoc.iu.edu'"
alias rpm7="rpm --define='_gpg_name globalnoc@iu.edu'"
alias socks5='ssh -D 17798 -S /tmp/.ssh-skip-socks5-jdratlif -M -fN skip.grnoc.iu.edu; export SOCKS5_PROXY="localhost:17798"'
alias socks5_kill='ssh -S /tmp/.ssh-skip-socks5-jdratlif -O exit skip.grnoc.iu.edu'
alias svim='sudo env HOME=~ vim'

HOSTNAME=$(/bin/hostname -s)
FQDN=$(/bin/hostname -f)

# host specific aliases
if [ $HOSTNAME == 'build-new' ]; then
    alias cd_secrets='cd /etc/puppetlabs/code/secrets'
elif [ $HOSTNAME == 'compute' ]; then
    export PATH="~/openstack-tools/bin:$PATH"
elif [ $HOSTNAME == 'skip' ]; then
    export PATH="$HOME/openssh/bin:$PATH"
elif [ $HOSTNAME == 'jdratlif-dev7' ]; then
    alias cd_telegraf='cd ~/go/src/github.com/influxdata/telegraf'
    alias logstash='sudo /usr/share/logstash/bin/logstash'
    alias ssh_laptop='AUTOSSH_POLL=30 AUTOSSH_LOGFILE=/tmp/autossh.log autossh -M 20000 -f -N laptop'
    alias ssh_xaiver='autossh -M 30000 -f -N xaiver'
    alias xrdb='xrdb -cpp /usr/bin/cpp'
fi

# use ssh-proxy if we are on a cloud compute node
echo $HOSTNAME | grep -E '^compute[0-9]?' > /dev/null

if [ $? -eq 0 ]; then
    # setup default openstack cli project/region
    export OS_PROJECT_NAME='ndca'

    echo $FQDN | grep -E '\.ctc\.' > /dev/null

    if [ $? -eq 0 ]; then
        export OS_REGION_NAME='CTC'
    else
        export OS_REGION_NAME='BLDC'
    fi

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

shopt -s histappend
