# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

(( bashrc_start_time_ms = ${EPOCHREALTIME/[^0-9]/} / 1000 ))

source_bashrc_snippet() {
    local snippet=$HOME/$1
    if [ -f "$snippet" ]; then
        # shellcheck source=/dev/null
        . "$snippet"
    fi
}

# Add directories to $PATH if they're not there already
source_bashrc_snippet .bashrc.path

# Set up environment variables
source_bashrc_snippet .bashrc.vars

# Do this only if running interactively
if [ -n "$PS1" ]; then

    # My bash preferences
    source_bashrc_snippet .bashrc.options

    # History management
    source_bashrc_snippet .bashrc.history

    # Fix SDL
    source_bashrc_snippet .bashrc.sdl

    # Make less more friendly for non-text input files, see lesspipe(1)
    source_bashrc_snippet .bashrc.less

    # Enable color support of ls and grep
    source_bashrc_snippet .bashrc.colors

    # Enable tab-completion and other goodies in Python
    source_bashrc_snippet .bashrc.python

    # Remind me about any backgrounded screen/tmux sessions
    source_bashrc_snippet .bashrc.screen

    # Remind me that I've set up a proxy connection
    source_bashrc_snippet .bashrc.proxy

    # Alias definitions
    source_bashrc_snippet .bash_aliases

    # Enable programmable completion features
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
        fi
    fi

    # Bash prompt (should come after bash_completion)
    source_bashrc_snippet .bashrc.prompt

    # GNOME Terminal support
    source_bashrc_snippet .bashrc.vte

    # Set xterm title
    source_bashrc_snippet .bashrc.title
fi

# Load local stuff, if any (do this last so it can override any of the above)
source_bashrc_snippet .bashrc.local

# This bit should be the very last in the file
if [ -n "$PS1" ]; then
    (( bashrc_duration_ms = ${EPOCHREALTIME/[^0-9]/} / 1000 - bashrc_start_time_ms ))
    if [ $bashrc_duration_ms -ge 100 ]; then
        echo "bashrc took ${bashrc_duration_ms}ms"
    fi
    # .bashrc.title defines enable_title(), and it needs to be executed as the
    # very last thing in .bashrc to avoid title bar flashing all the .bashrc
    # commands when you open a new terminal
    if declare -f enable_title > /dev/null; then
        enable_title
    fi
fi
