# see offlineimap(1)
#
priority = {
    'IN.personal': -10,
    'INBOX': -10,
    'IN.root': -9,
    'postponed': -7,
    # default priority for IN.*: -5
    'IN.github': -4,
    'IN.vim': -4,
    'IN.pylons': -2,
    'IN.zope-dev': -2,
    'IN.bujold': -2,
    'mbox': -1,
    'sent-mail': -1,
    # default priority: 0
    'IN.b4net': 5,
    'SPAM': 10,
    'IN.SPAM': 10,
    'IN.virus': 10,
}


def prioritize(x):
    # old offlineimap: x is a folder name
    # new offlineimap: x is an IMAPFolder object
    name = getattr(x, 'name', x)
    if name.startswith('IN'):
        default = -5
    else:
        default = 0
    return (priority.get(name.replace('/', '.'), default), name)


def mycmp(x, y):
    a = prioritize(x)
    b = prioritize(y)
    if a > b:
        return 1
    if a < b:
        return -1
    return 0
