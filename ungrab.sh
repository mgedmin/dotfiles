#!/bin/bash
# assumes this directory is ~/dotfiles

usage="usage: $0 [-n] ~/.dotfile [...]

replaces symlinked dotfiles with regular files with the same content

options:
  -n    don't make any changes
"

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
        *)
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

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
        printf "%s: not a dotfile\\n" "$arg" 1>&2
        rc=1
        continue
    fi
    dotfile=$HOME/.$fn
    target=dotfiles/$fn
    if [ -L "$dotfile" ] && [ "$dotfile" -ef "$HOME/$target" ]; then
        # a symlink to the right place
        run rm "$dotfile" || rc=1
        run cp "$fn" "$dotfile" || rc=1
    else
        printf "%s: not a symlink to ~/dotfiles\\n" "$arg" 1>&2
        rc=1
        continue
    fi
done
exit $rc
