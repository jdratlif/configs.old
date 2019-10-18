#! /bin/sh

################################################################################
# paths to programs used

CHMOD=/bin/chmod
CP=/bin/cp
GIT=/usr/bin/git
GREP=/bin/grep
HOSTNAME=/bin/hostname
MKDIR=/bin/mkdir
MKTEMP=/bin/mktemp
RM=/bin/rm
SUDO=/usr/bin/sudo
TOUCH=/bin/touch

################################################################################
# global variables

HOST=$($HOSTNAME -s)

TEMP_DIR=$($MKTEMP -d)
GIT_DIR="${TEMP_DIR}/configs"

################################################################################
# start of script

if [ ! -x $GIT ]; then
    # we don't have git, bailout!
    exit 1
fi

# clone this repo so we can get files
$GIT clone https://github.com/jdratlif/configs.git $GIT_DIR 2> /dev/null

# bash

if [ -f /etc/redhat-release ]; then
    # test for RedHat/CentOS > 5
    $GREP 'release [678]' /etc/redhat-release > /dev/null

    if [ $? -eq 0 ]; then
        $CP -f $GIT_DIR/bash/rhel/bash.bashrc ~/.bashrc
        $CP -f $GIT_DIR/bash/rhel/bash.profile ~/.bash_profile
    fi
elif [ -f /etc/debian_version ]; then
    $CP -f $GIT_DIR/bash/debian/bash.bashrc ~/.bashrc
    $CP -f $GIT_DIR/bash/debian/bash.profile ~/.profile
    $CP -f $GIT_DIR/bash/debian/bash_aliases.sh ~/.bash_aliases
fi

# dircolors

if [ -f /etc/redhat-release ]; then
    $CP -f $GIT_DIR/dircolors/rhel/dircolors ~/.dircolors
fi

# git

GITCONFIG_DIR="${GIT_DIR}/git/${HOST}"

if [ -d $GITCONFIG_DIR ]; then
    $CP -f $GITCONFIG_DIR/gitconfig ~/.gitconfig
else
    $CP -f $GIT_DIR/git/common/gitconfig ~/.gitconfig
fi

# i3 configs

BASE="${GIT_DIR}/i3/${HOST}"

if [ -d $BASE ]; then
    I3BASE="${HOME}/.config/i3"

    $MKDIR $I3BASE 2> /dev/null
    $CP -f $BASE/i3.conf $I3BASE/config
    $CP -f $BASE/i3status.conf $HOME/.i3status.conf
fi

# qterminal

QTERMINAL="${GIT_DIR}/qterminal/${HOST}.ini"

if [ -f $QTERMINAL ]; then
    $CP -f $QTERMINAL $HOME/.config/qterminal.org/qterminal.ini
fi

# perltidy

$CP -f $GIT_DIR/perltidy/perltidyrc $HOME/.perltidyrc

# SSH

SSH_DIR=$HOME/.ssh

if [ ! -d $SSH_DIR ]; then
    $MKDIR $SSH_DIR
    $CHMOD 700 $SSH_DIR
fi

# SSH config

SSH_CONFIG="${GIT_DIR}/ssh/config/${HOST}"

if [ -f $SSH_CONFIG ]; then
    SSH_CONFIG_FILE="${SSH_DIR}/config"
    $CP -f $SSH_CONFIG $SSH_CONFIG_FILE
    $CHMOD 0600 $SSH_CONFIG_FILE
fi

# SSH authorized keys

SSH_AUTH_KEYS="${GIT_DIR}/ssh/authorized_keys/${HOST}"

if [ -f $SSH_AUTH_KEYS ]; then
    SSH_AUTH_KEYS_FILE="${SSH_DIR}/authorized_keys"
    $CP -f $SSH_AUTH_KEYS $SSH_AUTH_KEYS_FILE
    $CHMOD 0600 $SSH_AUTH_KEYS_FILE
fi

# tmux

TMUX_CONF="${GIT_DIR}/tmux/${HOST}"

if [ -f $TMUX_CONF ]; then
    $CP -f $TMUX_CONF $HOME/.tmux.conf
fi

# urxvt extensions

URXVT_DIR="${GIT_DIR}/urxvt/${HOST}"

if [ -d $URXVT_DIR ]; then
    URXVT_EXT_DIR="$HOME/.urxvt/ext"

    if [ ! -d $URXVT_EXT_DIR ]; then
        $MKDIR -p $URXVT_EXT_DIR 2> /dev/null
    fi

    $CP -f $URXVT_DIR/* $URXVT_EXT_DIR
fi

# vim

VIM_DIR="${GIT_DIR}/vim"

VIMRC=$VIM_DIR/common.vim

if [ -f "${VIM_DIR}/${HOST}.vim" ]; then
    VIMRC="${VIM_DIR}/${HOST}.vim"
fi

$CP -f $VIMRC $HOME/.vimrc

$RM -rf $HOME/.vim && $MKDIR $HOME/.vim
$CP $VIM_DIR/plugins/* $HOME/.vim/

# vnc

VNC_DIR="${GIT_DIR}/vnc/${HOST}"

if [ -d $VNC_DIR ]; then
    VNC_CFG_DIR="${HOME}/.vnc"

    if [ ! -d $VNC_CFG_DIR ]; then
        $MKDIR $VNC_CFG_DIR
    fi

    VNC_CFG_FILE="${VNC_CFG_DIR}/xstartup"
    $CP -f $VNC_DIR/xstartup.sh $VNC_CFG_FILE
    $CHMOD 755 $VNC_CFG_FILE
fi

# Xresources

XR_FILE="${GIT_DIR}/Xresources/${HOST}"

if [ -f $XR_FILE ]; then
    $CP -f $XR_FILE $HOME/.Xresources
fi

$TOUCH $HOME/.last-sync

################################################################################
# sudoers

# these won't work unattended, so we'll leave it out for now

# SUDOERS_DIR="${GIT_DIR}/sudoers.d/${HOST}"

# if [ -d $SUDOERS_DIR ]; then
#     $SUDO $CP -f $SUDOERS_DIR/* /etc/sudoers.d
# fi

# # sysctl

# SYSCTL_DIR="${GIT_DIR}/sysctl/${HOST}"

# if [ -d $SYSCTL_DIR ]; then
#     $SUDO $CP -f $SYSCTL_DIR/sysctl.conf /etc
# fi
################################################################################

################################################################################
# cleanup the temp files

$RM -rf $TEMP_DIR
