#!/bin/bash
# assumes this directory is ~/dotfiles

verbose=0
while getopts v OPT; do
    case "$OPT" in
        v)
            verbose=$((verbose + 1))
            ;;
        *)
            printf "%s: unknown option %s\n" "$0" "$OPT" 1>&2
            exit 1
            ;;
    esac
done

emit() { local lvl=$1; shift; [ $verbose -ge $lvl ] && printf "%s\n" "$*"; }
info() { emit 1 "$*"; }
debug() { emit 2 "$*"; }

pushd ~/dotfiles/ > /dev/null || exit 1
for fn in [a-z]*; do
    dotfile=$HOME/.$fn
    target=dotfiles/$fn
    skeleton=/etc/skel/.$fn
    case "$fn" in
        *.local.$HOSTNAME)
            dotfile=$HOME/.${fn%.$HOSTNAME}
            ;;
        *.sh|*.local.*)
            debug "skipping $fn"
            continue # ignore
            ;;
        *)
            ;;
    esac
    if [ -L "$dotfile" ] && [ "$(readlink $dotfile)" = "$target" ]; then
        debug "already exists: $dotfile -> $target"
        continue # already a symlink to the right place
    fi
    if [ -f "$dotfile" ]; then
        if cmp "$dotfile" "$HOME/$targets" > /dev/null; then
            echo "contents identical, replacing $dotfile with symlink"
            rm $dotfile
        elif [ -f "$skeleton" ] && cmp "$dotfile" "$skeleton" > /dev/null; then
            echo "identical to /etc/skel/ version, replacing $dotfile with symlink"
            rm $dotfile
        else
            # print both files with a space so I can easily copy them
            # together and paste as arguments to vimdiff
            echo "contents differ, skipping: $dotfile $HOME/$target" 1>&2
            continue
        fi
    fi
    info "$dotfile -> $target"
    ln -s $target $dotfile
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
popd > /dev/null
