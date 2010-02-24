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
    if [ -f "$HOME/.$fn" ]; then
        if cmp "$HOME/.$fn" "$HOME/dotfiles/$fn" > /dev/null; then
            echo "contents identical, replacing $HOME/.$fn with symlink"
            rm $HOME/.$fn
        else
            echo "files differ: $HOME/.$fn $HOME/dotfiles/$fn" 1>&2
            continue
        fi
    fi
    ln -s dotfiles/$fn $HOME/.$fn
done
