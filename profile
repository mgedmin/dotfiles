# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# my locale please
if locale -a 2>/dev/null | grep -q lt_LT.utf8; then
    export LC_CTYPE=lt_LT.UTF-8
elif locale -a 2>/dev/null | grep -q C.UTF-8; then
    export LC_CTYPE=C.UTF-8
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        # shellcheck source=.bashrc
        . "$HOME/.bashrc"
    fi
else
    # ~/bin is added to PATH in ~/.bashrc.path, but GUI sessions don't parse
    # .bashrc.  Ubuntu's X sessions, however, do parse ~/.profile (but they
    # don't use bash to do it), so if I want to launch apps using Alt-F2, I
    # need to add ~/bin to $PATH here
    if [ -f "$HOME/.bashrc.path" ]; then
        # shellcheck source=.bashrc.path
        . "$HOME/.bashrc.path"
    fi
    if [ -f "$HOME/.bashrc.vars" ]; then
        # shellcheck source=.bashrc.vars
        . "$HOME/.bashrc.vars"
    fi
fi
