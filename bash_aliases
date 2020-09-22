# Bash aliases

# I don't have a pip, but I have a ~/bin/python that runs python3
alias pip='python -m pip'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# wow
# such commit
# very push
# -- https://twitter.com/chris__martin/status/420992421673988096
alias wow='git status'
alias such=git
alias very=git

# no config file/environment for this
alias exa='exa --group-directories-first'

# hide squashfs mounts please, my ubuntu has so many
alias lsblk='lsblk -e 7'

# pipx install thefuck, and I already forgot what it does.
function fuck () {
    TF_PYTHONIOENCODING=$PYTHONIOENCODING;
    export TF_SHELL=bash;
    export TF_ALIAS=fuck;
    export TF_SHELL_ALIASES=$(alias);
    export TF_HISTORY=$(fc -ln -10);
    export PYTHONIOENCODING=utf-8;
    TF_CMD=$(
        thefuck THEFUCK_ARGUMENT_PLACEHOLDER "$@"
    ) && eval "$TF_CMD";
    unset TF_HISTORY;
    export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
    history -s $TF_CMD;
}

# vim: ft=sh
