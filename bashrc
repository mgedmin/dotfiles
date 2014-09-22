# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

[ -f /etc/bashrc ] && . /etc/bashrc

# Add directories to $PATH if they're not there already
[ -f ~/.bashrc.path ] && . ~/.bashrc.path

# Load local stuff, if any
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

# If not running interactively, don't do anything else
[ -z "$PS1" ] && return


# My bash preferences
[ -f ~/.bashrc.options ] && . ~/.bashrc.options

# History management
[ -f ~/.bashrc.history ] && . ~/.bashrc.history

# Fix SDL
[ -f ~/.bashrc.sdl ] && . ~/.bashrc.sdl

# Make less more friendly for non-text input files, see lesspipe(1)
[ -f ~/.bashrc.less ] && . ~/.bashrc.less

# Enable color support of ls and grep
[ -f ~/.bashrc.colors ] && . ~/.bashrc.colors

# Enable tab-completion and other goodies in Python
[ -f ~/.bashrc.python ] && . ~/.bashrc.python

# Remind me about any backgrounded screen/tmux sessions
[ -f ~/.bashrc.screen ] && . ~/.bashrc.screen

# Remind me that I've set up a proxy connection
[ -f ~/.bashrc.proxy ] && . ~/.bashrc.proxy

# Alias definitions
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# Enable programmable completion features
[ -f /etc/bash_completion ] && ! shopt -oq posix && . /etc/bash_completion

# Bash prompt (should come after bash_completion)
[ -f ~/.bashrc.prompt ] && . ~/.bashrc.prompt

# GNOME Terminal support
[ -f ~/.bashrc.vte ] && . ~/.bashrc.vte

# Set xterm title (should be the last thing in this file)
[ -f ~/.bashrc.title ] && . ~/.bashrc.title
