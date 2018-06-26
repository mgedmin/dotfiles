Marius's dotfiles
=================


Usage
-----

To start using on a new machine::

    git clone https://github.com/mgedmin/dotfiles
    . dotfiles/install.sh

To pull in new updates::

    . dotfiles/update.sh

To add a new dotfile to version control::

    ~/dotfiles/grab.sh ~/.dotfilename
    cd ~/dotfiles && git commit -av

To stop versioning a dotfile (if you accidentally added the wrong one)::

    ~/dotfiles/ungrab.sh ~/.dotfilename
    cd ~/dotfiles && git commit -av


How it works
------------

The scripts will replace ``~/.randomdotfile`` with symlinks to
``~/dotfiles/randomdotfile``, *safely*.  If you have a conflict (``~/.foo``
exists and differs in content from ``~/dotfiles/foo``), the install script will
print a warning and keep your current ``~/.foo``, so you don't have to worry
about accidentally losing data.

You need to re-run the install script every time you pull in *new* dotfiles (as
opposed to new versions of already symlinked dotfiles) from a remote
repository.  Running ``~/dotfiles/update.sh`` does that.

There's currently no provision for dealing with removed dotfiles -- you'll have
to clean up dangling symlinks manually.


Why I wrote my own scripts for this
-----------------------------------

I'm paranoid of losing data so I want to fully understand the code that's going
to be managing my dotfiles.  And the best way to understand code is to write
it.


Shortcomings
------------

- The location of ``~/dotfiles`` is hardcoded in the scripts.

- The scripts cannot manage dot directories such as ``~/.vim``, or dotfiles
  that live in a subdirectory such as ``~/.config/flake8``.
