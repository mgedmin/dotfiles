#!/bin/bash
# assumes this directory is ~/dotfiles

pushd ~/dotfiles/ > /dev/null || exit 1
git pull -q -r
. ./install.sh "$@"
popd > /dev/null || exit 1
