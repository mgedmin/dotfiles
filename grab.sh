#!/bin/bash
# assumes this directory is ~/dotfiles

usage="usage: $0 [-l] [-n] ~/.dotfile [...]

moves specified dotfiles into ~/dotfiles/ and replaces them with symlinks

options:
  -l    this is a local config file, for this hostname only
  -n    don't make any changes
"

local=0
dry_run=0
while getopts hnl OPT; do
    case "$OPT" in
        h)
            printf "%s" "$usage"
            exit 0
            ;;
        n)
            dry_run=1
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

# busybox ln doesn't support -r and we'll have to use absolute symlinks
ln_dash_r=
if ln --help |& grep -q -e '-r'; then
    ln_dash_r=-r
fi

run() {
    if [ $dry_run -eq 0 ]; then
        "$@"
    else
        printf '%s\n' "$*"
    fi
}

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
    if [ -L "$dotfile" ] && [ "$dotfile" -ef "$HOME/$target" ]; then
        continue # already a symlink to the right place
    fi
    if [ -e "$HOME/$target" ]; then
        echo "$arg: ~/$target already exists" 1>&2
        rc=1
        continue
    fi
    dir=$(dirname "$HOME/$target")
    if ! [ -d "$dir" ]; then
        run mkdir -p "$dir" || rc=1
    fi
    run mv -i "$dotfile" "$HOME/$target" || rc=1
    run ln -s $ln_dash_r "$HOME/$target" "$dotfile" || rc=1
    run git add "$fn" || rc=1
done
exit $rc
