#!/bin/sh
# assumes this directory is ~/dotfiles
cd ~/dotfiles/
for fn in [a-z]*; do
    case "$fn" in
        *.sh)
            continue # ignore
            ;;
        *)
            ;;
    esac
    if [ -L "$HOME/.$fn" ] && [ "`readlink $HOME/.$fn`" = "dotfiles/$fn" ]; then
        continue # already a symlink to the right place
    fi
    if [ -L "$HOME/.$fn" ] && [ "`readlink $HOME/.$fn`" = "dotfiles/.$fn" ]; then
        # move old symlink to new one
        rm $HOME/.$fn
    fi
    ln -s dotfiles/$fn $HOME/.$fn
done
