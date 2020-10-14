#!/bin/bash
# assumes this directory is ~/dotfiles

~/dotfiles/do_install.sh "$@" && \
if [ -n "$BASH_VERSION" ] && [ -n "$PS1" ] && ! grep -q n <<<"$*"; then
    # (the weird grep -q n checking for -n on the command line)
    # this looks like an interactive session, i.e. the user did
    #   . ~/dotfiles/install.sh
    # instead of
    #   ~/dotfiles/install.sh
    # so let's reload their .profile and .inputrc for convenience
    echo "reloading .profile"
    # shellcheck source=/dev/null
    . ~/.profile
    echo "reloading .inputrc"
    bind -f ~/.inputrc
fi
