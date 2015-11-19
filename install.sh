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
        elif [ -f "/etc/skel/.$fn" ] && cmp "$HOME/.$fn" "/etc/skel/.$fn" > /dev/null; then
            echo "identical to /etc/skel/ version, replacing $HOME/.$fn with symlink"
            rm $HOME/.$fn
        else
            sha1sum=
            echo "contents differ, skipping: $HOME/.$fn $HOME/dotfiles/$fn" 1>&2
            continue
        fi
    fi
    ln -s dotfiles/$fn $HOME/.$fn
done
if [ -n "$BASH_VERSION" ] && [ -n "$PS1" ]; then
    # this looks like an interactive session, i.e. the user did
    #   . ~/dotfiles/install.sh
    # instead of
    #   ~/dotfiles/install.sh
    # so let's reload their .profile and .inputrc for convenience
    echo "reloading .profile"
    . ~/.profile
    echo "reloading .inputrc"
    bind -f ~/.inputrc
fi
