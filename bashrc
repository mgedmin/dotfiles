# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Add directories to $PATH if they're not there already
echo :$PATH:|grep -q :/usr/local/bin:	|| PATH=/usr/local/bin:$PATH
echo :$PATH:|grep -q :/usr/local/sbin:	|| PATH=/usr/local/sbin:$PATH
echo :$PATH:|grep -q :/usr/games:	|| PATH=$PATH:/usr/games
echo :$PATH:|grep -q :$HOME/bin:	|| PATH=$HOME/bin:$PATH
export PATH

# Define some aliases
alias sb-login=/scratchbox/login

# Load local stuff, if any
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

# If not running interactively, don't do anything else
[ -z "$PS1" ] && return

# Development
export IVIJA_ROOT=svn+ssh://fridge/svn/ivija
export ZOPE_ROOT=svn+ssh://svn.zope.org/repos/main

# Enable tab-completion in python
test -f ~/.python && export PYTHONSTARTUP=~/.python

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# Big history (note: big ~/.bash_history costs in startup time)
export HISTFILESIZE=5000
export HISTSIZE=5000

# Don't overwrite the history file (and wipe the history of other xterms)
shopt -s histappend

# Kobodl hangs on exit holding the X server lock unless I do this
export SDL_AUDIODRIVER=pulse

# disable history expansion (!)
set +H

# checkwinsize: check the window size after each command and, if necessary,
#   update the values of LINES and COLUMNS.
# globstar: enable ** expansion
shopt -s checkwinsize globstar

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval `dircolors -b`
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# check for screen sessions
if [ -d /var/run/screen/S-$USER/ ]; then
    n=$(find  /var/run/screen/S-$USER/ -type p|wc -l)
    if [ $n -gt 0 ]; then
        test x"$TERM" = xscreen \
            && echo "You have $n active screen sessions (and this is one of them)." \
            || echo "You have $n active screen sessions."
    fi
fi

# remind me that I've set up a proxy connection; because having it on
# will break empathy without any clues as to why it fails to work
if [ -x /usr/bin/gconftool -a x"$(gconftool -g /system/proxy/mode)" != x"none" ]; then
    echo "You have a proxy server enabled."
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# If the above slows down bash startup too much, try this cut-down version:
##if [ -f ~/.bash_completion.short ]; then
##    . ~/.bash_completion.short
##fi

# set variable identifying the chroot you work in
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# A color and a non-color prompt:    
#PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w \$ '

# Comment in the above and uncomment this below for a color prompt
reset='\[\033[0m\]'
red='\[\033[0;31m\]'
green='\[\033[0;32m\]'
blue='\[\033[0;34m\]'
purple='\[\033[0;35m\]'
chroot='${debian_chroot:+($debian_chroot)}'
git='$(__git_ps1 " [%s]")'
PS1="\n${chroot}${green}\u@\h${reset}:${blue}\w${purple}${git}${reset} \$ "

# Save the history after every command
PROMPT_COMMAND='history -a'

# Note to self: use 'history -an' to load the history
# Source: http://briancarper.net/blog/248/

# If this is an xterm set the title to user@host:dir, except when we're running under Midnight Commander
if [ -z "$MC_SID" ]; then
    case "$TERM" in
    xterm*|rxvt*)
        PROMPT_COMMAND='__rc="rc=$? "; echo -ne "\033]0;${__rc/rc=0 /}${USER}@${HOSTNAME}: ${PWD}\007"; history -a'

        # Show the currently running command in the terminal title:
        # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
        # Note that this breaks the use of $_ in interactive shell sessions,
        # so get into the habit of using M-.
        show_command_in_title_bar()
        {
            case "$BASH_COMMAND" in
                *\033]0*)
                    # The command is trying to set the title bar as well;
                    # this is most likely the execution of $PROMPT_COMMAND.
                    # In any case nested escapes confuse the terminal, so don't
                    # output them.
                    ;;
                *\033*|*\007*|*\\e*)
                    # actually just avoid escapes of any kind in the title
                    ;;
                history\ -a)
                    # this is $PROMPT_COMMAND again, most likely
                    ;;
                *)
                    echo -ne "\033]0;${BASH_COMMAND} - ${USER}@${HOSTNAME}: ${PWD}\007"
                    ;;
            esac
        }
        trap show_command_in_title_bar DEBUG
        ;;
    *)
        ;;
    esac
fi
# show_command_in_title_bar should be the last thing in this file
