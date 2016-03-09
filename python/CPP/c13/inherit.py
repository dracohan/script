class P(object):
    def foo(self):
        print 'Hi, I am P-foo()'
class C(P):
    def foo(self):
        super(C, self).foo()
        print 'Hi, I am C-foo()'

