#!/bin/bash
# assumes this directory is ~/dotfiles

local=0
while getopts l OPT; do
    case "$OPT" in
        l)
            local=1
            ;;
        *)
            printf "%s: unknown option %s\n" "$0" "$OPT" 1>&2
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

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
    dotfile=$HOME/.$fn
    [ $local -ne 0 ] && fn=$fn.$HOSTNAME
    target=dotfiles/$fn
    if [ -L "$dotfile" ] && [ "$(readlink $dotfile)" = "$target" ]; then
        continue # already a symlink to the right place
    fi
    if [ -e "$HOME/$target" ]; then
        echo "$arg: ~/$target already exists" 1>&2
        rc=1
        continue
    fi
    mv -i $dotfile $HOME/$target
    ln -s $target $dotfile
    test -d .svn && svn add $HOME/$target
    (cd $HOME/dotfiles && test -d .git && git add $fn)
done
exit $rc
