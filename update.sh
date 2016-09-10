#!/bin/bash
# assumes this directory is ~/dotfiles
cd ~/dotfiles/
git pull -q -r
. ./install.sh "$@"
