# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/jdratlif/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="simonoff"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

# setup vi key bindings
bindkey -v

export EDITOR=vim
export LIBVIRT_DEFAULT_URI='qemu:///system'

# global aliases
alias aide_accept='sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db'
alias aide_nagios='sudo truncate -s0 /var/log/aide/aide.log'
alias aide_run='sudo aide --update | less -X'
alias aide_showlog='sudo cat /var/log/aide/aide.log'

alias fix_perms='find . -type f -exec chmod 644 {} \; ; find . -type d -exec chmod 755 {} \;'

alias ipt='sudo iptables --line-numbers -n -v -L'

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

# host specific configs
if [ $HOSTNAME == 'build-new' ]; then
    alias cd_secrets='cd /etc/puppetlabs/code/secrets'
elif [ $HOSTNAME == 'skip' ]; then
    export PATH="$HOME/openssh/bin:$PATH"
elif [ $HOSTNAME == 'jdratlif-dev7' ]; then
    alias ssh_laptop='autossh -M 20000 -f -N laptop'
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
