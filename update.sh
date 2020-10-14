#!/bin/bash
# assumes this directory is ~/dotfiles

pushd ~/dotfiles/ > /dev/null && {
    git pull -q -r && . ./install.sh "$@"
    # shellcheck disable=SC2164
    popd > /dev/null
}
