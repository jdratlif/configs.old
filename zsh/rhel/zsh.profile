if [[ -x "/usr/local/bin/keychain" ]]; then
    eval `/usr/local/bin/keychain --eval --agents ssh id_rsa`
fi
