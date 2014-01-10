# Bash aliases

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

# vim: ft=sh
