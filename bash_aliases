# Bash aliases

# I don't have a pip, but I have a ~/bin/python that runs python3
alias pip='python -m pip'
alias pydoc='python -m pydoc'

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

#
# So I have ~/projects with a list of things I sometimes want to work on,
# and I do a lot of cd ..; ls; cd next-thing-alphabetically
#
next-project() {
    local where="$(python3 -c "
import os, pathlib, sys
here = pathlib.Path(os.getenv('PWD')).absolute()
basedir = pathlib.Path('~/projects').expanduser()
projects = sorted(p for p in basedir.glob('*') if not p.name.startswith('.'))
if here == basedir:
    print('This is the first project', file=sys.stderr)
    print(projects[0].name)
    sys.exit()
try:
    n = projects.index(here)
except ValueError:
    print(here, file=sys.stderr)
    sys.exit('''You're not in ~/projects/*''')
try:
    print(f'../{projects[n + 1].name}')
except IndexError:
    print('That was the last project', file=sys.stderr)
    print('..')
 ")"
    if [ -n "$where" ]; then
        echo "+ cd $where"
        cd "$where"
    fi
}

# vim: ft=sh
