# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

alias sb-login=/scratchbox/login

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Development
export IVIJA_ROOT=svn+ssh://fridge/svn/ivija
export ZOPE_ROOT=svn+ssh://svn.zope.org/repos/main

# Enable tab-completion in python
export PYTHONSTARTUP=~/.python

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# Big history (note: big ~/.bash_history costs in startup time)
export HISTFILESIZE=5000
export HISTSIZE=5000

# disable history expansion (!)
set +H

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc).
if [ -f ~/.bash_completion.short ]; then
    . ~/.bash_completion.short
fi

# set variable identifying the chroot you work in
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# A color and a non-color prompt:    
#PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w \$ '

# Comment in the above and uncomment this below for a color prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[0;32m\]\u@\h\[\033[00m\]:\[\033[0;34m\]\w\[\033[00m\] \$ '

# If this is an xterm set the title to user@host:dir, except when we're running under Midnight Commander
if [ -z "$MC_SID" ]; then
    case "$TERM" in
    xterm*|rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

        # Show the currently running command in the terminal title:
        # http://www.davidpashley.com/articles/xterm-titles-with-bash.html
        # Note that this breaks the use of $_ in interactive shell sessions :-/
        show_command_in_title_bar()
        {
            case "$BASH_COMMAND" in
                *\033]0*)
                    # The command is trying to set the title bar as well;
                    # this is most likely the execution of $PROMPT_COMMAND.
                    # In any case nested escapes confuse the terminal, so don't
                    # output them.
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

# check for screen sessions
if [ -d /var/run/screen/S-mg/ ]; then
    n=`find  /var/run/screen/S-mg/ -type p|wc -l`
    if [ $n -gt 0 ]; then
        test x"$TERM" = xscreen \
            && echo "You have $n active screen sessions (and this is one of them)." \
            || echo "You have $n active screen sessions."
    fi
fi
