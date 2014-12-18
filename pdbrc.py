# config file for https://pypi.python.org/pypi/pdbpp/

import pdb


class Config(pdb.DefaultConfig):
    bg = 'light'
    # colors come from
    # https://bitbucket.org/antocuni/fancycompleter/src/fd77df8370df1a0da7875970581dde9221406544/fancycompleter.py?at=default#cl-39
    filename_color = '1' # just bold please
    line_number_color = pdb.Color.darkred
