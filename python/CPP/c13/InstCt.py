class InstCt(object):
    count = 0              # count is class attr
    __myattr__=0
    _newattr__=1
    _test=2

    def __init__(self):         # increment count
        InstCt.count += 1

    def __del__(self):          # decrement count
        InstCt.count -= 1

    def howMany(self):          # return count
        return InstCt.count
