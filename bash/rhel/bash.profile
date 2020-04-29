# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

export PATH=$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$PATH

if [ -x "/usr/local/bin/keychain" ]; then
    eval `/usr/local/bin/keychain --eval --agents ssh id_rsa`
fi
