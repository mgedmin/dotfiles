Marius's dotfiles
=================

Instructions to self
--------------------

To start using on a new machine:

1. check out the dotfiles repo into ``~/dotfiles``::

        git clone https://github.com/mgedmin/dotfiles

2. run ``~/dotfiles/install.sh``

It will replace ``~/.randomdotfile`` with symlinks to ``~/dotfiles/randomdotfile``,
*safely*.  If you have a conflict (``~/.foo`` exists and differs in content from
``~/dotfiles/foo``), the install script will warn and keep your current ``~/.foo``,
so you don't have to worry about accidentally losing data.

You need to re-run the install script every time you pull in new dotfiles from
a remote repository.  Running ``~/dotfiles/update.sh`` does that (git pull +
running install.sh).

To add a new dotfile to your collection:

1. run ``~/dotfiles/grab.sh ~/.dotfilename``

It will move ``~/.dotfilename`` to ``~/dotfiles/dotfilename`` and create the
appropriate symlink.  Don't forget to commit the newly-added file!
