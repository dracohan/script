def foo(debug=True):
    'determine if in debug mode with default argument'
    if debug:
        print 'in debug mode'
    print 'done'

foo()
foo(False)