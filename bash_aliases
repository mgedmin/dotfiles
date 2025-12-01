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

# work on advent of code, eh
aoc() {
  local year=$(date +%Y)
  local day=
  local mkdir=no
  if [ $(date +%m) = 12 ]; then
    day=day$(date +%d)
    mkdir=yes
  else
    year=$((year - 1))
  fi
  if [[ $1 == 20[0-9][0-9] ]]; then
    year=$1
    day=
    mkdir=no
    shift
  fi
  if [[ $1 == [0-9] ]]; then
    day=day0$1
    mkdir=no
    shift
  elif [[ $1 == [0-3][0-9] ]]; then
    day=day$1
    mkdir=no
    shift
  fi
  local dir=~/src/advent-of-code/$year
  if [ -n "$day" ]; then
    dir=$dir/$day
  fi
  if [ $mkdir = yes ] && ! [ -d $dir ]; then
    mkdir -p $dir
  fi
  cd $dir || return 1
}


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
