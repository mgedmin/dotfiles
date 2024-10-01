#!/bin/bash
# assumes this directory is ~/dotfiles

usage="usage: $0 [-n] [-v] [-f]
options:
  -n    don't make any changes
  -v    be more verbose (repeat for extra verbosity)
  -f    force install even if files already exist (will rename to .old)
"

verbose=0
dry_run=0
force=0
while getopts hvnf OPT; do
    case "$OPT" in
        h)
            printf "%s" "$usage"
            exit 0
            ;;
        n)
            dry_run=1
            ;;
        v)
            verbose=$((verbose + 1))
            ;;
        f)
            force=$((force + 1))
            ;;
        *)
            printf '%s: unknown option %s\n' "$0" "$OPT" 1>&2
            exit 1
            ;;
    esac
done

hostname=${HOSTNAME%%.*}

# busybox ln doesn't support -r and we'll have to use absolute symlinks
ln_dash_r=
if ln --help |& grep -q -e '-r'; then
    ln_dash_r=-r
fi

emit() { local lvl=$1; shift; [ $verbose -ge "$lvl" ] && printf '%s\n' "$*"; }
info() { emit 1 "$*"; }
debug() { emit 2 "$*"; }

run() {
    if [ $dry_run -eq 0 ]; then
        "$@"
    else
        printf '%s\n' "$*"
    fi
}

process() {
    local dotfile=$1
    local target=$2
    local skeleton=$3
    local dir
    dir=$(dirname "$dotfile")

    if [ -L "$dotfile" ] && [ "$dotfile" -ef "$HOME/$target" ]; then
        debug "already exists: $dotfile -> $target"
        return # already a symlink to the right place
    fi
    if [ -f "$dotfile" ]; then
        if cmp "$dotfile" "$HOME/$target" > /dev/null; then
            echo "contents identical, replacing $dotfile with symlink"
            run rm "$dotfile"
        elif [ -f "$skeleton" ] && cmp "$dotfile" "$skeleton" > /dev/null; then
            echo "identical to /etc/skel/ version, replacing $dotfile with symlink"
            run rm "$dotfile"
        elif [ $force -ge 1 ]; then
            if ! [ -e "$dotfile.old" ]; then
                echo "forcefully replacing $dotfile, old version saved as $dotfile.old"
                run mv "$dotfile" "$dotfile.old"
            else
                echo "contents differ, skipping: $dotfile $HOME/$target (ignoring -f because $dotfile.old exists)" 1>&2
                return
            fi
        else
            # print both files with a space so I can easily copy them
            # together and paste as arguments to vimdiff
            echo "contents differ, skipping: $dotfile $HOME/$target" 1>&2
            return
        fi
    else
        info "$dotfile -> $target"
    fi
    if ! [ -d "$dir" ]; then
        run mkdir -p "$dir"
    fi
    run ln -s $ln_dash_r "$HOME/$target" "$dotfile"
}

process_dir() {
    local prefix="$1"
    local fn
    for fn in "$prefix"[a-z]*; do
        if [ -d "$fn" ]; then
            process_dir "$fn/"
        else
            local dotfile=$HOME/.$fn
            local target=dotfiles/$fn
            local skeleton=/etc/skel/.$fn
            case "$fn" in
                *.local.$HOSTNAME|mailcheckrc.$HOSTNAME)
                    dotfile=$HOME/.${fn%.$HOSTNAME}
                    ;;
                *.local.$hostname|mailcheckrc.$hostname)
                    dotfile=$HOME/.${fn%.$hostname}
                    ;;
                *.sh|*.local.*|mailcheckrc.*|core|core.*)
                    debug "skipping $fn"
                    continue # ignore
                    ;;
                *)
                    ;;
            esac
            process "$dotfile" "$target" "$skeleton"
        fi
    done
}

if [ "$hostname" = localhost ] && [ -n "$TERMUX_VERSION" ]; then
    hostname=termux
    debug "detected termux, overriding hostname to $hostname"
fi

pushd ~/dotfiles/ > /dev/null || exit 1
process_dir ""
popd > /dev/null || exit 1
