# see offlineimap(1)
#
priority = {'IN.personal': -10,
            'INBOX': -10,
            'postponed': -7,
            'mbox': -1,
            'sent-mail': -1,
            'IN.b4net': 5,
            'SPAM': 10,
            'IN.SPAM': 10,
            'IN.virus': 10,
           }

def prioritize(x):
    if x.startswith('IN'):
        default = -5
    else:
        default = 0
    return priority.get(x, default)

def mycmp(x, y):
    return cmp((prioritize(x), x),
               (prioritize(y), y))

