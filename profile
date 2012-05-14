# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# my identity
export EMAIL=marius@gedmin.as
export DEBEMAIL=$EMAIL
export DEBFULLNAME="Marius Gedminas"
export GPGKEY=E7A6D78F

# http://wiki.debian.org/UsingQuilt recommends this
export QUILT_PATCHES=debian/patches
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"

# my environment choices
export LC_CTYPE=lt_LT.UTF-8
export EDITOR=vim
export VISUAL=vim

# my custom Python stuff
export PYTHONPATH=$HOME/py-lib
export PIP_DOWNLOAD_CACHE=$HOME/.cache/pip

# offlineimap on my laptop puts mail here
test -d $HOME/Mail/Home/INBOX/ && export MAIL=$HOME/Mail/Home/INBOX/

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
