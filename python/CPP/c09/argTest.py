import sys
import stat
import os
print 'you entered', len(sys.argv),'arguments...'
print 'they were:', str(sys.argv)
print(os.getcwd())
print(os.listdir(os.getcwd()))
os.chmod('/mnt/hgfs/code/script/python/CPP/c09/file1', stat.S_IRUSR+stat.S_IWUSR)

def test_var_args(farg, *args):
    print "formal arg:", farg
    for arg in args:
        print "another arg:", arg

test_var_args(1, "two", 3)

def test_var_kwargs(farg, **kwargs):
    print "formal arg:", farg
    for key in kwargs:
        print "another keyword arg: %s: %s" % (key, kwargs[key])

test_var_kwargs(farg=1, myarg2="two", myarg3=3)