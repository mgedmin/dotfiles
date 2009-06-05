#!/bin/sh
ssh fridge svn up ~/dotfiles '&&' svn export --force '~/dotfiles/' '~/www/dotfiles/'
