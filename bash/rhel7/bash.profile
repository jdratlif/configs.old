# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

export PATH=$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$PATH

if [ -x "/usr/local/keychain/keychain" ]; then
    eval `/usr/local/keychain/keychain --eval --agents ssh id_rsa`
fi
