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
    $CP -f $BASE/i3.conf $I3BASE
    $CP -f $BASE/i3status.conf $HOME/.i3status.conf
fi

# perltidy

$CP -f $GIT_DIR/perltidy/perltidyrc $HOME/.perltidyrc

# SSH config

SSH_CONFIG="${GIT_DIR}/ssh/config/${HOST}"

if [ -f $SSH_CONFIG ]; then
    SSH_DIR=$HOME/.ssh

    if [ ! -d $SSH_DIR ]; then
        $MKDIR $SSH_DIR
        $CHMOD 700 $SSH_DIR
    fi

    SSH_CONFIG_FILE="${SSH_DIR}/config"
    $CP -f $SSH_CONFIG $SSH_CONFIG_FILE
    $CHMOD 600 $SSH_CONFIG_FILE
fi

################################################################################
# sudoers

# THESE 2 won't work unattended, so I'm leaving it out for now

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

# tmux

TMUX_DIR="${GIT_DIR}/tmux/${HOST}"

if [ -d $TMUX_DIR ]; then
    $CP -f $TMUX_DIR/tmux.conf $HOME/.tmux.conf
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

$CP -f $VIM_DIR/vimrc.vim $HOME/.vimrc

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

if [ -d $XR_FILE ]; then
    $CP -f $XR_FILE $HOME/.Xresources
fi

$TOUCH $HOME/.last-sync

################################################################################
# cleanup the temp files

$RM -rf $TEMP_DIR
