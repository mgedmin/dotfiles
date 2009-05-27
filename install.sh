#!/bin/sh
# assumes this directory is ~/dotfiles
for fn in .[a-z]*; do
    if [ "$fn" = ".svn" ]; then
        continue # don't fiddle with svn metadata!!!
    fi
    if [ -L "$HOME/$fn" ] && [ "`readlink $HOME/$fn`" = "dotfiles/$fn" ]; then
        continue # already a symlink to the right place
    fi
    ln -s dotfiles/$fn $HOME/
done
