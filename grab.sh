#!/bin/sh
# assumes this directory is ~/dotfiles
cd ~/dotfiles/
rc=0
for arg; do
    s=${arg#$HOME/}
    fn=${s#.}
    if ! [ x".$fn" = x"$s" ]; then
        echo "$arg: not a dotfile" 1>&2
        rc=1
        continue
    fi
    if [ -L "$HOME/.$fn" ] && [ "`readlink $HOME/.$fn`" = "dotfiles/$fn" ]; then
        continue # already a symlink to the right place
    fi
    if [ -e "$HOME/dotfiles/$fn" ]; then
        echo "$arg: ~/dotfiles/$fn already exists" 1>&2
        rc=1
        continue
    fi
    mv -i $HOME/.$fn $HOME/dotfiles/$fn
    ln -s dotfiles/$fn $HOME/.$fn
    test -d .svn && svn add $HOME/dotfiles/$fn
    (cd $HOME/dotfiles && test -d .git && git add $fn)
done
exit $rc
