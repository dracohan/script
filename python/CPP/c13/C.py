class C(object):              # class declaration
    def __init__(self):          # "constructor"
        print 'initialized'
    def __del__(self):           # "destructor"
        #object.__del__(self)    # call parent destructor
        print 'deleted'
