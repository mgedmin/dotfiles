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
export GPGKEY=9157445DE7A6D78F
export DEB_SIGN_KEYID=$GPGKEY       # for dpkg-buildpackage
export DEBSIGN_KEYID=$GPGKEY        # for debsign

# http://wiki.debian.org/UsingQuilt recommends this
export QUILT_PATCHES=debian/patches
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"

# my environment choices
if locale -a 2>/dev/null | grep -q lt_LT.utf8; then
  export LC_CTYPE=lt_LT.UTF-8
else
  export LC_CTYPE=C.UTF-8
fi
export EDITOR=vim
export VISUAL=vim

# my custom Python stuff
# export PIP_DOWNLOAD_CACHE=$HOME/.cache/pip -- not needed with pip 6
# export PIP_WHEEL_DIR=$HOME/.cache/wheels -- not needed with pip 7
# export PIP_FIND_LINKS=file://$PIP_WHEEL_DIR -- not needed with pip 7
# do 'pip wheel $name' to create a wheel in the cache so that subsequent
# 'pip install $name' will be faster

# my custom Go stuff
export GOPATH=~/gocode/

# offlineimap on my laptop puts mail here
test -d "$HOME/Mail/Home/INBOX/" && export MAIL="$HOME/Mail/Home/INBOX/"

# ~/bin is added to PATH in ~/.bashrc.path, but GUI sessions don't parse
# .bashrc.  Ubuntu's X sessions, however, do parse ~/.profile, so if I
# want to launch apps using Alt-F2, I need to add ~/bin to $PATH here
[ -f "$HOME/.bashrc.path" ] && . "$HOME/.bashrc.path"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
