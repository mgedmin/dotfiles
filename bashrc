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

# Kobodl hangs on exit holding the X server lock unless I do this
export SDL_AUDIODRIVER=pulse

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
# (otherwise we would lose history of other xterms)
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=5000
# note: big ~/.bash_history costs in startup time

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# disable history expansion (!)
set +H

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# check for screen sessions
if [ -d /var/run/screen/S-$USER/ ]; then
    n=$(find  /var/run/screen/S-$USER/ -type p|wc -l)
    if [ $n -gt 0 ]; then
        test x"$TERM" = xscreen && test -n "$WINDOW" \
            && echo "You have $n active screen sessions (and this is one of them)." \
            || echo "You have $n active screen sessions."
    fi
fi

# check for tmux sessions
if [ -x /usr/bin/tmux ]; then
    n=$(tmux list-sessions 2>/dev/null|wc -l)
    if [ $n -gt 0 ]; then
        test x"$TERM" = xscreen && test -n "$TMUX" \
            && echo "You have $n active tmux sessions (and this is one of them)." \
            || echo "You have $n active tmux sessions."
    fi
fi

# remind me that I've set up a proxy connection; because having it on
# will break empathy without any clues as to why it fails to work
if [ -x /usr/bin/gconftool ] && [ x"$(gconftool -g /system/proxy/mode)" != x"none" ]; then
    echo "You have a proxy server enabled."
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# If the above slows down bash startup too much, try this cut-down version:
##if [ -f ~/.bash_completion.short ]; then
##    . ~/.bash_completion.short
##fi

# svn branch name in shell prompt
# based on /etc/bash_completion.d/git and https://gist.github.com/657287
# (the latter is from http://edgar.tumblr.com/post/1449437754/show-ruby-version-and-svn-git-branch-in-prompt)
# oh and also http://hocuspokus.net/2009/07/add-git-and-svn-branch-to-bash-prompt/
__svn_ps1()
{
    if [ -d .svn ]; then
        local svn_info="$(svn info | egrep '^URL: ' 2> /dev/null)"
        local branch_pattern="^URL: .*/(branches|tags)/([^/]+)"
        local trunk_pattern="^URL: .*/trunk(/.*)?$"
        local branch=""
        if [[ ${svn_info} =~ $branch_pattern ]]; then
            branch=${BASH_REMATCH[2]}
        elif [[ ${svn_info} =~ $trunk_pattern ]]; then
            branch='trunk'
        fi
        printf -- "${1:- (%s)}" "$branch"
    fi
}

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
svn='$(__svn_ps1 " [%s]")'
git='$(__git_ps1 " [%s]")'
GIT_PS1_SHOWDIRTYSTATE=1  # adds * and/or + if there are changes
GIT_PS1_SHOWSTASHSTATE=1  # adds $ if something is stashed
GIT_PS1_SHOWSTASHSTATE=1  # adds % if there are untracked files
GIT_PS1_SHOWUPSTREAM="auto"  # < (behind) / > (ahead) / <> (diverged)
PS1="\n${chroot}${green}\u@\h${reset}:${blue}\w${purple}${svn}${git}${reset} \$ "

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
