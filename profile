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
export DEB_SIGN_KEYID=$GPGKEY       # for debhelper
export DEBSIGN_KEYID=$GPGKEY        # for debsign

# http://wiki.debian.org/UsingQuilt recommends this
export QUILT_PATCHES=debian/patches
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"

# my environment choices
export LC_CTYPE=lt_LT.UTF-8
export EDITOR=vim
export VISUAL=vim

# my custom Python stuff
export PIP_DOWNLOAD_CACHE=$HOME/.cache/pip
export PIP_WHEEL_DIR=$HOME/.cache/wheels
export PIP_FIND_LINKS=file://$PIP_WHEEL_DIR
# do 'pip wheel $name' to create a wheel in the cache so that subsequent
# 'pip install $name' will be faster

# offlineimap on my laptop puts mail here
test -d $HOME/Mail/Home/INBOX/ && export MAIL=$HOME/Mail/Home/INBOX/

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# ~/bin is added to PATH in ~/.bashrc.path, but GUI sessions don't parse
# .bashrc.  Ubuntu's X sessions, however, do parse ~/.profile, so if I
# want to launch apps using Alt-F2, I need to add ~/bin to $PATH here
PATH="$HOME/bin:$HOME/.venv/bin:$HOME/.local/bin:$PATH"
