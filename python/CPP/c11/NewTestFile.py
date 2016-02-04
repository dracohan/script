def foo():
    pass

def bar():
    'adf'

bar.__doc__ = 'Oopsshit'
bar.version = 0.1
print(bar.__doc__)
