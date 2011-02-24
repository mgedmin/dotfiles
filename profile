# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile
#umask 022

# my identity
export EMAIL=marius@gedmin.as
export DEBEMAIL=$EMAIL
export DEBFULLNAME="Marius Gedminas"
export GPGKEY=E7A6D78F

# my environment choices
export LC_CTYPE=lt_LT.UTF-8
export EDITOR=vim
export VISUAL=vim

export PYTHONPATH=$HOME/py-lib
export PIP_DOWNLOAD_CACHE=$HOME/.cache/pip

test -d $HOME/Mail/Home/INBOX/ && export MAIL=$HOME/Mail/Home/INBOX/

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f ~/.bashrc ]; then
	. ~/.bashrc
    fi
fi

# vim: ft=sh:
