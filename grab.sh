#!/bin/bash
# assumes this directory is ~/dotfiles

usage="usage: $0 [-l]
options:
  -l    this is a local config file, for this hostname only
"

local=0
while getopts hl OPT; do
    case "$OPT" in
        h)
            printf "%s" "$usage"
            exit 0
            ;;
        l)
            local=1
            ;;
        *)
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

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
    case "$s" in
        *.local)
            printf "%s: forcing -l (local)\\n" "$arg"
            force_local=1
            ;;
        *)
            force_local=0
            ;;
    esac
    dotfile=$HOME/.$fn
    [[ $local -ne 0 || $force_local -ne 0 ]] && fn=$fn.$HOSTNAME
    target=dotfiles/$fn
    if [ -L "$dotfile" ] && [ "$(readlink "$dotfile")" = "$target" ]; then
        continue # already a symlink to the right place
    fi
    if [ -e "$HOME/$target" ]; then
        echo "$arg: ~/$target already exists" 1>&2
        rc=1
        continue
    fi
    mv -i "$dotfile" "$HOME/$target" || rc=1
    ln -s "$target" "$dotfile" || rc=1
    git add "$fn" || rc=1
done
exit $rc
