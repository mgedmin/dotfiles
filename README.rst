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


Features
--------

Files in dot directories are supported now (e.g.
``dotfiles/grab.sh ~/.config/yamllint/config``).

You can have dotfiles specific to one machine, distinguished by the hostname.
This is automatic: when a dotfile is named ``~/.something.local``, it'll be
symlinked to ``~/dotfiles/something.local.$HOSTNAME``.  Usually this requires
you to have a shared ``~/.something`` that includes ``~/.something.local``.
There's one exception, ``~/.mailcheckrc``, which is treated as local even if it
doesn't have the ``.local`` suffix (because mailcheck doesn't support
includes).


Shortcomings
------------

- The location of ``~/dotfiles`` is hardcoded in the scripts.

- You cannot version entire dot directories, just individual files inside
  them.
