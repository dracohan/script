class InstCt(object):
    count = 0              # count is class attr

    def __init__(self):         # increment count
        InstCt.count += 1

    def __del__(self):          # decrement count
        InstCt.count -= 1

    def howMany(self):          # return count
        return InstCt.count
