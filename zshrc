# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/mg/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# added by mg
setopt sharehistory

autoload -U colors && colors
PS1="%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~ %{$reset_color%}%% "

bindkey "\e[5~" history-beginning-search-backward
bindkey "\e[6~" history-beginning-search-forward

if [ "$TERM" != "dumb" ]; then
    eval `dircolors -b`
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# from http://www.zsh.org/mla/users/2000/msg00685.html
##WORDCHARS=${WORDCHARS:s,/,,}
##WORDCHARS=

# from http://ubuntu.stackexchange.com/questions/1577/moving-from-bash-to-zsh
autoload select-word-style
select-word-style shell

REPORTTIME=10

# from http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss4.1
case $TERM in
    xterm*)
        precmd () { print -Pn "\e]0;%n@%m: %~\a" }
        # and from http://www.davidpashley.com/articles/xterm-titles-with-bash.html
        # slightly modified since I want the directory name there too
        preexec () { print -Pn "\e]0;$1 - %n@%m: %~\a" }
        ;;
esac

# from http://linuxinnovations.blogspot.com/2010/10/ultimate-tab-completion.html
command_not_found_handler() { /usr/lib/command-not-found "$1" }
zle_highlight=(default:bold)
bindkey '^[[Z' reverse-menu-complete
setopt interactivecomments

# from http://github.com/robbyrussell/oh-my-zsh/blob/master/lib/completion.zsh
zstyle ':completion:*:*:*:*:*' menu select

