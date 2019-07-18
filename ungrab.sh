#!/bin/sh
# assumes this directory is ~/dotfiles
cd ~/dotfiles/ || exit 1
rc=0
for arg; do
    s=${arg#$HOME/}
    fn=${s#.}
    if ! [ x".$fn" = x"$s" ]; then
        echo "$arg: not a dotfile" 1>&2
        rc=1
        continue
    fi
    if [ -L "$HOME/.$fn" ] && [ "$(readlink "$HOME/.$fn")" = "dotfiles/$fn" ]; then
        # a symlink to the right place
        rm "$HOME/.$fn"
        cp "$fn" "$HOME/.$fn"
    else
        echo "$arg: not a symlink to ~/dotfiles" 1>&2
        rc=1
        continue
    fi
done
exit $rc
